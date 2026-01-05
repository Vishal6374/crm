-- Fix signup flow by assigning default organization
-- This fixes the issue where new users cannot be created because of NOT NULL constraint on organization_id

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  _org_id UUID;
BEGIN
  -- Try to find an existing organization (pick the first one created, usually Default Organization)
  SELECT id INTO _org_id FROM public.organizations ORDER BY created_at LIMIT 1;
  
  -- If no organization exists, create one (safety fallback)
  IF _org_id IS NULL THEN
    INSERT INTO public.organizations (name) VALUES ('Default Organization') RETURNING id INTO _org_id;
  END IF;

  -- Create profile with organization_id
  INSERT INTO public.profiles (id, email, full_name, organization_id)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.email),
    _org_id
  );
  
  -- Create user role with organization_id
  INSERT INTO public.user_roles (user_id, role, organization_id)
  VALUES (NEW.id, 'employee', _org_id);
  
  RETURN NEW;
END;
$$;
