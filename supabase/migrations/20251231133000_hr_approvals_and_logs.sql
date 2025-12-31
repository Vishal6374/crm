-- HR approvals and activity logs retention
-- 1) Payroll approval fields and notification trigger
-- 2) Leave request decision notification
-- 3) Activity logs retention per organization (keep latest 500)

-- Payroll approval fields
ALTER TABLE public.payroll
  ADD COLUMN IF NOT EXISTS approval_status TEXT CHECK (approval_status IN ('approved','rejected')) NULL,
  ADD COLUMN IF NOT EXISTS approved_by UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS decision_note TEXT NULL;

-- Notify on payroll approval/rejection
CREATE OR REPLACE FUNCTION public.notify_payroll_approval()
RETURNS TRIGGER AS $$
DECLARE
  _employee_user UUID;
BEGIN
  IF NEW.approval_status IS DISTINCT FROM OLD.approval_status THEN
    SELECT user_id INTO _employee_user FROM public.employees WHERE id = NEW.employee_id;
    IF _employee_user IS NOT NULL THEN
      INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)
      VALUES (
        _employee_user,
        'payroll_approval',
        CASE NEW.approval_status WHEN 'approved' THEN 'Payroll Approved' ELSE 'Payroll Rejected' END,
        COALESCE(NEW.decision_note, ''),
        'payroll',
        NEW.id,
        public.current_org_id()
      );
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_payroll_approval ON public.payroll;
CREATE TRIGGER trg_notify_payroll_approval
AFTER UPDATE OF approval_status ON public.payroll
FOR EACH ROW EXECUTE FUNCTION public.notify_payroll_approval();

-- Notify on leave decision
CREATE OR REPLACE FUNCTION public.notify_leave_decision()
RETURNS TRIGGER AS $$
DECLARE
  _employee_user UUID;
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status AND NEW.status IN ('approved','rejected') THEN
    SELECT user_id INTO _employee_user FROM public.employees WHERE id = NEW.employee_id;
    IF _employee_user IS NOT NULL THEN
      INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)
      VALUES (
        _employee_user,
        'leave_decision',
        CASE NEW.status WHEN 'approved' THEN 'Leave Approved' ELSE 'Leave Rejected' END,
        COALESCE(NEW.reason, ''),
        'leave_request',
        NEW.id,
        public.current_org_id()
      );
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_leave_decision ON public.leave_requests;
CREATE TRIGGER trg_notify_leave_decision
AFTER UPDATE OF status ON public.leave_requests
FOR EACH ROW EXECUTE FUNCTION public.notify_leave_decision();

-- Activity logs retention: keep latest 500 per org
CREATE OR REPLACE FUNCTION public.retain_activity_logs_limit()
RETURNS TRIGGER AS $$
BEGIN
  WITH ranked AS (
    SELECT id,
           organization_id,
           created_at,
           row_number() OVER (PARTITION BY organization_id ORDER BY created_at DESC) AS rn
    FROM public.activity_logs
  )
  DELETE FROM public.activity_logs al
  USING ranked r
  WHERE al.id = r.id
    AND r.rn > 500;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_retain_activity_logs_limit ON public.activity_logs;
CREATE TRIGGER trg_retain_activity_logs_limit
AFTER INSERT ON public.activity_logs
FOR EACH STATEMENT EXECUTE FUNCTION public.retain_activity_logs_limit();

