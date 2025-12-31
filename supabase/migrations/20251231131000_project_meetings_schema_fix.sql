-- Fix project_meetings schema to match frontend and spec
-- 1) Add start_time and end_time (mandatory), drop scheduled_at
-- 2) Enforce meeting_link NOT NULL
-- 3) Tighten projects INSERT policy to admin or manager only
-- Idempotent: safe to re-run

DO $$
BEGIN
  -- Add columns if missing
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'start_time'
  ) THEN
    ALTER TABLE public.project_meetings ADD COLUMN start_time TIMESTAMPTZ;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'end_time'
  ) THEN
    ALTER TABLE public.project_meetings ADD COLUMN end_time TIMESTAMPTZ;
  END IF;
  
  -- Backfill from scheduled_at if present
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'scheduled_at'
  ) THEN
    UPDATE public.project_meetings
    SET start_time = COALESCE(start_time, scheduled_at),
        end_time = COALESCE(end_time, scheduled_at + INTERVAL '1 hour')
    WHERE start_time IS NULL OR end_time IS NULL;
  END IF;
  
  -- Set NOT NULL constraints
  ALTER TABLE public.project_meetings
    ALTER COLUMN start_time SET NOT NULL,
    ALTER COLUMN end_time SET NOT NULL;
  
  -- Ensure meeting_link exists and is NOT NULL
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'meeting_link'
  ) THEN
    ALTER TABLE public.project_meetings ADD COLUMN meeting_link TEXT;
  END IF;
  -- Backfill meeting_link with empty string if NULL to allow setting NOT NULL
  UPDATE public.project_meetings SET meeting_link = COALESCE(meeting_link, '') WHERE meeting_link IS NULL;
  ALTER TABLE public.project_meetings ALTER COLUMN meeting_link SET NOT NULL;
  
  -- Drop scheduled_at if it exists (now replaced by start_time/end_time)
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'scheduled_at'
  ) THEN
    ALTER TABLE public.project_meetings DROP COLUMN scheduled_at;
  END IF;
END $$;

-- Tighten projects INSERT policy: only admin or manager may create
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'org_insert_projects'
  ) THEN
    EXECUTE 'DROP POLICY "org_insert_projects" ON public.projects';
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'admin_or_manager_insert_projects'
  ) THEN
    EXECUTE $sql$
      CREATE POLICY "admin_or_manager_insert_projects" ON public.projects
        FOR INSERT WITH CHECK (
          organization_id = public.current_org_id()
          AND EXISTS (
            SELECT 1 FROM public.user_roles ur
            WHERE ur.user_id = auth.uid()
              AND ur.organization_id = public.current_org_id()
              AND ur.role IN ('admin','manager')
          )
        )
    $sql$;
  END IF;
END $$;

