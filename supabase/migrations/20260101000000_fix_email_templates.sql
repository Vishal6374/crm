-- Fix email_templates organization_id handling
CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_email_templates()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_set_org_on_insert_email_templates ON public.email_templates;
CREATE TRIGGER trg_set_org_on_insert_email_templates
  BEFORE INSERT ON public.email_templates
  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_email_templates();

-- Ensure proper policies for insert/update/delete
DROP POLICY IF EXISTS "Admins and Managers can manage templates" ON public.email_templates;

-- Allow all authenticated users in the org to view templates (already exists as "Users can view their org's templates")
-- But we need to ensure they can also create if they have permission, or at least admins/managers
CREATE POLICY "Admins and Managers can manage templates" ON public.email_templates
  FOR ALL USING (
    organization_id = public.current_org_id() AND
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role IN ('tenant_admin', 'manager', 'hr')
    )
  );

-- Just in case, ensure RLS is on
ALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY;
