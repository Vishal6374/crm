-- Adjust projects INSERT policy to include tenant_admin role
-- Idempotent: drops old policy if exists and creates updated role-scoped policy
DO $$
BEGIN
  -- Drop older admin_or_manager-only policy if present
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'admin_or_manager_insert_projects'
  ) THEN
    EXECUTE 'DROP POLICY "admin_or_manager_insert_projects" ON public.projects';
  END IF;

  -- Create role-scoped insert policy including tenant_admin, admin, manager
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'role_scoped_insert_projects'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "role_scoped_insert_projects" ON public.projects
        FOR INSERT WITH CHECK (
          organization_id = public.current_org_id()
          AND EXISTS (
            SELECT 1 FROM public.user_roles ur
            WHERE ur.user_id = auth.uid()
              AND ur.organization_id = public.current_org_id()
              AND ur.role IN ('tenant_admin','admin','manager')
          )
        );
    $sql$;
  END IF;
END $$;

