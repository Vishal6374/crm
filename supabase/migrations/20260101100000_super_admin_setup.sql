-- Add status to organizations
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS status TEXT CHECK (status IN ('active', 'suspended')) DEFAULT 'active';

-- Enable RLS on organizations
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

-- Helper for super admin check
CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT COALESCE(super_admin, false) FROM public.profiles WHERE id = auth.uid();
$$;

-- Policies for organizations
DROP POLICY IF EXISTS "Super admin full access on organizations" ON public.organizations;
CREATE POLICY "Super admin full access on organizations"
ON public.organizations
FOR ALL
USING (public.is_super_admin());

DROP POLICY IF EXISTS "Users can view their own organization" ON public.organizations;
CREATE POLICY "Users can view their own organization"
ON public.organizations
FOR SELECT
USING (id = public.current_org_id());

-- Tenant Modules policies
ALTER TABLE public.tenant_modules ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Super admin full access on tenant_modules" ON public.tenant_modules;
CREATE POLICY "Super admin full access on tenant_modules"
ON public.tenant_modules
FOR ALL
USING (public.is_super_admin());

DROP POLICY IF EXISTS "Tenant admin can view tenant_modules" ON public.tenant_modules;
CREATE POLICY "Tenant admin can view tenant_modules"
ON public.tenant_modules
FOR SELECT
USING (organization_id = public.current_org_id());

-- Ensure Super Admin can view all profiles (to assign admins)
DROP POLICY IF EXISTS "Super admin view all profiles" ON public.profiles;
CREATE POLICY "Super admin view all profiles"
ON public.profiles
FOR SELECT
USING (public.is_super_admin());

-- Ensure Super Admin can view/edit user_roles
DROP POLICY IF EXISTS "Super admin manage user_roles" ON public.user_roles;
CREATE POLICY "Super admin manage user_roles"
ON public.user_roles
FOR ALL
USING (public.is_super_admin());
