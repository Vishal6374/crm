-- Add status to organizations
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS status TEXT CHECK (status IN ('active', 'suspended')) DEFAULT 'active';

-- Enable RLS on tenant_modules if not already
ALTER TABLE public.tenant_modules ENABLE ROW LEVEL SECURITY;

-- Super Admin Policies for tenant_modules
DROP POLICY IF EXISTS "Super admin full access on tenant_modules" ON public.tenant_modules;
CREATE POLICY "Super admin full access on tenant_modules"
ON public.tenant_modules
FOR ALL
USING (public.is_super_admin());

DROP POLICY IF EXISTS "Users can view their own organization modules" ON public.tenant_modules;
CREATE POLICY "Users can view their own organization modules"
ON public.tenant_modules
FOR SELECT
USING (organization_id = public.current_org_id());

-- Super Admin Policies for profiles (to manage Tenant Admins)
-- Note: Profiles usually has broad SELECT, but we need to ensure INSERT/UPDATE for Super Admin
DROP POLICY IF EXISTS "Super admin full access on profiles" ON public.profiles;
CREATE POLICY "Super admin full access on profiles"
ON public.profiles
FOR ALL
USING (public.is_super_admin());

-- Ensure Organizations RLS allows Super Admin to update status
DROP POLICY IF EXISTS "Super admin full access on organizations" ON public.organizations;
CREATE POLICY "Super admin full access on organizations"
ON public.organizations
FOR ALL
USING (public.is_super_admin());

-- Super Admin Policies for activity_logs
DROP POLICY IF EXISTS "Super admin view all activity_logs" ON public.activity_logs;
CREATE POLICY "Super admin view all activity_logs"
ON public.activity_logs
FOR SELECT
USING (public.is_super_admin());
