-- Organizations and Multi-tenancy
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'org_role') THEN
    CREATE TYPE public.org_role AS ENUM ('owner', 'admin', 'member');
  END IF;
END
$$;

CREATE TABLE IF NOT EXISTS public.organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Seed a default organization if none exists
INSERT INTO public.organizations (name)
SELECT 'Default Organization'
WHERE NOT EXISTS (SELECT 1 FROM public.organizations);

-- moved below after adding organization_id to profiles

-- Add organization_id to core tables (nullable first, backfill, then not null)
DO $$
DECLARE
  _default_org UUID;
BEGIN
  SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;

  -- profiles
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'organization_id') THEN
    ALTER TABLE public.profiles ADD COLUMN organization_id UUID;
    UPDATE public.profiles SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.profiles ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.profiles ADD CONSTRAINT profiles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE RESTRICT;
  END IF;

  -- user_roles
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'user_roles' AND column_name = 'organization_id') THEN
    ALTER TABLE public.user_roles ADD COLUMN organization_id UUID;
    UPDATE public.user_roles ur
      SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.user_roles ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.user_roles ADD CONSTRAINT user_roles_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- departments
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'departments' AND column_name = 'organization_id') THEN
    ALTER TABLE public.departments ADD COLUMN organization_id UUID;
    UPDATE public.departments SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.departments ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.departments ADD CONSTRAINT departments_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- designations
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'designations' AND column_name = 'organization_id') THEN
    ALTER TABLE public.designations ADD COLUMN organization_id UUID;
    UPDATE public.designations SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.designations ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.designations ADD CONSTRAINT designations_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- companies
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'companies' AND column_name = 'organization_id') THEN
    ALTER TABLE public.companies ADD COLUMN organization_id UUID;
    UPDATE public.companies SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.companies ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.companies ADD CONSTRAINT companies_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- contacts
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'contacts' AND column_name = 'organization_id') THEN
    ALTER TABLE public.contacts ADD COLUMN organization_id UUID;
    UPDATE public.contacts SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.contacts ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.contacts ADD CONSTRAINT contacts_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- leads
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'organization_id') THEN
    ALTER TABLE public.leads ADD COLUMN organization_id UUID;
    UPDATE public.leads SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.leads ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.leads ADD CONSTRAINT leads_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- deals
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'deals' AND column_name = 'organization_id') THEN
    ALTER TABLE public.deals ADD COLUMN organization_id UUID;
    UPDATE public.deals SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.deals ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.deals ADD CONSTRAINT deals_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- employees
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'employees' AND column_name = 'organization_id') THEN
    ALTER TABLE public.employees ADD COLUMN organization_id UUID;
    UPDATE public.employees SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.employees ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.employees ADD CONSTRAINT employees_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- tasks
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'tasks' AND column_name = 'organization_id') THEN
    ALTER TABLE public.tasks ADD COLUMN organization_id UUID;
    UPDATE public.tasks SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.tasks ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.tasks ADD CONSTRAINT tasks_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- attendance
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'attendance' AND column_name = 'organization_id') THEN
    ALTER TABLE public.attendance ADD COLUMN organization_id UUID;
    UPDATE public.attendance SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.attendance ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.attendance ADD CONSTRAINT attendance_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- payroll
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payroll' AND column_name = 'organization_id') THEN
    ALTER TABLE public.payroll ADD COLUMN organization_id UUID;
    UPDATE public.payroll SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.payroll ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.payroll ADD CONSTRAINT payroll_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- leave_requests
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leave_requests' AND column_name = 'organization_id') THEN
    ALTER TABLE public.leave_requests ADD COLUMN organization_id UUID;
    UPDATE public.leave_requests SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.leave_requests ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.leave_requests ADD CONSTRAINT leave_requests_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- activity_logs
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'activity_logs' AND column_name = 'organization_id') THEN
    ALTER TABLE public.activity_logs ADD COLUMN organization_id UUID;
    UPDATE public.activity_logs SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.activity_logs ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.activity_logs ADD CONSTRAINT activity_logs_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  -- chat tables
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'chat_channels' AND column_name = 'organization_id') THEN
    ALTER TABLE public.chat_channels ADD COLUMN organization_id UUID;
    UPDATE public.chat_channels SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.chat_channels ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.chat_channels ADD CONSTRAINT chat_channels_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'chat_participants' AND column_name = 'organization_id') THEN
    ALTER TABLE public.chat_participants ADD COLUMN organization_id UUID;
    UPDATE public.chat_participants cp
      SET organization_id = COALESCE(organization_id, (SELECT organization_id FROM public.chat_channels cc WHERE cc.id = cp.channel_id));
    ALTER TABLE public.chat_participants ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.chat_participants ADD CONSTRAINT chat_participants_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'chat_messages' AND column_name = 'organization_id') THEN
    ALTER TABLE public.chat_messages ADD COLUMN organization_id UUID;
    UPDATE public.chat_messages cm
      SET organization_id = COALESCE(organization_id, (SELECT organization_id FROM public.chat_channels cc WHERE cc.id = cm.channel_id));
    ALTER TABLE public.chat_messages ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.chat_messages ADD CONSTRAINT chat_messages_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Helper: get current user's organization_id (create after profiles.organization_id exists)
