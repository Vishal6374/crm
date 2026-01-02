-- Fix RLS Recursion by using Security Definer functions for both sides of the relationship

-- 1. Function to check if user is a project member (Security Definer)
-- Used by: projects table policy
CREATE OR REPLACE FUNCTION public.is_project_member_or_owner(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Check if owner
  IF EXISTS (SELECT 1 FROM public.projects WHERE id = _project_id AND owner_id = _user_id) THEN
    RETURN TRUE;
  END IF;

  -- Check if member
  IF EXISTS (
    SELECT 1 FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id AND e.user_id = _user_id
  ) THEN
    RETURN TRUE;
  END IF;
  
  RETURN FALSE;
END;
$$;

-- 2. Update Projects Policy to use the SD function
-- This prevents projects -> project_members -> projects loop
DROP POLICY IF EXISTS "creator_or_member_select_projects" ON public.projects;

CREATE POLICY "creator_or_member_select_projects" ON public.projects
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND (
      owner_id = auth.uid()
      OR public.is_project_member_or_owner(id, auth.uid())
    )
  );

-- 3. Cleanup conflicting policies on project_members from 20251230014000
-- These were likely causing issues because they query 'projects' table directly
DROP POLICY IF EXISTS "org_select_project_members" ON public.project_members;
DROP POLICY IF EXISTS "org_insert_project_members" ON public.project_members;
DROP POLICY IF EXISTS "org_update_project_members" ON public.project_members;
DROP POLICY IF EXISTS "org_delete_project_members" ON public.project_members;

-- 4. Ensure project_members policies are safe
-- We already have "Managers and Admins can manage project members" (FOR ALL)
-- and "employee_self_select_project_members" (FOR SELECT)

-- Re-verify "Managers and Admins can manage project members" uses get_project_owner (SD)
-- (It was updated in 20251231220000, but let's be sure we don't have others)

-- 5. Additional Cleanup for other potentially recursive tables

-- Project Meetings
-- Uses get_project_owner (SD) in "Project managers and admins can manage meetings" (FOR ALL)
-- "project_members_select_meetings" (FOR SELECT) queries project_members and projects.
-- Let's update "project_members_select_meetings" to use SD function too.

DROP POLICY IF EXISTS "project_members_select_meetings" ON public.project_meetings;
CREATE POLICY "project_members_select_meetings" ON public.project_meetings
  FOR SELECT USING (
    public.is_project_member_or_owner(project_id, auth.uid())
    OR 
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

-- Project Tasks
-- "project_members_select_tasks" queries project_members/projects. Update to use SD.
DROP POLICY IF EXISTS "project_members_select_tasks" ON public.project_tasks;
CREATE POLICY "project_members_select_tasks" ON public.project_tasks
  FOR SELECT USING (
    public.is_project_member_or_owner(project_id, auth.uid())
    OR 
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

-- 6. Grant execute permissions (just in case)
GRANT EXECUTE ON FUNCTION public.is_project_member_or_owner(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_project_owner(UUID) TO authenticated;
