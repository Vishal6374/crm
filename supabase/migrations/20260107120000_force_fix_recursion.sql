-- Forcefully fix infinite recursion by dropping ALL policies on affected tables and recreating them with safe, non-recursive logic.

-- 1. Helper function to drop all policies on a table
CREATE OR REPLACE FUNCTION public.drop_all_policies_on_table(_table_name TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  _pol RECORD;
BEGIN
  FOR _pol IN 
    SELECT policyname 
    FROM pg_policies 
    WHERE tablename = _table_name AND schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "%s" ON public.%I', _pol.policyname, _table_name);
  END LOOP;
END;
$$;

-- 2. Drop policies on key tables
SELECT public.drop_all_policies_on_table('employees');
SELECT public.drop_all_policies_on_table('projects');
SELECT public.drop_all_policies_on_table('project_members');
SELECT public.drop_all_policies_on_table('profiles');

-- 3. Ensure SAFE helper functions exist (SECURITY DEFINER to bypass RLS)
CREATE OR REPLACE FUNCTION public.current_org_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT organization_id FROM public.profiles WHERE id = auth.uid()
$$;

CREATE OR REPLACE FUNCTION public.is_admin_or_manager(_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role IN ('admin', 'manager')
  )
$$;

CREATE OR REPLACE FUNCTION public.get_project_org_id(_project_id UUID)
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT organization_id FROM public.projects WHERE id = _project_id
$$;

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

-- 4. Recreate Policies (SAFE VERSIONS)

-- PROFILES: Safe, non-recursive
CREATE POLICY "profiles_read_all" ON public.profiles
FOR SELECT TO authenticated USING (true);

CREATE POLICY "profiles_update_own" ON public.profiles
FOR UPDATE USING (auth.uid() = id);

-- EMPLOYEES: Safe, non-recursive (checks org via profiles -> safe)
CREATE POLICY "employees_read_org" ON public.employees
FOR SELECT TO authenticated USING (
  organization_id = public.current_org_id()
);

CREATE POLICY "employees_write_admin" ON public.employees
FOR ALL USING (
  public.is_admin_or_manager(auth.uid())
);

-- PROJECTS: Safe (checks org via profiles -> safe)
CREATE POLICY "projects_read_org" ON public.projects
FOR SELECT TO authenticated USING (
  organization_id = public.current_org_id()
);

CREATE POLICY "projects_insert_org" ON public.projects
FOR INSERT WITH CHECK (
  organization_id = public.current_org_id()
);

CREATE POLICY "projects_write_owner_admin" ON public.projects
FOR UPDATE USING (
  owner_id = auth.uid() OR public.is_admin_or_manager(auth.uid())
);

CREATE POLICY "projects_delete_owner_admin" ON public.projects
FOR DELETE USING (
  owner_id = auth.uid() OR public.is_admin_or_manager(auth.uid())
);

-- PROJECT_MEMBERS: Safe (uses SECURITY DEFINER functions)
CREATE POLICY "project_members_read_safe" ON public.project_members
FOR SELECT TO authenticated USING (
  -- I am the employee (via safe check? No, just check user_id on linked employee)
  EXISTS (
    SELECT 1 FROM public.employees e 
    WHERE e.id = project_members.employee_id AND e.user_id = auth.uid()
  )
  OR
  -- I am in the project (safe function)
  public.is_project_member_safe(project_members.project_id, auth.uid())
  OR
  -- I am owner (safe function)
  public.is_project_owner(project_members.project_id, auth.uid())
  OR
  -- Admin/Manager (safe function)
  public.is_admin_or_manager(auth.uid())
);

CREATE POLICY "project_members_insert_safe" ON public.project_members
FOR INSERT WITH CHECK (
  public.get_project_org_id(project_members.project_id) = public.current_org_id()
);

CREATE POLICY "project_members_write_admin" ON public.project_members
FOR ALL USING (
  public.is_admin_or_manager(auth.uid())
);

-- 5. Cleanup
DROP FUNCTION public.drop_all_policies_on_table(_table_name TEXT);
