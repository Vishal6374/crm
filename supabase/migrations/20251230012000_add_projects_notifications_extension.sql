-- Create projects table and extend notifications/tasks with project and meeting links
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'org_role') THEN
    PERFORM 1;
  END IF;
END
$$;

CREATE TABLE IF NOT EXISTS public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  owner_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_projects_name ON public.projects(name);

ALTER TABLE public.tasks
  ADD COLUMN IF NOT EXISTS project_id UUID NULL;

ALTER TABLE public.tasks
  ADD CONSTRAINT tasks_project_id_fkey
  FOREIGN KEY (project_id) REFERENCES public.projects (id) ON UPDATE CASCADE ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_tasks_project_id ON public.tasks(project_id);

DO $$
DECLARE
  _default_org UUID;
BEGIN
  SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'notifications' AND column_name = 'organization_id') THEN
    ALTER TABLE public.notifications ADD COLUMN organization_id UUID;
    UPDATE public.notifications SET organization_id = COALESCE(organization_id, _default_org);
    ALTER TABLE public.notifications ALTER COLUMN organization_id SET NOT NULL;
    ALTER TABLE public.notifications ADD CONSTRAINT notifications_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
  END IF;
END $$;

ALTER TABLE public.notifications
  ADD COLUMN IF NOT EXISTS project_id UUID NULL,
  ADD COLUMN IF NOT EXISTS meeting_id UUID NULL;

ALTER TABLE public.notifications
  ADD CONSTRAINT notifications_project_id_fkey
  FOREIGN KEY (project_id) REFERENCES public.projects (id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE public.notifications
  ADD CONSTRAINT notifications_meeting_id_fkey
  FOREIGN KEY (meeting_id) REFERENCES public.events (id) ON UPDATE CASCADE ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_notifications_project ON public.notifications(project_id);

ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_select_projects" ON public.projects
  FOR SELECT USING (organization_id = public.current_org_id());
CREATE POLICY "org_insert_projects" ON public.projects
  FOR INSERT WITH CHECK (organization_id = public.current_org_id());
CREATE POLICY "org_update_projects" ON public.projects
  FOR UPDATE USING (organization_id = public.current_org_id()) WITH CHECK (organization_id = public.current_org_id());
CREATE POLICY "org_delete_projects" ON public.projects
  FOR DELETE USING (organization_id = public.current_org_id());

CREATE POLICY "own_select_notifications" ON public.notifications
  FOR SELECT USING (user_id = auth.uid() AND organization_id = public.current_org_id());
CREATE POLICY "own_insert_notifications" ON public.notifications
  FOR INSERT WITH CHECK (user_id = auth.uid() AND organization_id = public.current_org_id());
CREATE POLICY "own_update_notifications" ON public.notifications
  FOR UPDATE USING (user_id = auth.uid() AND organization_id = public.current_org_id()) WITH CHECK (user_id = auth.uid() AND organization_id = public.current_org_id());
CREATE POLICY "own_delete_notifications" ON public.notifications
  FOR DELETE USING (user_id = auth.uid() AND organization_id = public.current_org_id());

CREATE OR REPLACE FUNCTION public.set_org_id_on_insert()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_set_org_on_insert_projects ON public.projects;
CREATE TRIGGER trg_set_org_on_insert_projects
  BEFORE INSERT ON public.projects
  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();

DROP TRIGGER IF EXISTS trg_set_org_on_insert_notifications ON public.notifications;
CREATE TRIGGER trg_set_org_on_insert_notifications
  BEFORE INSERT ON public.notifications
  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();

