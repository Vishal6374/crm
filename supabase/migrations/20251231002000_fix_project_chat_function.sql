-- Fix project chat creation to avoid null user_id in chat_participants
-- Uses NEW.owner_id as primary source, fallback to auth.uid(), and skips participant insert if user_id is null

CREATE OR REPLACE FUNCTION public.create_project_chat()
RETURNS TRIGGER AS $$
DECLARE
  _chan_id UUID;
  _creator UUID;
BEGIN
  _creator := COALESCE(NEW.owner_id, auth.uid());

  INSERT INTO public.chat_channels (type, name, created_by, project_id)
  VALUES (
    'group',
    COALESCE('Project: ' || NEW.name, 'Project Chat'),
    COALESCE(_creator, auth.uid()),
    NEW.id
  )
  RETURNING id INTO _chan_id;

  IF _creator IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_chan_id, _creator);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

