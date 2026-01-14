-- RLS policies for meetings (events) and project_meetings
-- Ensures org isolation and proper insert/update/delete checks

DO $$
BEGIN
  -- Ensure helper functions exist
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'current_org_id'
  ) THEN
    CREATE OR REPLACE FUNCTION public.current_org_id()
    RETURNS UUID
    LANGUAGE sql
    STABLE
    SECURITY DEFINER
    SET search_path = public
    AS $f$
      SELECT organization_id FROM public.profiles WHERE id = auth.uid()
    $f$;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'is_admin_or_manager'
  ) THEN
    CREATE OR REPLACE FUNCTION public.is_admin_or_manager(_user_id UUID)
    RETURNS BOOLEAN
    LANGUAGE sql
    STABLE
    SECURITY DEFINER
    SET search_path = public
    AS $f$
      SELECT EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = _user_id AND organization_id = public.current_org_id() AND role IN ('admin','manager')
      )
    $f$;
  END IF;
END $$;

-- Events table (main meetings)
ALTER TABLE IF EXISTS public.events ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'events' AND policyname = 'org_select_events') THEN
    EXECUTE 'DROP POLICY "org_select_events" ON public.events';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'events' AND policyname = 'org_insert_events') THEN
    EXECUTE 'DROP POLICY "org_insert_events" ON public.events';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'events' AND policyname = 'events_write_admin') THEN
    EXECUTE 'DROP POLICY "events_write_admin" ON public.events';
  END IF;

  EXECUTE $sql$
    CREATE POLICY "org_select_events" ON public.events
      FOR SELECT TO authenticated USING (
        organization_id = public.current_org_id()
      );
  $sql$;

  EXECUTE $sql$
    CREATE POLICY "org_insert_events" ON public.events
      FOR INSERT WITH CHECK (
        organization_id = public.current_org_id()
        AND type = 'meeting'
      );
  $sql$;

  EXECUTE $sql$
    CREATE POLICY "events_write_admin" ON public.events
      FOR ALL USING (
        organization_id = public.current_org_id()
        AND public.is_admin_or_manager(auth.uid())
      );
  $sql$;
END $$;

-- Project meetings (project_meetings)
ALTER TABLE IF EXISTS public.project_meetings ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'get_project_org_id') THEN
    CREATE OR REPLACE FUNCTION public.get_project_org_id(_project_id UUID)
    RETURNS UUID
    LANGUAGE sql
    STABLE
    SECURITY DEFINER
    SET search_path = public
    AS $f$
      SELECT organization_id FROM public.projects WHERE id = _project_id
    $f$;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_meetings_select_org') THEN
    EXECUTE 'DROP POLICY "project_meetings_select_org" ON public.project_meetings';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_meetings_insert_org') THEN
    EXECUTE 'DROP POLICY "project_meetings_insert_org" ON public.project_meetings';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_meetings_write_admin') THEN
    EXECUTE 'DROP POLICY "project_meetings_write_admin" ON public.project_meetings';
  END IF;

  EXECUTE $sql$
    CREATE POLICY "project_meetings_select_org" ON public.project_meetings
      FOR SELECT TO authenticated USING (
        public.get_project_org_id(project_id) = public.current_org_id()
      );
  $sql$;

  EXECUTE $sql$
    CREATE POLICY "project_meetings_insert_org" ON public.project_meetings
      FOR INSERT WITH CHECK (
        public.get_project_org_id(project_id) = public.current_org_id()
        AND public.is_admin_or_manager(auth.uid())
      );
  $sql$;

  EXECUTE $sql$
    CREATE POLICY "project_meetings_write_admin" ON public.project_meetings
      FOR ALL USING (
        public.get_project_org_id(project_id) = public.current_org_id()
        AND public.is_admin_or_manager(auth.uid())
      );
  $sql$;
END $$;
