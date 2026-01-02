-- Fix Payroll RLS to prevent HR from approving
DROP POLICY IF EXISTS "hr_update_payroll" ON public.payroll;

CREATE POLICY "hr_update_payroll" ON public.payroll
  FOR UPDATE USING (
    (public.is_hr(auth.uid()) AND status = 'pending')
    OR public.is_tenant_admin(auth.uid())
  )
  WITH CHECK (
    (public.is_hr(auth.uid()) AND status = 'pending') -- HR cannot change status to anything else (remain pending)
    OR public.is_tenant_admin(auth.uid())
  );
