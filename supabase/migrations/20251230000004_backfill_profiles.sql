-- Backfill missing profiles for existing users
-- This ensures that users who signed up before the trigger was active (or if it failed) have a profile
INSERT INTO public.profiles (id, email, full_name)
SELECT 
  id, 
  email, 
  COALESCE(raw_user_meta_data->>'full_name', email)
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.profiles);

-- Also ensure user_roles exist
INSERT INTO public.user_roles (user_id, role)
SELECT 
  id, 
  'employee'
FROM auth.users
WHERE id NOT IN (SELECT user_id FROM public.user_roles);
