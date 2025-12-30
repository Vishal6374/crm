-- Add project members and link chat channels to projects
CREATE TABLE IF NOT EXISTS public.project_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,
  role TEXT,
  added_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (project_id, employee_id)
);

ALTER TABLE public.chat_channels
  ADD COLUMN IF NOT EXISTS project_id UUID NULL REFERENCES public.projects(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_chat_channels_project ON public.chat_channels(project_id);
CREATE INDEX IF NOT EXISTS idx_project_members_project ON public.project_members(project_id);
CREATE INDEX IF NOT EXISTS idx_project_members_employee ON public.project_members(employee_id);

ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_select_project_members" ON public.project_members
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_members.project_id
        AND p.organization_id = public.current_org_id()
    )
  );

CREATE POLICY "org_insert_project_members" ON public.project_members
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_members.project_id
        AND p.organization_id = public.current_org_id()
    )
  );

CREATE POLICY "org_update_project_members" ON public.project_members
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_members.project_id
        AND p.organization_id = public.current_org_id()
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_members.project_id
        AND p.organization_id = public.current_org_id()
    )
  );

CREATE POLICY "org_delete_project_members" ON public.project_members
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_members.project_id
        AND p.organization_id = public.current_org_id()
    )
  );
