-- Break recursive RLS between projects and project_members by simplifying project_members SELECT policy
DO $$
BEGIN
  -- Drop existing org-scoped SELECT policy if present
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_members' AND policyname = 'org_select_project_members'
  ) THEN
    EXECUTE 'DROP POLICY "org_select_project_members" ON public.project_members';
  END IF;

  -- Recreate SELECT policy without referencing projects to avoid recursion
  -- Visible to the authenticated employee themselves within their organization
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'project_members' AND policyname = 'employee_self_select_project_members'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "employee_self_select_project_members" ON public.project_members
        FOR SELECT USING (
          EXISTS (
            SELECT 1 
            FROM public.employees e
            WHERE e.id = project_members.employee_id
              AND e.user_id = auth.uid()
              AND e.organization_id = public.current_org_id()
          )
        )
    $sql$;
  END IF;
END $$;

