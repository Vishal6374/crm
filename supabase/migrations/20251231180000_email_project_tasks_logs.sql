
-- Create email_templates table
CREATE TABLE IF NOT EXISTS public.email_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by UUID REFERENCES public.profiles(id)
);

-- Enable RLS for email_templates
ALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their org's templates" ON public.email_templates;
CREATE POLICY "Users can view their org's templates" ON public.email_templates
  FOR SELECT USING (organization_id = (SELECT organization_id FROM public.profiles WHERE id = auth.uid()));

DROP POLICY IF EXISTS "Admins and Managers can manage templates" ON public.email_templates;
CREATE POLICY "Admins and Managers can manage templates" ON public.email_templates
  FOR ALL USING (
    organization_id = (SELECT organization_id FROM public.profiles WHERE id = auth.uid()) AND
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role IN ('tenant_admin', 'manager', 'hr')
    )
  );

-- Ensure project_tasks table exists and is isolated
CREATE TABLE IF NOT EXISTS public.project_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'todo',
  priority TEXT DEFAULT 'medium',
  assigned_to UUID REFERENCES public.profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  due_date TIMESTAMPTZ
);

-- RLS for project_tasks
ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Project members can view tasks" ON public.project_tasks;
CREATE POLICY "Project members can view tasks" ON public.project_tasks
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.project_members pm
      WHERE pm.project_id = project_tasks.project_id AND pm.employee_id IN (
        SELECT id FROM public.employees WHERE user_id = auth.uid()
      )
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

DROP POLICY IF EXISTS "Project members can create/update tasks" ON public.project_tasks;
CREATE POLICY "Project members can create/update tasks" ON public.project_tasks
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.project_members pm
      WHERE pm.project_id = project_tasks.project_id AND pm.employee_id IN (
        SELECT id FROM public.employees WHERE user_id = auth.uid()
      )
    ) OR
    EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM public.user_roles ur
      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'
    )
  );

-- Ensure activity_logs has organization_id
ALTER TABLE public.activity_logs ADD COLUMN IF NOT EXISTS organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE;

-- Backfill organization_id for activity_logs if possible (using user_id)
UPDATE public.activity_logs al
SET organization_id = p.organization_id
FROM public.profiles p
WHERE al.user_id = p.id AND al.organization_id IS NULL;

-- Trigger for activity log cleanup (Keep latest 500 per organization)
CREATE OR REPLACE FUNCTION public.cleanup_activity_logs()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NOT NULL THEN
    DELETE FROM public.activity_logs
    WHERE id IN (
      SELECT id FROM public.activity_logs
      WHERE organization_id = NEW.organization_id
      ORDER BY created_at DESC
      OFFSET 500
    );
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_cleanup_activity_logs ON public.activity_logs;
CREATE TRIGGER trigger_cleanup_activity_logs
AFTER INSERT ON public.activity_logs
FOR EACH ROW
EXECUTE FUNCTION public.cleanup_activity_logs();