CREATE OR REPLACE FUNCTION public.current_org_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT organization_id FROM public.profiles WHERE id = auth.uid()
$$;

-- Triggers to set organization_id on insert if NULL
CREATE OR REPLACE FUNCTION public.set_org_id_on_insert()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DO $$
DECLARE 
  _tbl text;
BEGIN
  -- Attach trigger to key tables
  FOREACH _tbl IN ARRAY ARRAY[
    'profiles','user_roles','departments','designations','companies','contacts','leads',
    'deals','employees','tasks','attendance','payroll','leave_requests','activity_logs',
    'chat_channels','chat_participants','chat_messages'
  ]
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS trg_set_org_on_insert_%I ON public.%I', _tbl, _tbl);
    EXECUTE format('CREATE TRIGGER trg_set_org_on_insert_%I BEFORE INSERT ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()', _tbl, _tbl);
  END LOOP;
END $$;

-- Basic org-aware policies: limit access to records in same organization
DO $$
DECLARE 
  _tbl text;
BEGIN
  -- SELECT/INSERT/UPDATE/DELETE org-aware policies
  FOREACH _tbl IN ARRAY ARRAY[
    'departments','designations','companies','contacts','leads',
    'deals','employees','tasks','attendance','payroll','leave_requests','activity_logs',
    'chat_channels','chat_participants','chat_messages'
  ]
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "org_select_%I" ON public.%I', _tbl, _tbl);
    EXECUTE format('CREATE POLICY "org_select_%I" ON public.%I FOR SELECT USING (organization_id = public.current_org_id())', _tbl, _tbl);
    EXECUTE format('DROP POLICY IF EXISTS "org_insert_%I" ON public.%I', _tbl, _tbl);
    EXECUTE format('CREATE POLICY "org_insert_%I" ON public.%I FOR INSERT WITH CHECK (organization_id = public.current_org_id())', _tbl, _tbl);
    EXECUTE format('DROP POLICY IF EXISTS "org_update_%I" ON public.%I', _tbl, _tbl);
    EXECUTE format('CREATE POLICY "org_update_%I" ON public.%I FOR UPDATE USING (organization_id = public.current_org_id()) WITH CHECK (organization_id = public.current_org_id())', _tbl, _tbl);
    EXECUTE format('DROP POLICY IF EXISTS "org_delete_%I" ON public.%I', _tbl, _tbl);
    EXECUTE format('CREATE POLICY "org_delete_%I" ON public.%I FOR DELETE USING (organization_id = public.current_org_id())', _tbl, _tbl);
  END LOOP;
END $$;
