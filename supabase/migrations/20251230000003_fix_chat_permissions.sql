-- Fix profiles RLS to allow searching users (for DM and Group add)
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Authenticated users can view all profiles" ON public.profiles
  FOR SELECT TO authenticated USING (true);

-- Update chat_channels policy to ensure creators can always view their channels immediately
-- This prevents issues where the SELECT after INSERT fails because the participant trigger hasn't completed/propagated yet
DROP POLICY IF EXISTS "Users can view channels they are in" ON public.chat_channels;

CREATE POLICY "Users can view channels they are in or created" ON public.chat_channels
  FOR SELECT USING (
    public.is_chat_participant(id) 
    OR 
    created_by = auth.uid()
  );
