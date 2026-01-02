-- Create Invitations System
CREATE TABLE IF NOT EXISTS public.invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'employee', -- 'tenant_admin', 'manager', 'employee'
  token TEXT DEFAULT gen_random_uuid()::text,
  status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'accepted'
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by UUID REFERENCES auth.users(id),
  CONSTRAINT unique_active_invite UNIQUE (email, organization_id)
);

-- RLS for Invitations
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

-- Tenant Admins can view/create invites for their org
CREATE POLICY "Tenant Admins can view invites" ON public.invitations
  FOR SELECT USING (
    organization_id = public.current_org_id() 
    AND EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'tenant_admin')
  );

CREATE POLICY "Tenant Admins can create invites" ON public.invitations
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'tenant_admin')
  );

CREATE POLICY "Tenant Admins can delete invites" ON public.invitations
  FOR DELETE USING (
    organization_id = public.current_org_id()
    AND EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'tenant_admin')
  );

-- Super Admins can view/manage all invites
CREATE POLICY "Super Admins can manage all invites" ON public.invitations
  FOR ALL USING (public.is_super_admin());

-- Update handle_new_user to process invites
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  _org_id UUID;
  _role TEXT;
  _invite_id UUID;
BEGIN
  -- 1. Check for valid invitation by email
  BEGIN
    SELECT organization_id, role, id INTO _org_id, _role, _invite_id
    FROM public.invitations
    WHERE email = NEW.email AND status = 'pending'
    ORDER BY created_at DESC
    LIMIT 1;
  EXCEPTION
    WHEN undefined_table THEN
      -- Invitations table not present yet; treat as no invite
      _org_id := NULL;
      _role := NULL;
      _invite_id := NULL;
    WHEN others THEN
      -- Any other error while checking invite: proceed without invite
      _org_id := NULL;
      _role := NULL;
      _invite_id := NULL;
  END;

  -- 2. If no invite, try to assign to Default Organization (fallback)
  IF _org_id IS NULL THEN
    SELECT id INTO _org_id FROM public.organizations WHERE name = 'Default Organization' LIMIT 1;
    _role := 'employee';
    -- If no Default Org, pick the first one (fallback for local dev)
    IF _org_id IS NULL THEN
       SELECT id INTO _org_id FROM public.organizations ORDER BY created_at LIMIT 1;
    END IF;
  END IF;

  -- 3. Insert Profile with Organization ID
  INSERT INTO public.profiles (id, email, full_name, organization_id)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.email),
    _org_id
  );
  
  -- 4. Insert User Role
  INSERT INTO public.user_roles (user_id, role, organization_id)
  VALUES (NEW.id, COALESCE(_role, 'employee'), _org_id);

  -- 5. Mark invite as accepted if exists
  IF _invite_id IS NOT NULL THEN
    UPDATE public.invitations SET status = 'accepted' WHERE id = _invite_id;
  END IF;
  
  RETURN NEW;
END;
$$;
