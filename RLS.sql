-- ==============================
-- public.activity_logs
-- ==============================

ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view all logs"
ON public.activity_logs
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "System can create logs"
ON public.activity_logs
FOR INSERT
TO authenticated
WITH CHECK (true)
;

CREATE POLICY "org_strict_select_activity_logs"
ON public.activity_logs
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_activity_logs"
ON public.activity_logs
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_activity_logs"
ON public.activity_logs
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Super admin view all activity_logs"
ON public.activity_logs
FOR SELECT
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_activity_logs"
ON public.activity_logs
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_activity_logs"
ON public.activity_logs
FOR ALL
TO public
USING (is_super_admin())
;


-- ==============================
-- public.attendance
-- ==============================

ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_update_attendance"
ON public.attendance
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_attendance"
ON public.attendance
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "hr_admin_manage_attendance"
ON public.attendance
FOR ALL
TO public
USING ((is_tenant_admin(auth.uid()) OR is_hr(auth.uid())))
;

CREATE POLICY "employee_view_own_attendance"
ON public.attendance
FOR SELECT
TO public
USING ((EXISTS ( SELECT 1
   FROM employees e
  WHERE ((e.id = attendance.employee_id) AND (e.user_id = auth.uid())))))
;

CREATE POLICY "super_admin_all_attendance"
ON public.attendance
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_select_attendance"
ON public.attendance
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_attendance"
ON public.attendance
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;


-- ==============================
-- public.chat_channels
-- ==============================

ALTER TABLE public.chat_channels ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can create channels"
ON public.chat_channels
FOR INSERT
TO public
WITH CHECK ((auth.uid() = created_by))
;

CREATE POLICY "org_strict_insert_chat_channels"
ON public.chat_channels
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_chat_channels"
ON public.chat_channels
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_chat_channels"
ON public.chat_channels
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_chat_channels"
ON public.chat_channels
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "Users can view channels they are in or created"
ON public.chat_channels
FOR SELECT
TO public
USING ((is_chat_participant(id) OR (created_by = auth.uid())))
;

CREATE POLICY "org_strict_update_chat_channels"
ON public.chat_channels
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;


-- ==============================
-- public.chat_messages
-- ==============================

ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can send messages to their channels"
ON public.chat_messages
FOR INSERT
TO public
WITH CHECK ((is_chat_participant(channel_id) AND (sender_id = auth.uid())))
;

CREATE POLICY "Users can view messages in their channels"
ON public.chat_messages
FOR SELECT
TO public
USING (is_chat_participant(channel_id))
;

CREATE POLICY "super_admin_all_chat_messages"
ON public.chat_messages
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_chat_messages"
ON public.chat_messages
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_chat_messages"
ON public.chat_messages
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_chat_messages"
ON public.chat_messages
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_chat_messages"
ON public.chat_messages
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;


-- ==============================
-- public.chat_participants
-- ==============================

ALTER TABLE public.chat_participants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view participants of their channels"
ON public.chat_participants
FOR SELECT
TO public
USING (is_chat_participant(channel_id))
;

CREATE POLICY "Participants can add others"
ON public.chat_participants
FOR INSERT
TO public
WITH CHECK ((is_chat_participant(channel_id) OR is_channel_creator(channel_id)))
;

CREATE POLICY "org_strict_delete_chat_participants"
ON public.chat_participants
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_chat_participants"
ON public.chat_participants
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_chat_participants"
ON public.chat_participants
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_chat_participants"
ON public.chat_participants
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_select_chat_participants"
ON public.chat_participants
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.companies
-- ==============================

ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_update_companies"
ON public.companies
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_companies"
ON public.companies
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Authenticated users can create companies"
ON public.companies
FOR INSERT
TO authenticated
WITH CHECK ((auth.uid() = created_by))
;

CREATE POLICY "Authenticated users can view companies"
ON public.companies
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "super_admin_all_companies"
ON public.companies
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_insert_companies"
ON public.companies
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Admins can delete companies"
ON public.companies
FOR DELETE
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "Users can update their own companies"
ON public.companies
FOR UPDATE
TO public
USING (((auth.uid() = created_by) OR is_admin_or_manager(auth.uid())))
;

CREATE POLICY "org_strict_select_companies"
ON public.companies
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;


