-- Fix RLS Recursion by using Security Definer functions for both sides of the relationship
-- and ensuring strict search_path.

-- 1. Redefine helper to get project owner safely
CREATE OR REPLACE FUNCTION public.get_project_owner(p_id UUID)
RETURNS UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public, pg_temp
AS $$
  SELECT owner_id FROM public.projects WHERE id = p_id
$$;

-- 2. Redefine is_project_member_or_owner safely (breaking recursion)
CREATE OR REPLACE FUNCTION public.is_project_member_or_owner(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
SET search_path = public, pg_temp
AS $$
BEGIN
  -- Direct check on project_members (bypassing RLS due to SD)
  IF EXISTS (
    SELECT 1 FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id AND e.user_id = _user_id
  ) THEN
    RETURN TRUE;
  END IF;

  -- Direct check on projects (bypassing RLS due to SD)
  IF EXISTS (SELECT 1 FROM public.projects WHERE id = _project_id AND owner_id = _user_id) THEN
    RETURN TRUE;
  END IF;
  
  RETURN FALSE;
END;
$$;

-- 3. Redefine is_project_manager safely
CREATE OR REPLACE FUNCTION public.is_project_manager(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
SET search_path = public, pg_temp
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id
      AND e.user_id = _user_id
      AND lower(pm.role) = 'manager'
  );
END;
$$;

-- 4. Re-apply policies using these safe functions

-- Projects Policy
DROP POLICY IF EXISTS "creator_or_member_select_projects" ON public.projects;
CREATE POLICY "creator_or_member_select_projects" ON public.projects
  FOR SELECT USING (
    organization_id = public.current_org_id()
    AND (
      owner_id = auth.uid()
      OR public.is_project_member_or_owner(id, auth.uid())
      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
    )
  );

-- Project Members Policy
DROP POLICY IF EXISTS "select_project_members_visible" ON public.project_members;
CREATE POLICY "select_project_members_visible" ON public.project_members
  FOR SELECT
  USING (
    public.is_project_member_or_owner(project_members.project_id, auth.uid())
    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
  );

DROP POLICY IF EXISTS "manage_project_members" ON public.project_members;
CREATE POLICY "manage_project_members" ON public.project_members
  FOR ALL
  USING (
    public.get_project_owner(project_members.project_id) = auth.uid()
    OR public.is_project_manager(project_members.project_id, auth.uid())
    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
  )
  WITH CHECK (
    public.get_project_owner(project_members.project_id) = auth.uid()
    OR public.is_project_manager(project_members.project_id, auth.uid())
    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
  );

-- Grant execute to authenticated users
GRANT EXECUTE ON FUNCTION public.get_project_owner(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_project_member_or_owner(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_project_manager(UUID, UUID) TO authenticated;
