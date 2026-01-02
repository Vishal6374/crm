-- Consolidate project chat triggers and functions to avoid conflicts

-- Drop existing potential triggers
DROP TRIGGER IF EXISTS trg_add_member_to_chat ON public.project_members;
DROP TRIGGER IF EXISTS trg_add_member_to_project_chat ON public.project_members;
DROP TRIGGER IF EXISTS trg_join_project_chat ON public.project_members;
DROP TRIGGER IF EXISTS trg_create_project_chat ON public.projects;

-- Drop existing potential functions
DROP FUNCTION IF EXISTS public.sync_project_member_to_chat();
DROP FUNCTION IF EXISTS public.add_member_to_project_chat();
DROP FUNCTION IF EXISTS public.join_project_chat_channel();
DROP FUNCTION IF EXISTS public.create_project_chat();
DROP FUNCTION IF EXISTS public.create_project_chat_channel();

-- Re-create robust functions

-- 1. Auto-create project chat channel
CREATE OR REPLACE FUNCTION public.handle_new_project_chat()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
  _owner_id UUID;
BEGIN
  _owner_id := COALESCE(NEW.owner_id, auth.uid());
  
  -- Check if channel already exists (should not happen on insert, but safe check)
  SELECT id INTO _channel_id FROM public.chat_channels WHERE project_id = NEW.id LIMIT 1;
  
  IF _channel_id IS NULL THEN
    INSERT INTO public.chat_channels (organization_id, project_id, name, type, created_by)
    VALUES (NEW.organization_id, NEW.id, COALESCE('Project: ' || NEW.name, 'Project Chat'), 'group', _owner_id)
    RETURNING id INTO _channel_id;
  END IF;

  -- Add owner as participant
  IF _owner_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)
    VALUES (_channel_id, _owner_id, NEW.organization_id)
    ON CONFLICT (channel_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_handle_new_project_chat
  AFTER INSERT ON public.projects
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_project_chat();

-- 2. Auto-join project members to chat
CREATE OR REPLACE FUNCTION public.handle_new_project_member()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
  _user_id UUID;
  _org_id UUID;
BEGIN
  -- Get project channel and org_id
  SELECT id, organization_id INTO _channel_id, _org_id
  FROM public.chat_channels
  WHERE project_id = NEW.project_id
  LIMIT 1;

  -- If no channel linked to project, try to find one or bail out (usually created by project trigger)
  IF _channel_id IS NULL THEN
    -- Fallback: Check if we can create one? No, better to wait or log.
    -- But for now, let's just return.
    RETURN NEW;
  END IF;

  -- Get user_id from employee
  SELECT user_id INTO _user_id
  FROM public.employees
  WHERE id = NEW.employee_id;

  IF _user_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)
    VALUES (_channel_id, _user_id, _org_id)
    ON CONFLICT (channel_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_handle_new_project_member
  AFTER INSERT ON public.project_members
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_project_member();

-- Ensure RLS policies for project_tasks are correct (Double check)
-- Users should see tasks if they are:
-- 1. Tenant Admin
-- 2. Project Owner
-- 3. Project Member (Manager or Employee role in project)

DROP POLICY IF EXISTS "Project members can view tasks" ON public.project_tasks;
DROP POLICY IF EXISTS "Project members can create tasks" ON public.project_tasks;
DROP POLICY IF EXISTS "Project members can update tasks" ON public.project_tasks;
DROP POLICY IF EXISTS "Project members can delete tasks" ON public.project_tasks;

CREATE POLICY "Project members can view tasks" ON public.project_tasks
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

CREATE POLICY "Project members can create tasks" ON public.project_tasks
  FOR INSERT WITH CHECK (
    -- Similar logic, usually members can create tasks
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

CREATE POLICY "Project members can update tasks" ON public.project_tasks
  FOR UPDATE USING (
    -- Members can update tasks (e.g. status)
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

CREATE POLICY "Project members can delete tasks" ON public.project_tasks
  FOR DELETE USING (
    -- Maybe only managers/admins/owners?
    -- For now, let's allow members to delete tasks they created? 
    -- But we don't track creator in project_tasks explicitly (created_by?).
    -- Let's restrict delete to project managers (role='manager' in project_members) or owner/admin.
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id 
        AND e.user_id = auth.uid()
        AND lower(pm.role) = 'manager'
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );
