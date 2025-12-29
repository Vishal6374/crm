-- Fix RLS recursion by using Security Definer functions
-- This prevents the policies from triggering infinite loops when querying the same tables

-- 1. Function to check if user is participant of a channel
CREATE OR REPLACE FUNCTION public.is_chat_participant(_channel_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM chat_participants
    WHERE channel_id = _channel_id AND user_id = auth.uid()
  );
$$;

-- 2. Function to check if user is creator of a channel
CREATE OR REPLACE FUNCTION public.is_channel_creator(_channel_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM chat_channels
    WHERE id = _channel_id AND created_by = auth.uid()
  );
$$;

-- 3. Drop existing policies to replace them
DROP POLICY IF EXISTS "Users can view channels they are in" ON public.chat_channels;
DROP POLICY IF EXISTS "Users can create channels" ON public.chat_channels;
DROP POLICY IF EXISTS "Users can view participants of their channels" ON public.chat_participants;
DROP POLICY IF EXISTS "Participants can add others" ON public.chat_participants;
DROP POLICY IF EXISTS "Users can view messages in their channels" ON public.chat_messages;
DROP POLICY IF EXISTS "Users can send messages to their channels" ON public.chat_messages;

-- 4. Re-create policies using the safe functions

-- Chat Channels
CREATE POLICY "Users can view channels they are in" ON public.chat_channels
  FOR SELECT USING (
    public.is_chat_participant(id)
  );

CREATE POLICY "Users can create channels" ON public.chat_channels
  FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Chat Participants
-- Users can view participants if they are in the channel themselves
CREATE POLICY "Users can view participants of their channels" ON public.chat_participants
  FOR SELECT USING (
    public.is_chat_participant(channel_id)
  );

-- Users can add participants if they are already in the channel OR if they are the creator
-- (Using is_channel_creator avoids querying chat_channels RLS, though chat_channels insert RLS is simple)
CREATE POLICY "Participants can add others" ON public.chat_participants
  FOR INSERT WITH CHECK (
    public.is_chat_participant(channel_id)
    OR
    public.is_channel_creator(channel_id)
  );

-- Chat Messages
CREATE POLICY "Users can view messages in their channels" ON public.chat_messages
  FOR SELECT USING (
    public.is_chat_participant(channel_id)
  );

CREATE POLICY "Users can send messages to their channels" ON public.chat_messages
  FOR INSERT WITH CHECK (
    public.is_chat_participant(channel_id)
    AND sender_id = auth.uid()
  );