-- ==============================
-- public.contacts
-- ==============================

ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_delete_contacts"
ON public.contacts
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_contacts"
ON public.contacts
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Users can update their own contacts"
ON public.contacts
FOR UPDATE
TO public
USING (((auth.uid() = created_by) OR is_admin_or_manager(auth.uid())))
;

CREATE POLICY "Authenticated users can view contacts"
ON public.contacts
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "Authenticated users can create contacts"
ON public.contacts
FOR INSERT
TO authenticated
WITH CHECK ((auth.uid() = created_by))
;

CREATE POLICY "Admins can delete contacts"
ON public.contacts
FOR DELETE
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "super_admin_all_contacts"
ON public.contacts
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_update_contacts"
ON public.contacts
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_contacts"
ON public.contacts
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;


-- ==============================
-- public.deals
-- ==============================

ALTER TABLE public.deals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can delete deals"
ON public.deals
FOR DELETE
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "org_strict_select_deals"
ON public.deals
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_deals"
ON public.deals
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_deals"
ON public.deals
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_deals"
ON public.deals
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Assigned users can update deals"
ON public.deals
FOR UPDATE
TO public
USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by) OR is_admin_or_manager(auth.uid())))
;

CREATE POLICY "admin_manager_view_all_deals"
ON public.deals
FOR SELECT
TO public
USING ((is_tenant_admin(auth.uid()) OR is_manager(auth.uid())))
;

CREATE POLICY "employee_view_assigned_deals"
ON public.deals
FOR SELECT
TO public
USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by)))
;

CREATE POLICY "super_admin_all_deals"
ON public.deals
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "Authenticated users can create deals"
ON public.deals
FOR INSERT
TO authenticated
WITH CHECK ((auth.uid() = created_by))
;

-- ==============================
-- public.departments
-- ==============================

ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_update_departments"
ON public.departments
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_departments"
ON public.departments
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Authenticated users can view departments"
ON public.departments
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "super_admin_all_departments"
ON public.departments
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "Admins can manage departments"
ON public.departments
FOR ALL
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "org_strict_delete_departments"
ON public.departments
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_departments"
ON public.departments
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

-- ==============================
-- public.designations
-- ==============================

ALTER TABLE public.designations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_delete_designations"
ON public.designations
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_designations"
ON public.designations
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Authenticated users can view designations"
ON public.designations
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "org_strict_insert_designations"
ON public.designations
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_designations"
ON public.designations
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Admins can manage designations"
ON public.designations
FOR ALL
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "super_admin_all_designations"
ON public.designations
FOR ALL
TO public
USING (is_super_admin())
;


-- ==============================
-- public.email_templates
-- ==============================

ALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins and Managers can manage templates"
ON public.email_templates
FOR ALL
TO public
USING (((organization_id = current_org_id()) AND (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = ANY (ARRAY['tenant_admin'::app_role, 'manager'::app_role, 'hr'::app_role])))))))
;

CREATE POLICY "org_strict_insert_email_templates"
ON public.email_templates
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_email_templates"
ON public.email_templates
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_email_templates"
ON public.email_templates
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Users can view their org's templates"
ON public.email_templates
FOR SELECT
TO public
USING ((organization_id = ( SELECT profiles.organization_id
   FROM profiles
  WHERE (profiles.id = auth.uid()))))
;

CREATE POLICY "org_strict_update_email_templates"
ON public.email_templates
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_email_templates"
ON public.email_templates
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.emails_outbox
-- ==============================

ALTER TABLE public.emails_outbox ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_emails_outbox"
ON public.emails_outbox
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_emails_outbox"
ON public.emails_outbox
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_emails_outbox"
ON public.emails_outbox
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_emails_outbox"
ON public.emails_outbox
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_select_emails_outbox"
ON public.emails_outbox
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.employees
-- ==============================

ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

CREATE POLICY "hr_admin_view_all_employees"
ON public.employees
FOR SELECT
TO public
USING ((is_tenant_admin(auth.uid()) OR is_hr(auth.uid())))
;

CREATE POLICY "org_strict_update_employees"
ON public.employees
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_employees"
ON public.employees
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Admins can manage employees"
ON public.employees
FOR ALL
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "org_strict_select_employees"
ON public.employees
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_employees"
ON public.employees
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_employees"
ON public.employees
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "user_view_own_employee_record"
ON public.employees
FOR SELECT
TO public
USING ((user_id = auth.uid()))
;

-- ==============================
-- public.event_attendees
-- ==============================

