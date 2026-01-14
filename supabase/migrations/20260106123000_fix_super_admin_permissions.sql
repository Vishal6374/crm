-- Update can_capability to allow super_admin full access
CREATE OR REPLACE FUNCTION public.can_capability(_user_id UUID, _module TEXT, _cap TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _is_super_admin BOOLEAN;
  _org UUID;
  _role public.app_role;
  _cap_row RECORD;
BEGIN
  -- Check super_admin flag on profile
  SELECT super_admin, organization_id INTO _is_super_admin, _org 
  FROM public.profiles 
  WHERE id = _user_id;

  -- Super admin has full access to everything
  IF _is_super_admin IS TRUE THEN
    RETURN true;
  END IF;

  IF _org IS NULL THEN
    RETURN false;
  END IF;

  SELECT role INTO _role FROM public.user_roles WHERE user_id = _user_id AND organization_id = _org LIMIT 1;
  IF _role IS NULL THEN
    RETURN false;
  END IF;

  SELECT * INTO _cap_row FROM public.role_capabilities 
    WHERE organization_id = _org AND role = _role AND module = _module LIMIT 1;

  IF NOT FOUND THEN
    RETURN false;
  END IF;

  IF _cap = 'can_view' THEN
    RETURN COALESCE(_cap_row.can_view, false);
  ELSIF _cap = 'can_create' THEN
    RETURN COALESCE(_cap_row.can_create, false);
  ELSIF _cap = 'can_edit' THEN
    RETURN COALESCE(_cap_row.can_edit, false);
  ELSIF _cap = 'can_approve' THEN
    RETURN COALESCE(_cap_row.can_approve, false);
  ELSE
    RETURN false;
  END IF;
END;
$$;
