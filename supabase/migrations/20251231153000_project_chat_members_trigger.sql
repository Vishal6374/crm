-- Trigger to add project members to project chat
CREATE OR REPLACE FUNCTION public.sync_project_member_to_chat()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
  _user_id UUID;
BEGIN
  -- Get the user_id from employees table
  SELECT user_id INTO _user_id
  FROM public.employees
  WHERE id = NEW.employee_id;

  IF _user_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Get the project chat channel
  SELECT id INTO _channel_id
  FROM public.chat_channels
  WHERE project_id = NEW.project_id AND type = 'group' -- Assuming project chat is 'group' or 'project' type?
  ORDER BY created_at DESC
  LIMIT 1;
  
  -- If type 'project' was introduced, check for it
  IF _channel_id IS NULL THEN
     SELECT id INTO _channel_id
     FROM public.chat_channels
     WHERE project_id = NEW.project_id
     ORDER BY created_at DESC
     LIMIT 1;
  END IF;

  IF _channel_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)
    VALUES (_channel_id, _user_id, (SELECT organization_id FROM public.projects WHERE id = NEW.project_id))
    ON CONFLICT (channel_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_add_member_to_chat ON public.project_members;
CREATE TRIGGER trg_add_member_to_chat
AFTER INSERT ON public.project_members
FOR EACH ROW EXECUTE FUNCTION public.sync_project_member_to_chat();
