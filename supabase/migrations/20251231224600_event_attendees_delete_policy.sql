-- Allow deleting event attendees for event creators and tenant admins
DROP POLICY IF EXISTS "org_delete_event_attendees" ON public.event_attendees;

CREATE POLICY "org_delete_event_attendees" ON public.event_attendees
  FOR DELETE USING (
    organization_id = public.current_org_id()
    AND (
      public.is_event_creator(event_id, auth.uid())
      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')
    )
  );
