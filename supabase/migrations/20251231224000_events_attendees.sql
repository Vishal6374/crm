ALTER TABLE public.events ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id);

CREATE TABLE IF NOT EXISTS public.event_attendees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  organization_id UUID
);

ALTER TABLE public.event_attendees ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.is_event_creator(_event_id UUID, _user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.events e
    WHERE e.id = _event_id AND e.created_by = _user_id
  )
$$;

CREATE POLICY "org_select_event_attendees" ON public.event_attendees
  FOR SELECT USING (organization_id = public.current_org_id());

CREATE POLICY "org_insert_event_attendees" ON public.event_attendees
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND (
      public.is_event_creator(event_id, auth.uid())
      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
    )
  );

CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_event_attendees()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_set_org_on_insert_event_attendees ON public.event_attendees;
CREATE TRIGGER trg_set_org_on_insert_event_attendees
  BEFORE INSERT ON public.event_attendees
  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_event_attendees();

GRANT EXECUTE ON FUNCTION public.is_event_creator(UUID, UUID) TO authenticated;
