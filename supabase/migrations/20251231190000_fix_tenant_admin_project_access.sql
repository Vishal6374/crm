-- Ensure tenant_admin can manage project_meetings
ALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Project managers can manage meetings" ON public.project_meetings;
DROP POLICY IF EXISTS "Project managers and admins can manage meetings" ON public.project_meetings;

CREATE POLICY "Project managers and admins can manage meetings" ON public.project_meetings
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.project_members pm
      JOIN public.employees e ON e.id = pm.employee_id
      WHERE pm.project_id = project_meetings.project_id
        AND e.user_id = auth.uid()
        AND lower(pm.role) = 'manager'
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_meetings.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

-- Ensure tenant_admin can manage project_members
-- Existing policies might be "org_insert_project_members" etc.
-- We'll create a comprehensive policy for management

DROP POLICY IF EXISTS "Managers and Admins can manage project members" ON public.project_members;

CREATE POLICY "Managers and Admins can manage project members" ON public.project_members
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_members.project_id
      AND (
        p.owner_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.project_members pm
            JOIN public.employees e ON e.id = pm.employee_id
            WHERE pm.project_id = p.id AND e.user_id = auth.uid() AND lower(pm.role) = 'manager'
        ) OR
        EXISTS (
          SELECT 1 FROM public.user_roles ur
          WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
        )
      )
    )
  );
