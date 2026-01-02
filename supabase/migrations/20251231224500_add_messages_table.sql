-- Generic messages/comments table for entities (leads, deals, tasks, etc.)
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  mentions UUID[] DEFAULT '{}',
  organization_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS organization_id UUID;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'messages' AND policyname = 'org_select_messages'
  ) THEN
    EXECUTE 'CREATE POLICY "org_select_messages" ON public.messages FOR SELECT USING (organization_id = public.current_org_id())';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'messages' AND policyname = 'org_insert_messages'
  ) THEN
    EXECUTE 'CREATE POLICY "org_insert_messages" ON public.messages FOR INSERT WITH CHECK (organization_id = public.current_org_id())';
  END IF;
END $$;

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
