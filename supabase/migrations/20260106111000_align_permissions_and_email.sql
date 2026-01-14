-- Spec alignment: Email module + tighten role-based permissions and notifications
-- Idempotent and org-aware, matching existing conventions (organization_id, role_capabilities, current_org_id)
-- 1) Email module schema
-- 2) Seed tenant_modules and role_capabilities for 'email'
-- 3) Bulk send enqueue functions with variable resolution
-- 4) Tighten RLS for leads, deals, employees, departments, designations, events (calendar reschedule restriction)
-- 5) Chat message notifications
-- 6) Activity logs retention (latest 500 per org)

BEGIN;

-- 1) Email module schema
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='email_templates') THEN
    CREATE TABLE public.email_templates (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
      name TEXT NOT NULL,
      subject TEXT NOT NULL,
      body TEXT NOT NULL,
      created_by UUID NOT NULL REFERENCES auth.users(id),
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='email_batches') THEN
    CREATE TABLE public.email_batches (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
      template_id UUID NOT NULL REFERENCES public.email_templates(id) ON DELETE CASCADE,
      target_role public.app_role NULL,
      created_by UUID NOT NULL REFERENCES auth.users(id),
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN ('queued','processing','sent','failed'))
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='email_batch_recipients') THEN
    CREATE TABLE public.email_batch_recipients (
      batch_id UUID NOT NULL REFERENCES public.email_batches(id) ON DELETE CASCADE,
      user_id UUID NOT NULL REFERENCES auth.users(id),
      email TEXT NOT NULL,
      subject TEXT NOT NULL,
      body TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN ('queued','sent','failed')),
      sent_at TIMESTAMPTZ,
      PRIMARY KEY (batch_id, user_id)
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='email_events') THEN
    CREATE TABLE public.email_events (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      batch_id UUID NOT NULL REFERENCES public.email_batches(id) ON DELETE CASCADE,
      user_id UUID NOT NULL REFERENCES auth.users(id),
      event TEXT NOT NULL CHECK (event IN ('queued','sent','failed')),
      message TEXT,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );
  END IF;
END $$;

-- Enable RLS
ALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_batch_recipients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_events ENABLE ROW LEVEL SECURITY;

-- Org-aware policies for Email Module
DROP POLICY IF EXISTS org_select_email_templates ON public.email_templates;
CREATE POLICY org_select_email_templates ON public.email_templates
  FOR SELECT USING (organization_id = public.current_org_id());

DROP POLICY IF EXISTS org_modify_email_templates ON public.email_templates;
CREATE POLICY org_modify_email_templates ON public.email_templates
  FOR ALL USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'email', 'can_edit')
  ) WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'email', 'can_edit')
  );

DROP POLICY IF EXISTS org_select_email_batches ON public.email_batches;
CREATE POLICY org_select_email_batches ON public.email_batches
  FOR SELECT USING (organization_id = public.current_org_id());

DROP POLICY IF EXISTS org_modify_email_batches ON public.email_batches;
CREATE POLICY org_modify_email_batches ON public.email_batches
  FOR ALL USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'email', 'can_create')
  ) WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'email', 'can_create')
  );

DROP POLICY IF EXISTS org_select_email_recipients ON public.email_batch_recipients;
CREATE POLICY org_select_email_recipients ON public.email_batch_recipients
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.email_batches b
      WHERE b.id = email_batch_recipients.batch_id
        AND b.organization_id = public.current_org_id()
    )
  );

DROP POLICY IF EXISTS org_modify_email_recipients ON public.email_batch_recipients;
CREATE POLICY org_modify_email_recipients ON public.email_batch_recipients
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.email_batches b
      WHERE b.id = email_batch_recipients.batch_id
        AND b.organization_id = public.current_org_id()
        AND public.can_capability(auth.uid(), 'email', 'can_create')
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.email_batches b
      WHERE b.id = email_batch_recipients.batch_id
        AND b.organization_id = public.current_org_id()
        AND public.can_capability(auth.uid(), 'email', 'can_create')
    )
  );

DROP POLICY IF EXISTS org_select_email_events ON public.email_events;
CREATE POLICY org_select_email_events ON public.email_events
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.email_batches b
      WHERE b.id = email_events.batch_id
        AND b.organization_id = public.current_org_id()
    )
  );

DROP POLICY IF EXISTS org_insert_email_events ON public.email_events;
CREATE POLICY org_insert_email_events ON public.email_events
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.email_batches b
      WHERE b.id = email_events.batch_id
        AND b.organization_id = public.current_org_id()
        AND public.can_capability(auth.uid(), 'email', 'can_create')
    )
  );

-- 2) Seed tenant_modules and role_capabilities for 'email'
DO $$
DECLARE
  _org UUID;
