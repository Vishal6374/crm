-- Fix infinite recursion between projects and project_members

-- 1. Helper to get project owner without triggering RLS on projects
CREATE OR REPLACE FUNCTION public.get_project_owner(p_id UUID)
RETURNS UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT owner_id FROM public.projects WHERE id = p_id
$$;

-- 2. Update project_members policy to use the helper
DROP POLICY IF EXISTS "Managers and Admins can manage project members" ON public.project_members;

CREATE POLICY "Managers and Admins can manage project members" ON public.project_members
  FOR ALL USING (
    -- 1. Project Owner (via Security Definer to avoid recursion)
    (public.get_project_owner(project_members.project_id) = auth.uid()) OR
    
    -- 2. Project Manager (Member with role 'manager')
    EXISTS (
        SELECT 1 FROM public.project_members pm
        JOIN public.employees e ON e.id = pm.employee_id
        WHERE pm.project_id = project_members.project_id 
          AND e.user_id = auth.uid() 
          AND lower(pm.role) = 'manager'
    ) OR
    
    -- 3. Tenant Admin
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

-- 3. Update project_meetings policy to use the helper (Optimization/Safety)
DROP POLICY IF EXISTS "Project managers and admins can manage meetings" ON public.project_meetings;

CREATE POLICY "Project managers and admins can manage meetings" ON public.project_meetings
  FOR ALL USING (
    -- 1. Project Owner
    (public.get_project_owner(project_meetings.project_id) = auth.uid()) OR

    -- 2. Project Manager
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_meetings.project_id
        AND e.user_id = auth.uid()
        AND lower(pm.role) = 'manager'
    ) OR
    
    -- 3. Tenant Admin
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

-- 4. Update project_tasks policies to use the helper (Optimization/Safety)
-- Re-apply policies from 20251231200000 with the fix

DROP POLICY IF EXISTS "Project members can view tasks" ON public.project_tasks;
CREATE POLICY "Project members can view tasks" ON public.project_tasks
  FOR SELECT USING (
    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

DROP POLICY IF EXISTS "Project members can create tasks" ON public.project_tasks;
CREATE POLICY "Project members can create tasks" ON public.project_tasks
  FOR INSERT WITH CHECK (
    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

DROP POLICY IF EXISTS "Project members can update tasks" ON public.project_tasks;
CREATE POLICY "Project members can update tasks" ON public.project_tasks
  FOR UPDATE USING (
    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

DROP POLICY IF EXISTS "Project members can delete tasks" ON public.project_tasks;
CREATE POLICY "Project members can delete tasks" ON public.project_tasks
  FOR DELETE USING (
    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_tasks.project_id 
        AND e.user_id = auth.uid()
        AND lower(pm.role) = 'manager'
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );
