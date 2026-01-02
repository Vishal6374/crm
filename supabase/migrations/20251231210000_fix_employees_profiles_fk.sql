-- Add explicit foreign key from employees.user_id to profiles.id to enable embedding in PostgREST
-- PostgREST only detects relationships to exposed tables (public schema).
-- The existing FK to auth.users is not visible for embedding profiles.

DO $$
BEGIN
  -- We attempt to add the constraint. 
  -- If there are employees with user_ids that don't have profiles, this might fail.
  -- Ideally, every user should have a profile.
  
  -- Check if the constraint already exists to avoid error
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'employees_user_id_fkey_profiles' 
    AND table_name = 'employees'
  ) THEN
    ALTER TABLE public.employees
      ADD CONSTRAINT employees_user_id_fkey_profiles
      FOREIGN KEY (user_id)
      REFERENCES public.profiles(id);
  END IF;
END $$;