BEGIN
  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;
  IF _org IS NOT NULL THEN
      -- Try to insert using module_name (if table created by update_to_spec.sql)
      BEGIN
        INSERT INTO public.tenant_modules(organization_id, module_name, enabled)
        VALUES (_org, 'email', true)
        ON CONFLICT (organization_id, module_name) DO NOTHING;
      EXCEPTION WHEN undefined_column THEN
        -- Fallback to module (if table created by roles_modules_constraints.sql)
        INSERT INTO public.tenant_modules(organization_id, module, enabled)
        VALUES (_org, 'email', true)
        ON CONFLICT (organization_id, module) DO NOTHING;
      END;

      -- Tenant Admin and Admin get full email capabilities
      INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
      VALUES 
        (_org, 'tenant_admin', 'email', true, true, true, true),
        (_org, 'admin', 'email', true, true, true, true)
      ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- 3) Bulk send enqueue functions with variable resolution
CREATE OR REPLACE FUNCTION public.resolve_email_template(_template_id UUID, _user_id UUID)
RETURNS TABLE(subject TEXT, body TEXT)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _sub TEXT;
  _body TEXT;
  _name TEXT;
  _role TEXT;
BEGIN
  SELECT subject, body INTO _sub, _body FROM public.email_templates WHERE id = _template_id;
  SELECT COALESCE(full_name, email) INTO _name FROM public.profiles WHERE id = _user_id;
  SELECT ur.role::TEXT INTO _role FROM public.user_roles ur WHERE ur.user_id = _user_id AND ur.organization_id = public.current_org_id() LIMIT 1;

  _sub := replace(_sub, '{{name}}', COALESCE(_name, ''));
  _sub := replace(_sub, '{{role}}', COALESCE(_role, ''));
  _body := replace(_body, '{{name}}', COALESCE(_name, ''));
  _body := replace(_body, '{{role}}', COALESCE(_role, ''));
  RETURN QUERY SELECT _sub, _body;
END;
$$;

CREATE OR REPLACE FUNCTION public.enqueue_bulk_email(_template_id UUID, _target_role public.app_role DEFAULT NULL)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _batch_id UUID;
  _org UUID;
  _uid UUID := auth.uid();
  rec RECORD;
  _sub TEXT;
  _body TEXT;
BEGIN
  _org := public.current_org_id();
  IF NOT public.can_capability(_uid, 'email', 'can_create') THEN
    RAISE EXCEPTION 'not authorized';
  END IF;

  INSERT INTO public.email_batches (organization_id, template_id, target_role, created_by)
  VALUES (_org, _template_id, _target_role, _uid)
  RETURNING id INTO _batch_id;

  FOR rec IN
    SELECT p.id AS user_id, p.email
    FROM public.profiles p
    JOIN public.user_roles ur ON ur.user_id = p.id AND ur.organization_id = _org
    WHERE (_target_role IS NULL OR ur.role = _target_role)
  LOOP
    SELECT subject, body INTO _sub, _body FROM public.resolve_email_template(_template_id, rec.user_id);
    INSERT INTO public.email_batch_recipients (batch_id, user_id, email, subject, body)
    VALUES (_batch_id, rec.user_id, rec.email, _sub, _body)
    ON CONFLICT (batch_id, user_id) DO NOTHING;

    INSERT INTO public.email_events (batch_id, user_id, event, message)
    VALUES (_batch_id, rec.user_id, 'queued', 'queued for send');
  END LOOP;

  RETURN _batch_id;
END;
$$;

-- 4) Tighten RLS across modules

-- Leads
DROP POLICY IF EXISTS "org_select_leads" ON public.leads;
DROP POLICY IF EXISTS "assignment_based_select_leads" ON public.leads;
CREATE POLICY assignment_based_select_leads ON public.leads
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND (
      created_by = auth.uid()
      OR assigned_to = auth.uid()
      OR EXISTS (
        SELECT 1 FROM public.user_roles ur
        WHERE ur.user_id = auth.uid()
          AND ur.organization_id = public.current_org_id()
          AND ur.role IN ('tenant_admin','admin')
      )
    )
  );

-- Deals
DROP POLICY IF EXISTS "org_select_deals" ON public.deals;
DROP POLICY IF EXISTS "role_scoped_select_deals" ON public.deals;
CREATE POLICY role_scoped_select_deals ON public.deals
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND (
      created_by = auth.uid()
      OR assigned_to = auth.uid()
      OR EXISTS (
        SELECT 1 FROM public.user_roles ur
        WHERE ur.user_id = auth.uid()
          AND ur.organization_id = public.current_org_id()
          AND ur.role IN ('tenant_admin','admin','manager')
      )
    )
  );

