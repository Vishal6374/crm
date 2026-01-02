-- Basic emails outbox for tracking bulk sends
CREATE TABLE IF NOT EXISTS public.emails_outbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID REFERENCES public.email_templates(id) ON DELETE SET NULL,
  recipient_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  recipient_email TEXT,
  status TEXT NOT NULL DEFAULT 'queued',
  sent_at TIMESTAMPTZ,
  organization_id UUID,
  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.emails_outbox ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_select_emails_outbox" ON public.emails_outbox
  FOR SELECT USING (organization_id = public.current_org_id());

CREATE POLICY "org_insert_emails_outbox" ON public.emails_outbox
  FOR INSERT WITH CHECK (organization_id = public.current_org_id());

CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_emails_outbox()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_set_org_on_insert_emails_outbox ON public.emails_outbox;
CREATE TRIGGER trg_set_org_on_insert_emails_outbox
  BEFORE INSERT ON public.emails_outbox
  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_emails_outbox();
