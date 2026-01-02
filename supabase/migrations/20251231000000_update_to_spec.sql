-- Align schema with updates.md for Projects, Project Tasks, Project Meetings, and Chat auto-creation
-- Idempotent changes where possible

-- Extend app_role to include additional roles if missing
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'app_role') THEN
    CREATE TYPE public.app_role AS ENUM ('admin','manager','employee');
  END IF;
  -- Add new roles to existing enum
  BEGIN
    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'tenant_admin';
  EXCEPTION WHEN duplicate_object THEN NULL; END;
  BEGIN
    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'hr';
  EXCEPTION WHEN duplicate_object THEN NULL; END;
  BEGIN
    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'finance';
  EXCEPTION WHEN duplicate_object THEN NULL; END;
  BEGIN
    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'viewer';
  EXCEPTION WHEN duplicate_object THEN NULL; END;
  BEGIN
    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'super_admin';
  EXCEPTION WHEN duplicate_object THEN NULL; END;
END $$;

-- Enforce uniqueness for Tenant Admin per organization (treat legacy 'admin' as tenant admin equivalent)
-- DO $$
-- BEGIN
--   IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'one_tenant_admin_per_org') THEN
--     CREATE UNIQUE INDEX one_tenant_admin_per_org ON public.user_roles(organization_id)
--     WHERE role IN ('tenant_admin','admin');
--   END IF;
-- END $$;

-- Tenant modules per organization
CREATE TABLE IF NOT EXISTS public.tenant_modules (
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  module_name TEXT NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (organization_id, module_name)
);

-- Project Tasks (isolated from global tasks)
CREATE TABLE IF NOT EXISTS public.project_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'todo',
  priority TEXT NOT NULL DEFAULT 'medium',
  assigned_to UUID NULL REFERENCES auth.users(id),
  created_by UUID NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;
-- Basic org-scoped visibility via project linkage
DROP POLICY IF EXISTS org_select_project_tasks ON public.project_tasks;
CREATE POLICY org_select_project_tasks ON public.project_tasks
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
DROP POLICY IF EXISTS org_insert_project_tasks ON public.project_tasks;
CREATE POLICY org_insert_project_tasks ON public.project_tasks
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
DROP POLICY IF EXISTS org_update_project_tasks ON public.project_tasks;
CREATE POLICY org_update_project_tasks ON public.project_tasks
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id
        AND p.organization_id = public.current_org_id()
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
DROP POLICY IF EXISTS org_delete_project_tasks ON public.project_tasks;
CREATE POLICY org_delete_project_tasks ON public.project_tasks
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id
        AND p.organization_id = public.current_org_id()
    )
  );

-- Project Meetings (separate from org-level meetings)
CREATE TABLE IF NOT EXISTS public.project_meetings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  meeting_link TEXT,
  created_by UUID NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS org_select_project_meetings ON public.project_meetings;
CREATE POLICY org_select_project_meetings ON public.project_meetings
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_meetings.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
DROP POLICY IF EXISTS org_insert_project_meetings ON public.project_meetings;
CREATE POLICY org_insert_project_meetings ON public.project_meetings
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_meetings.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
DROP POLICY IF EXISTS org_update_project_meetings ON public.project_meetings;
CREATE POLICY org_update_project_meetings ON public.project_meetings
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_meetings.project_id
        AND p.organization_id = public.current_org_id()
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_meetings.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
DROP POLICY IF EXISTS org_delete_project_meetings ON public.project_meetings;
CREATE POLICY org_delete_project_meetings ON public.project_meetings
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_meetings.project_id
        AND p.organization_id = public.current_org_id()
    )
  );

-- Auto-create project chat channel on project creation
CREATE OR REPLACE FUNCTION public.create_project_chat()
RETURNS TRIGGER AS $$
DECLARE
  _chan_id UUID;
BEGIN
  -- Create a group chat channel linked to project
  INSERT INTO public.chat_channels (type, name, created_by, project_id)
  VALUES ('group', COALESCE('Project: ' || NEW.name, 'Project Chat'), auth.uid(), NEW.id)
  RETURNING id INTO _chan_id;

  -- Add creator as participant
  INSERT INTO public.chat_participants (channel_id, user_id)
  VALUES (_chan_id, auth.uid());

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_create_project_chat ON public.projects;
CREATE TRIGGER trg_create_project_chat
  AFTER INSERT ON public.projects
  FOR EACH ROW EXECUTE FUNCTION public.create_project_chat();

-- Auto-join project members to project chat
CREATE OR REPLACE FUNCTION public.add_member_to_project_chat()
RETURNS TRIGGER AS $$
DECLARE
  _chan_id UUID;
  _user_id UUID;
BEGIN
  -- Find channel for project
  SELECT id INTO _chan_id FROM public.chat_channels WHERE project_id = NEW.project_id LIMIT 1;
  IF _chan_id IS NULL THEN
    RETURN NEW;
  END IF;
  -- Resolve auth user_id from employees
  SELECT user_id INTO _user_id FROM public.employees WHERE id = NEW.employee_id LIMIT 1;
  IF _user_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Insert participant if not already present
  INSERT INTO public.chat_participants (channel_id, user_id)
  SELECT _chan_id, _user_id
  WHERE NOT EXISTS (
    SELECT 1 FROM public.chat_participants WHERE channel_id = _chan_id AND user_id = _user_id
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_add_member_to_project_chat ON public.project_members;
CREATE TRIGGER trg_add_member_to_project_chat
  AFTER INSERT ON public.project_members
  FOR EACH ROW EXECUTE FUNCTION public.add_member_to_project_chat();

-- Auto-create department chat channel on department creation
CREATE OR REPLACE FUNCTION public.create_department_chat()
RETURNS TRIGGER AS $$
DECLARE
  _chan_id UUID;
BEGIN
  INSERT INTO public.chat_channels (type, name, created_by)
  VALUES ('group', COALESCE('Department: ' || NEW.name, 'Department Chat'), auth.uid())
  RETURNING id INTO _chan_id;
  -- Creator joins automatically via existing trigger
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_create_department_chat ON public.departments;
CREATE TRIGGER trg_create_department_chat
  AFTER INSERT ON public.departments
  FOR EACH ROW EXECUTE FUNCTION public.create_department_chat();

