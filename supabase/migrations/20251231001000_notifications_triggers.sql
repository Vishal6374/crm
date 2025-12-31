-- Notifications triggers for assignments and creations (tasks, deals)
-- Align with updates.md: notify on assignment, task creation, deal creation, chat messages (chat handled separately)

-- Ensure notifications has 'type' column
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS type TEXT;

-- Function: notify on assignment changes
CREATE OR REPLACE FUNCTION public.notify_assignment_change()
RETURNS TRIGGER AS $$
DECLARE
  _target_user UUID;
  _entity TEXT;
  _entity_id UUID;
  _title TEXT;
  _body TEXT;
BEGIN
  IF TG_TABLE_NAME = 'tasks' THEN
    _entity := 'task';
    _entity_id := COALESCE(NEW.id, OLD.id);
    _target_user := NEW.assigned_to;
    _title := 'Task Assignment';
    _body := COALESCE(NEW.title, 'Task updated');
  ELSIF TG_TABLE_NAME = 'deals' THEN
    _entity := 'deal';
    _entity_id := COALESCE(NEW.id, OLD.id);
    _target_user := NEW.assigned_to;
    _title := 'Deal Assignment';
    _body := COALESCE(NEW.title, 'Deal updated');
  ELSE
    RETURN COALESCE(NEW, OLD);
  END IF;

  IF _target_user IS NOT NULL THEN
    INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id)
    VALUES (_target_user, 'assignment', _title, _body, _entity, _entity_id);
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: notify on creation
CREATE OR REPLACE FUNCTION public.notify_creation()
RETURNS TRIGGER AS $$
DECLARE
  _target_user UUID;
  _entity TEXT;
  _title TEXT;
  _body TEXT;
BEGIN
  IF TG_TABLE_NAME = 'tasks' THEN
    _entity := 'task';
    _target_user := NEW.assigned_to;
    _title := 'New Task';
    _body := COALESCE(NEW.title, 'New task created');
  ELSIF TG_TABLE_NAME = 'deals' THEN
    _entity := 'deal';
    _target_user := NEW.assigned_to;
    _title := 'New Deal';
    _body := COALESCE(NEW.title, 'New deal created');
  ELSE
    RETURN NEW;
  END IF;

  IF _target_user IS NOT NULL THEN
    INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id)
    VALUES (_target_user, 'create', _title, _body, _entity, NEW.id);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Attach triggers (idempotent drop/create)
DROP TRIGGER IF EXISTS trg_notify_task_creation ON public.tasks;
CREATE TRIGGER trg_notify_task_creation
  AFTER INSERT ON public.tasks
  FOR EACH ROW EXECUTE FUNCTION public.notify_creation();

DROP TRIGGER IF EXISTS trg_notify_deal_creation ON public.deals;
CREATE TRIGGER trg_notify_deal_creation
  AFTER INSERT ON public.deals
  FOR EACH ROW EXECUTE FUNCTION public.notify_creation();

DROP TRIGGER IF EXISTS trg_notify_task_assignment ON public.tasks;
CREATE TRIGGER trg_notify_task_assignment
  AFTER UPDATE OF assigned_to ON public.tasks
  FOR EACH ROW EXECUTE FUNCTION public.notify_assignment_change();

DROP TRIGGER IF EXISTS trg_notify_deal_assignment ON public.deals;
CREATE TRIGGER trg_notify_deal_assignment
  AFTER UPDATE OF assigned_to ON public.deals
  FOR EACH ROW EXECUTE FUNCTION public.notify_assignment_change();