-- Employees
DROP POLICY IF EXISTS "org_select_employees" ON public.employees;
DROP POLICY IF EXISTS "Authenticated users can view employees" ON public.employees;
DROP POLICY IF EXISTS "scoped_select_employees" ON public.employees;
CREATE POLICY scoped_select_employees ON public.employees
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND (
      EXISTS (
        SELECT 1 FROM public.role_capabilities rc
        JOIN public.user_roles ur ON ur.user_id = auth.uid() AND ur.organization_id = rc.organization_id AND ur.role = rc.role
        WHERE rc.organization_id = public.current_org_id()
          AND rc.module = 'employees'
          AND rc.can_view = true
      )
      OR EXISTS (
        SELECT 1 FROM public.employees e WHERE e.id = employees.id AND e.user_id = auth.uid()
      )
    )
  );

-- Departments
DROP POLICY IF EXISTS "org_select_departments" ON public.departments;
DROP POLICY IF EXISTS "scoped_select_departments" ON public.departments;
CREATE POLICY scoped_select_departments ON public.departments
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND EXISTS (
      SELECT 1 FROM public.role_capabilities rc
      JOIN public.user_roles ur ON ur.user_id = auth.uid() AND ur.organization_id = rc.organization_id AND ur.role = rc.role
      WHERE rc.organization_id = public.current_org_id()
        AND rc.module = 'departments'
        AND rc.can_view = true
    )
  );

-- Designations
DROP POLICY IF EXISTS "org_select_designations" ON public.designations;
DROP POLICY IF EXISTS "scoped_select_designations" ON public.designations;
CREATE POLICY scoped_select_designations ON public.designations
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND EXISTS (
      SELECT 1 FROM public.role_capabilities rc
      JOIN public.user_roles ur ON ur.user_id = auth.uid() AND ur.organization_id = rc.organization_id AND ur.role = rc.role
      WHERE rc.organization_id = public.current_org_id()
        AND rc.module = 'designations'
        AND rc.can_view = true
    )
  );

-- Calendar: add organization_id to events and restrict reschedule (employees cannot update)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='events' AND column_name='organization_id') THEN
    ALTER TABLE public.events ADD COLUMN organization_id UUID;
  END IF;
  UPDATE public.events SET organization_id = COALESCE(organization_id, public.current_org_id()) WHERE organization_id IS NULL;
  ALTER TABLE public.events ALTER COLUMN organization_id SET NOT NULL;
  ALTER TABLE public.events DROP CONSTRAINT IF EXISTS events_org_fkey;
  ALTER TABLE public.events ADD CONSTRAINT events_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
END $$;

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS org_select_events ON public.events;
CREATE POLICY org_select_events ON public.events
  FOR SELECT USING (organization_id = public.current_org_id());

DROP POLICY IF EXISTS org_update_events ON public.events;
CREATE POLICY org_update_events ON public.events
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'calendar', 'can_edit')
    AND NOT EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid()
        AND ur.organization_id = public.current_org_id()
        AND ur.role = 'employee'
    )
  ) WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'calendar', 'can_edit')
    AND NOT EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid()
        AND ur.organization_id = public.current_org_id()
        AND ur.role = 'employee'
    )
  );

-- 5) Chat message notifications: notify participants (excluding sender)
CREATE OR REPLACE FUNCTION public.notify_chat_message()
RETURNS TRIGGER AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT cp.user_id
    FROM public.chat_participants cp
    JOIN public.chat_channels cc ON cc.id = cp.channel_id
    WHERE cp.channel_id = NEW.channel_id
      AND cc.organization_id = public.current_org_id()
      AND cp.user_id <> NEW.sender_id
  LOOP
    INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)
    VALUES (rec.user_id, 'chat', 'New Message', LEFT(NEW.content, 140), 'chat_channel', NEW.channel_id, public.current_org_id());
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_chat_message ON public.chat_messages;
CREATE TRIGGER trg_notify_chat_message
  AFTER INSERT ON public.chat_messages
  FOR EACH ROW EXECUTE FUNCTION public.notify_chat_message();

-- 6) Activity logs retention: keep latest 500 per organization
CREATE OR REPLACE FUNCTION public.prune_activity_logs()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM public.activity_logs a
  WHERE a.organization_id = NEW.organization_id
    AND a.id IN (
      SELECT id FROM public.activity_logs
      WHERE organization_id = NEW.organization_id
      ORDER BY created_at DESC
      OFFSET 500
    );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_prune_activity_logs ON public.activity_logs;
CREATE TRIGGER trg_prune_activity_logs
  AFTER INSERT ON public.activity_logs
  FOR EACH ROW EXECUTE FUNCTION public.prune_activity_logs();

COMMIT;
