-- Create chat type enum
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'chat_type') THEN
    CREATE TYPE public.chat_type AS ENUM ('direct', 'group');
  END IF;
END
$$;

-- Create chat channels table
CREATE TABLE IF NOT EXISTS public.chat_channels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type public.chat_type NOT NULL,
  name TEXT,
  department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Create chat participants table
CREATE TABLE IF NOT EXISTS public.chat_participants (
  channel_id UUID REFERENCES public.chat_channels(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_read_at TIMESTAMPTZ,
  PRIMARY KEY (channel_id, user_id)
);

-- Create chat messages table
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_id UUID REFERENCES public.chat_channels(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  attachments JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_chat_participants_user ON public.chat_participants(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_channel ON public.chat_messages(channel_id, created_at);

-- Add chat_channel to entity_type enum for notifications
ALTER TYPE public.entity_type ADD VALUE IF NOT EXISTS 'chat_channel';
ALTER TYPE public.entity_type ADD VALUE IF NOT EXISTS 'chat_message';

-- Add RLS policies
ALTER TABLE public.chat_channels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- Policies for chat_channels
-- Users can view channels they are participants of
CREATE POLICY "Users can view channels they are in" ON public.chat_channels
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.chat_participants
      WHERE channel_id = chat_channels.id AND user_id = auth.uid()
    )
  );

-- Users can create channels (and will be added as participant automatically via trigger/logic)
CREATE POLICY "Users can create channels" ON public.chat_channels
  FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Policies for chat_participants
-- Users can view participants of channels they are in
CREATE POLICY "Users can view participants of their channels" ON public.chat_participants
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.chat_participants cp
      WHERE cp.channel_id = chat_participants.channel_id AND cp.user_id = auth.uid()
    )
  );

-- Users can add participants (if they are in the channel? or open?)
-- For now, let's say anyone can add anyone to a channel if they are in it, or creators.
CREATE POLICY "Participants can add others" ON public.chat_participants
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.chat_participants cp
      WHERE cp.channel_id = chat_participants.channel_id AND cp.user_id = auth.uid()
    )
    OR
    EXISTS (
       SELECT 1 FROM public.chat_channels cc
       WHERE cc.id = chat_participants.channel_id AND cc.created_by = auth.uid()
    )
  );

-- Policies for chat_messages
-- Users can view messages in their channels
CREATE POLICY "Users can view messages in their channels" ON public.chat_messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.chat_participants
      WHERE channel_id = chat_messages.channel_id AND user_id = auth.uid()
    )
  );

-- Users can insert messages in their channels
CREATE POLICY "Users can send messages to their channels" ON public.chat_messages
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.chat_participants
      WHERE channel_id = chat_messages.channel_id AND user_id = auth.uid()
    )
    AND sender_id = auth.uid()
  );

-- Function to automatically add creator to participants
CREATE OR REPLACE FUNCTION public.add_creator_to_participants()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.chat_participants (channel_id, user_id)
  VALUES (NEW.id, NEW.created_by);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_add_creator_to_participants
  AFTER INSERT ON public.chat_channels
  FOR EACH ROW
  EXECUTE FUNCTION public.add_creator_to_participants();

-- Function to notify participants on new message
CREATE OR REPLACE FUNCTION public.notify_chat_participants()
RETURNS TRIGGER AS $$
DECLARE
  _participant_id UUID;
BEGIN
  FOR _participant_id IN
    SELECT user_id FROM public.chat_participants
    WHERE channel_id = NEW.channel_id AND user_id != NEW.sender_id
  LOOP
    INSERT INTO public.notifications (user_id, type, entity_type, entity_id, title, body)
    VALUES (
      _participant_id,
      'message',
      'chat_channel',
      NEW.channel_id,
      'New Message',
      substring(NEW.content from 1 for 50)
    );
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_notify_chat_participants
  AFTER INSERT ON public.chat_messages
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_chat_participants();
