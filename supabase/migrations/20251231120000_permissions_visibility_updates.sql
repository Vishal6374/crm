-- Strengthen visibility and permissions per updates.md
-- 1) Create missing tables: project_meetings, project_tasks
-- 2) Projects visibility: only creator or assigned member can see
-- 3) Project meetings creation: only project manager can create
-- 4) Role capabilities: allow managers to create calendar meetings
-- 5) Auto-create chat channels for projects and add members

-- Ensure chat_type enum has 'project'
ALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'project';

-- Create project_meetings table if not exists
CREATE TABLE IF NOT EXISTS public.project_meetings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  scheduled_at TIMESTAMPTZ NOT NULL,
  meeting_link TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Create project_tasks table if not exists
CREATE TABLE IF NOT EXISTS public.project_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'todo',
  priority TEXT DEFAULT 'medium',
  assigned_to UUID REFERENCES auth.users(id),
  created_by UUID REFERENCES auth.users(id),
  due_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;

-- Projects SELECT policy: creator or assigned member, within org
DO $$
BEGIN
  -- Drop existing simple org-select policy if present
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'org_select_projects'
  ) THEN
    EXECUTE 'DROP POLICY "org_select_projects" ON public.projects';
  END IF;

  -- Create new visibility policy if not exists
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'creator_or_member_select_projects'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "creator_or_member_select_projects" ON public.projects
        FOR SELECT USING (
          organization_id = public.current_org_id()
          AND (
            owner_id = auth.uid()
            OR EXISTS (
              SELECT 1 
              FROM public.project_members pm
              JOIN public.employees e ON e.id = pm.employee_id
              WHERE pm.project_id = projects.id
                AND e.user_id = auth.uid()
            )
          )
        )
    $sql$;
  END IF;
END $$;

-- Project meetings policies
DO $$
BEGIN
  -- Select policy
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_members_select_meetings'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "project_members_select_meetings" ON public.project_meetings
        FOR SELECT USING (
          EXISTS (
            SELECT 1 FROM public.project_members pm
            JOIN public.employees e ON e.id = pm.employee_id
            WHERE pm.project_id = project_meetings.project_id
            AND e.user_id = auth.uid()
          )
          OR 
          EXISTS (
            SELECT 1 FROM public.projects p
            WHERE p.id = project_meetings.project_id
            AND p.owner_id = auth.uid()
          )
        )
    $sql$;
  END IF;

  -- Insert policy: only project manager
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'org_insert_project_meetings'
  ) THEN
    EXECUTE 'DROP POLICY "org_insert_project_meetings" ON public.project_meetings';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_manager_insert_meetings'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "project_manager_insert_meetings" ON public.project_meetings
        FOR INSERT WITH CHECK (
          EXISTS (
            SELECT 1 
            FROM public.project_members pm
            JOIN public.employees e ON e.id = pm.employee_id
            WHERE pm.project_id = project_meetings.project_id
              AND e.user_id = auth.uid()
              AND lower(pm.role) = 'manager'
          )
        )
    $sql$;
  END IF;
END $$;

-- Project tasks policies
DO $$
BEGIN
  -- Select policy
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_tasks' AND policyname = 'project_members_select_tasks'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "project_members_select_tasks" ON public.project_tasks
        FOR SELECT USING (
          EXISTS (
            SELECT 1 FROM public.project_members pm
            JOIN public.employees e ON e.id = pm.employee_id
            WHERE pm.project_id = project_tasks.project_id
            AND e.user_id = auth.uid()
          )
          OR 
          EXISTS (
            SELECT 1 FROM public.projects p
            WHERE p.id = project_tasks.project_id
            AND p.owner_id = auth.uid()
          )
        )
    $sql$;
  END IF;

  -- Insert/Update policy: Project members can create/update tasks
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_tasks' AND policyname = 'project_members_modify_tasks'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "project_members_modify_tasks" ON public.project_tasks
        FOR ALL USING (
          EXISTS (
            SELECT 1 FROM public.project_members pm
            JOIN public.employees e ON e.id = pm.employee_id
            WHERE pm.project_id = project_tasks.project_id
            AND e.user_id = auth.uid()
          )
          OR 
          EXISTS (
            SELECT 1 FROM public.projects p
            WHERE p.id = project_tasks.project_id
            AND p.owner_id = auth.uid()
          )
        )
    $sql$;
  END IF;
END $$;

-- PBAC update: managers can create calendar meetings
UPDATE public.role_capabilities
SET can_create = true
WHERE role = 'manager' AND module = 'calendar';

-- Auto-create chat channel for project
CREATE OR REPLACE FUNCTION public.create_project_chat_channel()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
BEGIN
  -- Check if channel already exists
  IF EXISTS (SELECT 1 FROM public.chat_channels WHERE project_id = NEW.id) THEN
    RETURN NEW;
  END IF;

  -- Assuming chat_type 'project' exists (added at top)
  INSERT INTO public.chat_channels (organization_id, project_id, name, type, created_by)
  VALUES (NEW.organization_id, NEW.id, NEW.name, 'project', NEW.owner_id)
  RETURNING id INTO _channel_id;

  -- Add owner as participant
  INSERT INTO public.chat_participants (channel_id, user_id)
  VALUES (_channel_id, NEW.owner_id)
  ON CONFLICT DO NOTHING;

  -- Add any existing project members (if present) as participants
  INSERT INTO public.chat_participants (channel_id, user_id)
  SELECT _channel_id, e.user_id
  FROM public.project_members pm
  JOIN public.employees e ON e.id = pm.employee_id
  WHERE pm.project_id = NEW.id
  ON CONFLICT DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_create_project_chat ON public.projects;
CREATE TRIGGER trg_create_project_chat
  AFTER INSERT ON public.projects
  FOR EACH ROW EXECUTE FUNCTION public.create_project_chat_channel();

-- Auto-join project chat when added as member
CREATE OR REPLACE FUNCTION public.join_project_chat_channel()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
  _user_id UUID;
BEGIN
  -- Get channel id
  SELECT id INTO _channel_id FROM public.chat_channels WHERE project_id = NEW.project_id LIMIT 1;
  
  -- Get user id from employee
  SELECT user_id INTO _user_id FROM public.employees WHERE id = NEW.employee_id;

  IF _channel_id IS NOT NULL AND _user_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_channel_id, _user_id)
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_join_project_chat ON public.project_members;
CREATE TRIGGER trg_join_project_chat
  AFTER INSERT ON public.project_members
  FOR EACH ROW EXECUTE FUNCTION public.join_project_chat_channel();
