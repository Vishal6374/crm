BEGIN;

DROP POLICY IF EXISTS "employees_write_admin" ON public.employees;

CREATE POLICY employees_select_org ON public.employees
  FOR SELECT TO authenticated USING (
    organization_id = public.current_org_id()
  );

CREATE POLICY employees_insert_roles ON public.employees
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id() AND
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid()
        AND ur.organization_id = public.current_org_id()
        AND ur.role IN ('tenant_admin','admin','manager','hr')
    )
  );

CREATE POLICY employees_update_roles ON public.employees
  FOR UPDATE USING (
    organization_id = public.current_org_id() AND
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid()
        AND ur.organization_id = public.current_org_id()
        AND ur.role IN ('tenant_admin','admin','manager','hr')
    )
  )
  WITH CHECK (
    organization_id = public.current_org_id()
  );

CREATE POLICY employees_delete_roles ON public.employees
  FOR DELETE USING (
    organization_id = public.current_org_id() AND
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid()
        AND ur.organization_id = public.current_org_id()
        AND ur.role IN ('tenant_admin','admin','manager','hr')
    )
  );

COMMIT;