ALTER TABLE public.event_attendees ENABLE ROW LEVEL SECURITY;

CREATE POLICY "super_admin_all_event_attendees"
ON public.event_attendees
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_update_event_attendees"
ON public.event_attendees
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_event_attendees"
ON public.event_attendees
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_event_attendees"
ON public.event_attendees
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_event_attendees"
ON public.event_attendees
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

-- ==============================
-- public.events
-- ==============================

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "super_admin_all_events"
ON public.events
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_insert_events"
ON public.events
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_events"
ON public.events
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_events"
ON public.events
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_events"
ON public.events
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;
-- ==============================
-- public.invitations
-- ==============================

ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_invitations"
ON public.invitations
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_invitations"
ON public.invitations
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Tenant Admins can view invites"
ON public.invitations
FOR SELECT
TO public
USING (((organization_id = current_org_id()) AND (EXISTS ( SELECT 1
   FROM user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "Tenant Admins can create invites"
ON public.invitations
FOR INSERT
TO public
WITH CHECK (((organization_id = current_org_id()) AND (EXISTS ( SELECT 1
   FROM user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "Tenant Admins can delete invites"
ON public.invitations
FOR DELETE
TO public
USING (((organization_id = current_org_id()) AND (EXISTS ( SELECT 1
   FROM user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "Super Admins can manage all invites"
ON public.invitations
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "super_admin_all_invitations"
ON public.invitations
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_invitations"
ON public.invitations
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_invitations"
ON public.invitations
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

-- ==============================
-- public.leads
-- ==============================

ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_update_own_leads"
ON public.leads
FOR UPDATE
TO public
USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by) OR is_tenant_admin(auth.uid()) OR is_manager(auth.uid())))
;

CREATE POLICY "leads_org_select"
ON public.leads
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "leads_user_own_select"
ON public.leads
FOR SELECT
TO public
USING (((organization_id = current_org_id()) AND ((auth.uid() = assigned_to) OR (auth.uid() = created_by))))
;

CREATE POLICY "leads_tenant_admin_select"
ON public.leads
FOR SELECT
TO public
USING (((organization_id = current_org_id()) AND is_tenant_admin(auth.uid())))
;

CREATE POLICY "authenticated_create_leads"
ON public.leads
FOR INSERT
TO public
WITH CHECK ((auth.uid() = created_by))
;

CREATE POLICY "org_strict_update_leads"
ON public.leads
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_leads"
ON public.leads
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "tenant_admin_delete_leads"
ON public.leads
FOR DELETE
TO public
USING (is_tenant_admin(auth.uid()))
;

CREATE POLICY "org_strict_select_leads"
ON public.leads
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_leads"
ON public.leads
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_leads"
ON public.leads
FOR ALL
TO public
USING (is_super_admin())
;


-- ==============================
-- public.leave_requests
-- ==============================

ALTER TABLE public.leave_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_leave_requests"
ON public.leave_requests
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_leave_requests"
ON public.leave_requests
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "hr_admin_manage_leave"
ON public.leave_requests
FOR UPDATE
TO public
USING ((is_tenant_admin(auth.uid()) OR (is_hr(auth.uid()) AND (NOT (EXISTS ( SELECT 1
   FROM (employees e
     JOIN user_roles ur ON ((ur.user_id = e.user_id)))
  WHERE ((e.id = leave_requests.employee_id) AND (ur.role = ANY (ARRAY['hr'::app_role, 'tenant_admin'::app_role, 'super_admin'::app_role])))))))))
;

CREATE POLICY "org_strict_update_leave_requests"
ON public.leave_requests
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Employees can delete their pending requests"
ON public.leave_requests
FOR DELETE
TO public
USING (((EXISTS ( SELECT 1
   FROM employees
  WHERE ((employees.id = leave_requests.employee_id) AND (employees.user_id = auth.uid())))) AND (status = 'pending'::leave_status)))
;

CREATE POLICY "Employees can create leave requests"
ON public.leave_requests
FOR INSERT
TO authenticated
WITH CHECK ((EXISTS ( SELECT 1
   FROM employees
  WHERE ((employees.id = leave_requests.employee_id) AND (employees.user_id = auth.uid())))))
;

CREATE POLICY "Employees can view their own leave requests"
ON public.leave_requests
FOR SELECT
TO public
USING (((EXISTS ( SELECT 1
   FROM employees
  WHERE ((employees.id = leave_requests.employee_id) AND (employees.user_id = auth.uid())))) OR is_admin_or_manager(auth.uid())))
;

CREATE POLICY "super_admin_all_leave_requests"
ON public.leave_requests
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_leave_requests"
ON public.leave_requests
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;


-- ==============================
-- public.messages
-- ==============================

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "super_admin_all_messages"
ON public.messages
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_update_messages"
ON public.messages
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_messages"
ON public.messages
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_messages"
ON public.messages
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_messages"
ON public.messages
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

-- ==============================
-- public.notifications
-- ==============================

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_select_notifications"
ON public.notifications
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "own_select_notifications"
ON public.notifications
FOR SELECT
TO public
USING (((user_id = auth.uid()) AND (organization_id = current_org_id())))
;

CREATE POLICY "own_insert_notifications"
ON public.notifications
FOR INSERT
TO public
WITH CHECK (((user_id = auth.uid()) AND (organization_id = current_org_id())))
;

CREATE POLICY "own_update_notifications"
ON public.notifications
FOR UPDATE
TO public
USING (((user_id = auth.uid()) AND (organization_id = current_org_id())))
WITH CHECK (((user_id = auth.uid()) AND (organization_id = current_org_id())))
;

CREATE POLICY "own_delete_notifications"
ON public.notifications
FOR DELETE
TO public
USING (((user_id = auth.uid()) AND (organization_id = current_org_id())))
;

CREATE POLICY "super_admin_all_notifications"
ON public.notifications
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_insert_notifications"
ON public.notifications
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_notifications"
ON public.notifications
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_notifications"
ON public.notifications
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.organizations
-- ==============================

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_view_self"
ON public.organizations
FOR SELECT
TO public
USING (((id = current_org_id()) OR is_super_admin()))
;

CREATE POLICY "Users can view their own organization"
ON public.organizations
FOR SELECT
TO public
USING ((id = current_org_id()))
;

CREATE POLICY "Super admin full access on organizations"
ON public.organizations
FOR ALL
TO public
USING (is_super_admin())
;


-- ==============================
-- public.payments
-- ==============================

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_payments"
ON public.payments
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_payments"
ON public.payments
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_payments"
ON public.payments
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_payments"
ON public.payments
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_payments"
ON public.payments
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;


-- ==============================
-- public.payroll
-- ==============================

ALTER TABLE public.payroll ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_payroll"
ON public.payroll
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_payroll"
ON public.payroll
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_payroll"
ON public.payroll
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "hr_create_payroll"
ON public.payroll
FOR INSERT
TO public
WITH CHECK ((is_hr(auth.uid()) OR is_tenant_admin(auth.uid())))
;

CREATE POLICY "employee_view_own_payroll"
ON public.payroll
FOR SELECT
TO public
USING ((EXISTS ( SELECT 1
   FROM employees e
  WHERE ((e.id = payroll.employee_id) AND (e.user_id = auth.uid())))))
;

CREATE POLICY "org_strict_update_payroll"
ON public.payroll
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "hr_admin_view_payroll"
ON public.payroll
FOR SELECT
TO public
USING ((is_hr(auth.uid()) OR is_tenant_admin(auth.uid())))
;

CREATE POLICY "hr_update_payroll"
ON public.payroll
FOR UPDATE
TO public
USING (((is_hr(auth.uid()) AND (status = 'pending'::payroll_status)) OR is_tenant_admin(auth.uid())))
WITH CHECK (((is_hr(auth.uid()) AND (status = 'pending'::payroll_status)) OR is_tenant_admin(auth.uid())))
;

CREATE POLICY "admin_delete_payroll"
ON public.payroll
FOR DELETE
TO public
USING (is_tenant_admin(auth.uid()))
;

CREATE POLICY "org_strict_select_payroll"
ON public.payroll
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.profiles
-- ==============================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Super admin view all profiles"
ON public.profiles
FOR SELECT
TO public
USING (is_super_admin())
;

CREATE POLICY "Authenticated users can view all profiles"
ON public.profiles
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "Admins can view all profiles"
ON public.profiles
FOR SELECT
TO public
USING (is_admin_or_manager(auth.uid()))
;

CREATE POLICY "profile_read"
ON public.profiles
FOR SELECT
TO public
USING (((id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM employees e
  WHERE ((e.user_id = profiles.id) AND (e.organization_id = current_org_id())))) OR is_super_admin()))
;

CREATE POLICY "profile_update_self"
ON public.profiles
FOR UPDATE
TO public
USING ((id = auth.uid()))
;

CREATE POLICY "Users can update their own profile"
ON public.profiles
FOR UPDATE
TO public
USING ((auth.uid() = id))
;

CREATE POLICY "Super admin full access on profiles"
ON public.profiles
FOR ALL
TO public
USING (is_super_admin())
;

-- ==============================
-- public.project_meetings
-- ==============================

ALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_update_project_meetings"
ON public.project_meetings
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_project_meetings"
ON public.project_meetings
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_select_project_meetings"
ON public.project_meetings
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_project_meetings"
ON public.project_meetings
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "project_members_select_meetings"
ON public.project_meetings
FOR SELECT
TO public
USING ((is_project_member_or_owner(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "org_strict_delete_project_meetings"
ON public.project_meetings
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "project_manager_insert_meetings"
ON public.project_meetings
FOR INSERT
TO public
WITH CHECK ((EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_meetings.project_id) AND (e.user_id = auth.uid()) AND (lower(pm.role) = 'manager'::text)))))
;

CREATE POLICY "Project managers and admins can manage meetings"
ON public.project_meetings
FOR ALL
TO public
USING (((get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_meetings.project_id) AND (e.user_id = auth.uid()) AND (lower(pm.role) = 'manager'::text)))) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

-- ==============================
-- public.project_members
-- ==============================

ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "select_project_members_visible"
ON public.project_members
FOR SELECT
TO public
USING ((is_project_member_or_owner(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "super_admin_all_project_members"
ON public.project_members
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_select_project_members"
ON public.project_members
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_project_members"
ON public.project_members
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_project_members"
ON public.project_members
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_project_members"
ON public.project_members
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "manage_project_members"
ON public.project_members
FOR ALL
TO public
USING (((get_project_owner(project_id) = auth.uid()) OR is_project_manager(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
WITH CHECK (((get_project_owner(project_id) = auth.uid()) OR is_project_manager(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

-- ==============================
-- public.project_tasks
-- ==============================

ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Project members can delete tasks"
ON public.project_tasks
FOR DELETE
TO public
USING (((get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid()) AND (lower(pm.role) = 'manager'::text)))) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "project_members_select_tasks"
ON public.project_tasks
FOR SELECT
TO public
USING ((is_project_member_or_owner(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "super_admin_all_project_tasks"
ON public.project_tasks
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "Project members can update tasks"
ON public.project_tasks
FOR UPDATE
TO public
USING (((get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "org_strict_insert_project_tasks"
ON public.project_tasks
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_project_tasks"
ON public.project_tasks
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_project_tasks"
ON public.project_tasks
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_project_tasks"
ON public.project_tasks
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Project members can create/update tasks"
ON public.project_tasks
FOR ALL
TO public
USING (((EXISTS ( SELECT 1
   FROM project_members pm
  WHERE ((pm.project_id = project_tasks.project_id) AND (pm.employee_id IN ( SELECT employees.id
           FROM employees
          WHERE (employees.user_id = auth.uid())))))) OR (EXISTS ( SELECT 1
   FROM projects p
  WHERE ((p.id = project_tasks.project_id) AND (p.owner_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "Project members can create tasks"
ON public.project_tasks
FOR INSERT
TO public
WITH CHECK (((get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;

CREATE POLICY "project_members_modify_tasks"
ON public.project_tasks
FOR ALL
TO public
USING (((EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM projects p
  WHERE ((p.id = project_tasks.project_id) AND (p.owner_id = auth.uid()))))))
;

CREATE POLICY "Project members can view tasks"
ON public.project_tasks
FOR SELECT
TO public
USING (((get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (project_members pm
     JOIN employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role))))))
;


-- ==============================
-- public.projects
-- ==============================

ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_update_projects"
ON public.projects
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_projects"
ON public.projects
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "creator_or_member_select_projects"
ON public.projects
FOR SELECT
TO public
USING (((organization_id = current_org_id()) AND ((owner_id = auth.uid()) OR is_project_member_or_owner(id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::app_role)))))))
;

CREATE POLICY "org_strict_select_projects"
ON public.projects
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_projects"
ON public.projects
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_projects"
ON public.projects
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "admin_or_manager_insert_projects"
ON public.projects
FOR INSERT
TO public
WITH CHECK (((organization_id = current_org_id()) AND (EXISTS ( SELECT 1
   FROM user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.organization_id = current_org_id()) AND (ur.role = ANY (ARRAY['admin'::app_role, 'manager'::app_role])))))))
;

-- ==============================
-- public.role_capabilities
-- ==============================

ALTER TABLE public.role_capabilities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "super_admin_all_role_capabilities"
ON public.role_capabilities
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_role_capabilities"
ON public.role_capabilities
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_role_capabilities"
ON public.role_capabilities
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_role_capabilities"
ON public.role_capabilities
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_role_capabilities"
ON public.role_capabilities
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;


-- ==============================
-- public.settings
-- ==============================

ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "super_admin_all_settings"
ON public.settings
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_select_settings"
ON public.settings
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_settings"
ON public.settings
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_settings"
ON public.settings
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_settings"
ON public.settings
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.task_collaborators
-- ==============================

ALTER TABLE public.task_collaborators ENABLE ROW LEVEL SECURITY;

CREATE POLICY "super_admin_all_task_collaborators"
ON public.task_collaborators
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_task_collaborators"
ON public.task_collaborators
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_task_collaborators"
ON public.task_collaborators
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_task_collaborators"
ON public.task_collaborators
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_task_collaborators"
ON public.task_collaborators
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

-- ==============================
-- public.task_timings
-- ==============================

ALTER TABLE public.task_timings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_delete_task_timings"
ON public.task_timings
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_task_timings"
ON public.task_timings
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_task_timings"
ON public.task_timings
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_task_timings"
ON public.task_timings
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_task_timings"
ON public.task_timings
FOR ALL
TO public
USING (is_super_admin())
;


-- ==============================
-- public.tasks
-- ==============================

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_tasks"
ON public.tasks
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_tasks"
ON public.tasks
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "Authenticated users can view tasks"
ON public.tasks
FOR SELECT
TO authenticated
USING (true)
;

CREATE POLICY "org_strict_update_tasks"
ON public.tasks
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_delete_tasks"
ON public.tasks
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "Authenticated users can create tasks"
ON public.tasks
FOR INSERT
TO authenticated
WITH CHECK ((auth.uid() = created_by))
;

CREATE POLICY "Creators can delete tasks"
ON public.tasks
FOR DELETE
TO public
USING (((auth.uid() = created_by) OR is_admin_or_manager(auth.uid())))
;

CREATE POLICY "Assigned users can update tasks"
ON public.tasks
FOR UPDATE
TO public
USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by) OR is_admin_or_manager(auth.uid())))
;

CREATE POLICY "org_strict_select_tasks"
ON public.tasks
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;



-- ==============================
-- public.tenant_modules
-- ==============================

ALTER TABLE public.tenant_modules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "org_strict_insert_tenant_modules"
ON public.tenant_modules
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Tenant admin can view tenant_modules"
ON public.tenant_modules
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_tenant_modules"
ON public.tenant_modules
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_tenant_modules"
ON public.tenant_modules
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "Super admin full access on tenant_modules"
ON public.tenant_modules
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "Users can view their own organization modules"
ON public.tenant_modules
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "super_admin_all_tenant_modules"
ON public.tenant_modules
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_tenant_modules"
ON public.tenant_modules
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;


-- ==============================
-- public.user_roles
-- ==============================

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage all roles"
ON public.user_roles
FOR ALL
TO public
USING (has_role(auth.uid(), 'admin'::app_role))
;

CREATE POLICY "Users can view their own roles"
ON public.user_roles
FOR SELECT
TO public
USING ((auth.uid() = user_id))
;

CREATE POLICY "Super admin manage user_roles"
ON public.user_roles
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "super_admin_all_user_roles"
ON public.user_roles
FOR ALL
TO public
USING (is_super_admin())
;

CREATE POLICY "org_strict_delete_user_roles"
ON public.user_roles
FOR DELETE
TO public
USING ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_update_user_roles"
ON public.user_roles
FOR UPDATE
TO public
USING ((organization_id = current_org_id()))
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_insert_user_roles"
ON public.user_roles
FOR INSERT
TO public
WITH CHECK ((organization_id = current_org_id()))
;

CREATE POLICY "org_strict_select_user_roles"
ON public.user_roles
FOR SELECT
TO public
USING ((organization_id = current_org_id()))
;


