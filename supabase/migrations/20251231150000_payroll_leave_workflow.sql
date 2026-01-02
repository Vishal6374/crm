-- Payroll and Leave Workflows

-- 1. Payroll Status Update
ALTER TYPE public.payroll_status ADD VALUE IF NOT EXISTS 'approved' AFTER 'pending';

-- 2. Clone Payroll Function
CREATE OR REPLACE FUNCTION public.clone_payroll_month(
  source_month INTEGER,
  source_year INTEGER,
  target_month INTEGER,
  target_year INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _count INTEGER;
  _org UUID;
BEGIN
  _org := public.current_org_id();

  INSERT INTO public.payroll (
    organization_id,
    employee_id,
    month,
    year,
    basic_salary,
    allowances,
    deductions,
    net_salary,
    status
  )
  SELECT 
    organization_id,
    employee_id,
    target_month,
    target_year,
    basic_salary,
    allowances,
    deductions,
    net_salary,
    'pending' -- Draft status
  FROM public.payroll
  WHERE month = source_month 
    AND year = source_year
    AND organization_id = _org
    AND NOT EXISTS (
      SELECT 1 FROM public.payroll p2 
      WHERE p2.employee_id = payroll.employee_id 
        AND p2.month = target_month 
        AND p2.year = target_year
    );
    
  GET DIAGNOSTICS _count = ROW_COUNT;
  RETURN _count;
END;
$$;

-- 3. Payroll RLS Refinement
DROP POLICY IF EXISTS "hr_admin_manage_payroll" ON public.payroll;

-- HR can INSERT (Create Draft)
CREATE POLICY "hr_create_payroll" ON public.payroll
  FOR INSERT WITH CHECK (
    public.is_hr(auth.uid()) 
    OR public.is_tenant_admin(auth.uid())
  );

-- HR can UPDATE (Edit Draft) - only if pending
CREATE POLICY "hr_update_payroll" ON public.payroll
  FOR UPDATE USING (
    (public.is_hr(auth.uid()) AND status = 'pending')
    OR public.is_tenant_admin(auth.uid())
  );

-- Admin can Approve (Update status)
-- Covered by above: Admin can update anything. 
-- HR limited to pending.

-- Admin/HR can Select
CREATE POLICY "hr_admin_view_payroll" ON public.payroll
  FOR SELECT USING (
    public.is_hr(auth.uid()) 
    OR public.is_tenant_admin(auth.uid())
  );

-- Admin can Delete
CREATE POLICY "admin_delete_payroll" ON public.payroll
  FOR DELETE USING (public.is_tenant_admin(auth.uid()));


-- 4. Leave Requests Approval Logic
DROP POLICY IF EXISTS "Admins can manage leave requests" ON public.leave_requests;

-- HR can Update (Approve/Reject) Normal Employees
-- Admin can Update All
CREATE POLICY "hr_admin_manage_leave" ON public.leave_requests
  FOR UPDATE USING (
    public.is_tenant_admin(auth.uid())
    OR (
      public.is_hr(auth.uid())
      AND NOT EXISTS (
        -- Check if the employee being approved is an HR or Admin
        SELECT 1 FROM public.employees e
        JOIN public.user_roles ur ON ur.user_id = e.user_id
        WHERE e.id = leave_requests.employee_id
          AND ur.role IN ('hr', 'tenant_admin', 'super_admin')
      )
    )
  );

-- Notification Trigger for Leave Status Change
CREATE OR REPLACE FUNCTION public.notify_leave_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO public.notifications (user_id, title, message, type, organization_id)
    SELECT 
      e.user_id,
      'Leave Request ' || NEW.status,
      'Your leave request from ' || NEW.start_date || ' to ' || NEW.end_date || ' has been ' || NEW.status,
      'leave_update',
      NEW.organization_id
    FROM public.employees e
    WHERE e.id = NEW.employee_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_leave ON public.leave_requests;
CREATE TRIGGER trg_notify_leave
AFTER UPDATE ON public.leave_requests
FOR EACH ROW EXECUTE FUNCTION public.notify_leave_status_change();

