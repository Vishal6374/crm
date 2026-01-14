BEGIN;

-- Prevent NULL user_id inserts when channel creator is missing
CREATE OR REPLACE FUNCTION public.add_creator_to_participants()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NEW.created_by IS NULL THEN
    RETURN NEW;
  END IF;
  INSERT INTO public.chat_participants (channel_id, user_id)
  VALUES (NEW.id, NEW.created_by)
  ON CONFLICT DO NOTHING;
  RETURN NEW;
END;
$$;

-- Ensure department chat uses a valid creator; fallback to auth.uid()
CREATE OR REPLACE FUNCTION public.create_department_chat_channel()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  _channel_id UUID;
  _creator UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM public.chat_channels WHERE department_id = NEW.id) THEN
    RETURN NEW;
  END IF;

  _creator := COALESCE(NEW.manager_id, auth.uid());

  INSERT INTO public.chat_channels (organization_id, name, type, department_id, created_by)
  VALUES (NEW.organization_id, NEW.name, 'department', NEW.id, _creator)
  RETURNING id INTO _channel_id;

  IF NEW.manager_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_channel_id, NEW.manager_id)
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

COMMIT;

