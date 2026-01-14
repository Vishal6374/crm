-- Seed email module capabilities for all organizations and enable module
BEGIN;

-- Enable 'email' module for all organizations (handle both 'module_name' and legacy 'module' column)
DO $$
BEGIN
  BEGIN
    INSERT INTO public.tenant_modules (organization_id, module_name, enabled)
    SELECT o.id, 'email', true
    FROM public.organizations o
    ON CONFLICT DO NOTHING;
  EXCEPTION WHEN undefined_column THEN
    INSERT INTO public.tenant_modules (organization_id, module, enabled)
    SELECT o.id, 'email', true
    FROM public.organizations o
    ON CONFLICT DO NOTHING;
  END;
END $$;

-- Grant capabilities for 'email' to tenant_admin and admin across all orgs
INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
SELECT o.id, 'tenant_admin', 'email', true, true, true, true
FROM public.organizations o
ON CONFLICT (organization_id, role, module)
DO UPDATE SET can_view = true, can_create = true;

INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
SELECT o.id, 'admin', 'email', true, true, true, true
FROM public.organizations o
ON CONFLICT (organization_id, role, module)
DO UPDATE SET can_view = true, can_create = true;

COMMIT;
