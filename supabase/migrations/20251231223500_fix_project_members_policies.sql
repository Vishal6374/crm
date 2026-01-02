-- Helper functions and safe policies for project_members
CREATE OR REPLACE FUNCTION public.is_project_manager(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id
      AND e.user_id = _user_id
      AND lower(pm.role) = 'manager'
  )
$$;

DROP POLICY IF EXISTS "Managers and Admins can manage project members" ON public.project_members;

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

DROP POLICY IF EXISTS "employee_self_select_project_members" ON public.project_members;

CREATE POLICY "select_project_members_visible" ON public.project_members
  FOR SELECT
  USING (
    public.is_project_member_or_owner(project_members.project_id, auth.uid())
    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
  );

GRANT EXECUTE ON FUNCTION public.is_project_manager(UUID, UUID) TO authenticated;
