-- Ensure messages has organization_id and insert trigger
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS organization_id UUID;

CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_messages()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_set_org_on_insert_messages ON public.messages;
CREATE TRIGGER trg_set_org_on_insert_messages
  BEFORE INSERT ON public.messages
  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_messages();
