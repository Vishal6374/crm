DO $$
DECLARE
  v TEXT;
BEGIN
  FOR v IN SELECT unnest(ARRAY['tenant_admin','hr','finance','viewer','super_admin'])
  LOOP
    IF NOT EXISTS (
      SELECT 1 FROM pg_enum e
      JOIN pg_type t ON t.oid = e.enumtypid
      WHERE t.typname = 'app_role' AND e.enumlabel = v
    ) THEN
      EXECUTE format('ALTER TYPE public.app_role ADD VALUE %L', v);
    END IF;
  END LOOP;
END $$;

ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS super_admin BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS public.tenant_modules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  module TEXT NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (organization_id, module)
);

DO $$
DECLARE
  _org UUID;
  m TEXT;
BEGIN
  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;
  FOR m IN SELECT unnest(ARRAY[
    'dashboard','chat','leads','contacts','companies','deals','projects','tasks','calendar',
    'employees','attendance','payroll','leave_requests','reports','departments','designations',
    'user_roles','activity_logs','settings'
  ])
  LOOP
    INSERT INTO public.tenant_modules(organization_id, module, enabled)
    VALUES (_org, m, true)
    ON CONFLICT (organization_id, module) DO NOTHING;
  END LOOP;
END $$;

CREATE OR REPLACE FUNCTION public.enforce_single_tenant_admin()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.role = 'tenant_admin' THEN
    IF EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE organization_id = NEW.organization_id
        AND role = 'tenant_admin'
        AND (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND id <> NEW.id))
    ) THEN
      RAISE EXCEPTION 'Only one tenant_admin allowed per organization';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_enforce_single_tenant_admin ON public.user_roles;
CREATE TRIGGER trg_enforce_single_tenant_admin
BEFORE INSERT OR UPDATE ON public.user_roles
FOR EACH ROW EXECUTE FUNCTION public.enforce_single_tenant_admin();

-- seeding moved to separate migration to avoid enum unsafe usage in same transaction

