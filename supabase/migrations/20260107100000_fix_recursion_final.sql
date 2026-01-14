-- Fix infinite recursion in projects/project_members/employees RLS
-- The recursion happens because:
-- 1. projects SELECT policy queries project_members
-- 2. project_members policies (SELECT/INSERT) query projects
-- 3. This creates a loop
-- Solution: Use SECURITY DEFINER functions to break the chain.

-- 1. Helper to check project organization without triggering projects RLS
CREATE OR REPLACE FUNCTION public.get_project_org_id(_project_id UUID)
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT organization_id FROM public.projects WHERE id = _project_id
$$;

-- 2. Helper to check project ownership safely
CREATE OR REPLACE FUNCTION public.is_project_owner(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.projects 
    WHERE id = _project_id AND owner_id = _user_id
  )
$$;

-- 3. Helper to check project membership safely (bypassing RLS on project_members)
CREATE OR REPLACE FUNCTION public.is_project_member_safe(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id AND e.user_id = _user_id
  )
$$;

-- 4. Ensure employees policy is non-recursive (just in case)
DROP POLICY IF EXISTS "Authenticated users can view employees" ON public.employees;
CREATE POLICY "Authenticated users can view employees" 
ON public.employees FOR SELECT 
TO authenticated 
USING (true);

-- 5. Fix project_members policies
DROP POLICY IF EXISTS "org_select_project_members" ON public.project_members;
DROP POLICY IF EXISTS "org_insert_project_members" ON public.project_members;
DROP POLICY IF EXISTS "org_update_project_members" ON public.project_members;
DROP POLICY IF EXISTS "org_delete_project_members" ON public.project_members;
DROP POLICY IF EXISTS "employee_self_select_project_members" ON public.project_members;

-- SELECT: Visible if user is the employee OR member of project OR owner OR admin/manager
CREATE POLICY "safe_select_project_members" ON public.project_members
FOR SELECT USING (
  -- I am the employee
  EXISTS (
    SELECT 1 FROM public.employees e 
    WHERE e.id = project_members.employee_id AND e.user_id = auth.uid()
  )
  OR
  -- I am a member of the project (check other members)
  public.is_project_member_safe(project_members.project_id, auth.uid())
  OR
  -- I am the owner
  public.is_project_owner(project_members.project_id, auth.uid())
  OR
  -- Admin/Manager
  public.is_admin_or_manager(auth.uid())
);

-- INSERT/UPDATE/DELETE: Check org match using safe function
CREATE POLICY "safe_insert_project_members" ON public.project_members
FOR INSERT WITH CHECK (
  public.get_project_org_id(project_members.project_id) = public.current_org_id()
);

CREATE POLICY "safe_update_project_members" ON public.project_members
FOR UPDATE USING (
  public.get_project_org_id(project_members.project_id) = public.current_org_id()
) WITH CHECK (
  public.get_project_org_id(project_members.project_id) = public.current_org_id()
);

CREATE POLICY "safe_delete_project_members" ON public.project_members
FOR DELETE USING (
  public.get_project_org_id(project_members.project_id) = public.current_org_id()
);
