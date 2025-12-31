-- Auto-create chat channels for departments and add members
-- Align with updates.md: "When department is created -> auto chat channel"

-- Ensure chat_type enum has 'department'
ALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'department';

-- Auto-create chat channel for departments
CREATE OR REPLACE FUNCTION public.create_department_chat_channel()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
BEGIN
  -- Check if channel already exists
  IF EXISTS (SELECT 1 FROM public.chat_channels WHERE department_id = NEW.id) THEN
    RETURN NEW;
  END IF;

  INSERT INTO public.chat_channels (organization_id, name, type, department_id, created_by)
  VALUES (NEW.organization_id, NEW.name, 'department', NEW.id, NEW.manager_id)
  RETURNING id INTO _channel_id;

  -- Add manager as participant if exists
  IF NEW.manager_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_channel_id, NEW.manager_id)
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_create_department_chat ON public.departments;
CREATE TRIGGER trg_create_department_chat
  AFTER INSERT ON public.departments
  FOR EACH ROW EXECUTE FUNCTION public.create_department_chat_channel();

-- Auto-join department chat when added as member (or department updated)
CREATE OR REPLACE FUNCTION public.join_department_chat_channel()
RETURNS TRIGGER AS $$
DECLARE
  _channel_id UUID;
  _dept_id UUID;
BEGIN
  _dept_id := NEW.department_id;

  IF _dept_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Find the chat channel for this department
  SELECT id INTO _channel_id FROM public.chat_channels 
  WHERE department_id = _dept_id
  LIMIT 1;

  IF _channel_id IS NOT NULL AND NEW.user_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_channel_id, NEW.user_id)
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_join_department_chat ON public.employees;
CREATE TRIGGER trg_join_department_chat
  AFTER INSERT OR UPDATE OF department_id ON public.employees
  FOR EACH ROW EXECUTE FUNCTION public.join_department_chat_channel();
