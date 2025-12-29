-- Add chat tables to supabase_realtime publication to ensure real-time events are sent
-- We use a DO block to avoid errors if they are already added or if the publication is defined differently
DO $$
BEGIN
  -- Try to add tables to the publication. 
  -- Note: If 'supabase_realtime' is defined as FOR ALL TABLES, this might not be needed, 
  -- but explicitly adding them ensures they are tracked if it's a specific list.
  
  -- We check if the publication exists first
  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_messages;
    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_channels;
    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_participants;
  END IF;
EXCEPTION
  WHEN duplicate_object THEN
    -- If tables are already in the publication, ignore the error
    NULL;
  WHEN OTHERS THEN
    -- In case of other errors (like publication not existing which shouldn't happen in Supabase), log or ignore
    NULL;
END
$$;
