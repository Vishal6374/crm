-- Fix RLS for profiles to ensure employees can be seen
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Authenticated users can view all profiles" ON public.profiles;

CREATE POLICY "Authenticated users can view all profiles" 
ON public.profiles FOR SELECT 
TO authenticated 
USING (true);

-- Fix RLS for employees
DROP POLICY IF EXISTS "Authenticated users can view employees" ON public.employees;

CREATE POLICY "Authenticated users can view employees" 
ON public.employees FOR SELECT 
TO authenticated 
USING (true);

-- Fix RLS for activity_logs
DROP POLICY IF EXISTS "Users can view their own logs" ON public.activity_logs;
DROP POLICY IF EXISTS "Authenticated users can view all logs" ON public.activity_logs;

CREATE POLICY "Authenticated users can view all logs" 
ON public.activity_logs FOR SELECT 
TO authenticated 
USING (true);

-- Add assigned_to to leads if not exists
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'assigned_to') THEN
        ALTER TABLE public.leads ADD COLUMN assigned_to uuid REFERENCES auth.users(id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'deals' AND column_name = 'assigned_to') THEN
        ALTER TABLE public.deals ADD COLUMN assigned_to uuid REFERENCES auth.users(id);
    END IF;
END $$;

-- Ensure activity logging triggers exist and work
-- (We assume the function log_activity_fn exists from previous migrations, if not we recreate it)
CREATE OR REPLACE FUNCTION public.log_activity_fn()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.activity_logs (action, entity_type, entity_id, description, user_id)
  VALUES (
    TG_OP,
    TG_TABLE_NAME,
    NEW.id,
    TG_OP || ' on ' || TG_TABLE_NAME,
    auth.uid()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-apply triggers for key tables if they are missing (idempotent drop/create)
DROP TRIGGER IF EXISTS trg_log_leads ON public.leads;
CREATE TRIGGER trg_log_leads AFTER INSERT OR UPDATE OR DELETE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();

DROP TRIGGER IF EXISTS trg_log_deals ON public.deals;
CREATE TRIGGER trg_log_deals AFTER INSERT OR UPDATE OR DELETE ON public.deals FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();

DROP TRIGGER IF EXISTS trg_log_tasks ON public.tasks;
CREATE TRIGGER trg_log_tasks AFTER INSERT OR UPDATE OR DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();

DROP TRIGGER IF EXISTS trg_log_contacts ON public.contacts;
CREATE TRIGGER trg_log_contacts AFTER INSERT OR UPDATE OR DELETE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();

DROP TRIGGER IF EXISTS trg_log_employees ON public.employees;
CREATE TRIGGER trg_log_employees AFTER INSERT OR UPDATE OR DELETE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();
