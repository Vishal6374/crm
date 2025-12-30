-- Role capabilities per organization
CREATE TABLE IF NOT EXISTS public.role_capabilities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  role public.app_role NOT NULL,
  module TEXT NOT NULL,
  can_view BOOLEAN NOT NULL DEFAULT true,
  can_create BOOLEAN NOT NULL DEFAULT false,
  can_edit BOOLEAN NOT NULL DEFAULT false,
  can_approve BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (organization_id, role, module)
);

-- Seed defaults for existing org
DO $$
DECLARE
  _org UUID;
BEGIN
  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;
  -- Admin: full access to all modules
  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
  SELECT _org, 'admin', m, true, true, true, true
  FROM unnest(ARRAY['leads','deals','tasks','calendar','payroll','attendance','reports','chat','leave_requests']) AS m
  ON CONFLICT DO NOTHING;

  -- Manager: broad access except payroll approval
  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
  VALUES 
    (_org, 'manager', 'leads', true, true, true, false),
    (_org, 'manager', 'deals', true, true, true, false),
    (_org, 'manager', 'tasks', true, true, true, false),
    (_org, 'manager', 'calendar', true, false, false, false),
    (_org, 'manager', 'attendance', true, true, true, false),
    (_org, 'manager', 'payroll', true, false, false, false),
    (_org, 'manager', 'reports', true, false, false, false),
    (_org, 'manager', 'chat', true, true, false, false),
    (_org, 'manager', 'leave_requests', true, false, true, true)
  ON CONFLICT DO NOTHING;

  -- Employee: limited access
  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
  VALUES 
    (_org, 'employee', 'leads', true, false, false, false),
    (_org, 'employee', 'deals', true, false, false, false),
    (_org, 'employee', 'tasks', true, true, true, false),
    (_org, 'employee', 'calendar', true, false, false, false),
    (_org, 'employee', 'attendance', true, false, false, false),
    (_org, 'employee', 'payroll', true, false, false, false),
    (_org, 'employee', 'reports', false, false, false, false),
    (_org, 'employee', 'chat', true, true, false, false),
    (_org, 'employee', 'leave_requests', true, true, false, false)
  ON CONFLICT DO NOTHING;
END $$;

-- Capability function
CREATE OR REPLACE FUNCTION public.can_capability(_user_id UUID, _module TEXT, _cap TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _org UUID;
  _role public.app_role;
  _cap_row RECORD;
BEGIN
  SELECT organization_id INTO _org FROM public.profiles WHERE id = _user_id;
  IF _org IS NULL THEN
    RETURN false;
  END IF;
  SELECT role INTO _role FROM public.user_roles WHERE user_id = _user_id AND organization_id = _org LIMIT 1;
  IF _role IS NULL THEN
    RETURN false;
  END IF;
  SELECT * INTO _cap_row FROM public.role_capabilities 
    WHERE organization_id = _org AND role = _role AND module = _module LIMIT 1;
  IF NOT FOUND THEN
    RETURN false;
  END IF;
  IF _cap = 'can_view' THEN
    RETURN COALESCE(_cap_row.can_view, false);
  ELSIF _cap = 'can_create' THEN
    RETURN COALESCE(_cap_row.can_create, false);
  ELSIF _cap = 'can_edit' THEN
    RETURN COALESCE(_cap_row.can_edit, false);
  ELSIF _cap = 'can_approve' THEN
    RETURN COALESCE(_cap_row.can_approve, false);
  ELSE
    RETURN false;
  END IF;
END;
$$;

-- Strengthen RLS: require capability for write operations
-- Leads
DROP POLICY IF EXISTS "org_insert_leads" ON public.leads;
DROP POLICY IF EXISTS "org_update_leads" ON public.leads;
CREATE POLICY "org_insert_leads" ON public.leads
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'leads', 'can_create')
  );
CREATE POLICY "org_update_leads" ON public.leads
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'leads', 'can_edit')
  )
  WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'leads', 'can_edit')
  );

-- Deals
DROP POLICY IF EXISTS "org_insert_deals" ON public.deals;
DROP POLICY IF EXISTS "org_update_deals" ON public.deals;
CREATE POLICY "org_insert_deals" ON public.deals
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'deals', 'can_create')
  );
CREATE POLICY "org_update_deals" ON public.deals
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'deals', 'can_edit')
  )
  WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'deals', 'can_edit')
  );

-- Tasks
DROP POLICY IF EXISTS "org_insert_tasks" ON public.tasks;
DROP POLICY IF EXISTS "org_update_tasks" ON public.tasks;
CREATE POLICY "org_insert_tasks" ON public.tasks
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'tasks', 'can_create')
  );
CREATE POLICY "org_update_tasks" ON public.tasks
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND (
      public.can_capability(auth.uid(), 'tasks', 'can_edit')
      OR assigned_to = auth.uid()
      OR created_by = auth.uid()
    )
  )
  WITH CHECK (
    organization_id = public.current_org_id()
    AND (
      public.can_capability(auth.uid(), 'tasks', 'can_edit')
      OR assigned_to = auth.uid()
      OR created_by = auth.uid()
    )
  );

-- Payroll
DROP POLICY IF EXISTS "org_insert_payroll" ON public.payroll;
DROP POLICY IF EXISTS "org_update_payroll" ON public.payroll;
CREATE POLICY "org_insert_payroll" ON public.payroll
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'payroll', 'can_create')
  );
CREATE POLICY "org_update_payroll" ON public.payroll
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'payroll', 'can_edit')
  )
  WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'payroll', 'can_edit')
  );

-- Leave Requests
DROP POLICY IF EXISTS "org_insert_leave_requests" ON public.leave_requests;
DROP POLICY IF EXISTS "org_update_leave_requests" ON public.leave_requests;
CREATE POLICY "org_insert_leave_requests" ON public.leave_requests
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'leave_requests', 'can_create')
  );
CREATE POLICY "org_update_leave_requests" ON public.leave_requests
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'leave_requests', 'can_approve')
  )
  WITH CHECK (
    organization_id = public.current_org_id()
    AND public.can_capability(auth.uid(), 'leave_requests', 'can_approve')
  );

