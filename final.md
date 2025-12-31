**Final Alignment Report**
- Full comparison of current implementation vs desired specification in updates.md, with clear gaps and action plan.

**Sources**
- Specification: [updates.md](file:///c:/Users/Hi/crm/updates.md)
- Database migrations: [migrations](file:///c:/Users/Hi/crm/supabase/migrations)
- Key frontend pages: [ProjectsPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectsPage.tsx), [ProjectDetailPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectDetailPage.tsx), [ChatSidebar.tsx](file:///c:/Users/Hi/crm/src/components/chat/ChatSidebar.tsx), [TasksPage.tsx](file:///c:/Users/Hi/crm/src/pages/TasksPage.tsx)

**Architecture & Tenancy**
- Desired
  - Multi-tenant SaaS with strict isolation; tenant-level module toggles; Super Admin manages tenants; Tenant Admin unique per tenant.
- Current
  - Organization-based tenancy implemented via organization_id and RLS helper [current_org_id](file:///c:/Users/Hi/crm/supabase/migrations/20251230010010_add_organizations_multi_tenancy.sql#L169-L178).
  - Tenant modules table and seeding present [roles_modules_constraints.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231132000_roles_modules_constraints.sql#L19-L45).
  - Super Admin flag added to profiles; app_role extended (tenant_admin, hr, finance, viewer, super_admin) [roles_modules_constraints.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231132000_roles_modules_constraints.sql#L17).
- Gap
  - Platform-level tenants table not separate from organizations; Super Admin scope limited to metadata not fully enforced in policies.
- Actions
  - Consider aligning naming (tenant vs organization) and add platform metadata tables; tighten RLS for Super Admin visibility.

**Roles & PBAC**
- Desired
  - Full hierarchy: Super Admin, Tenant Admin (only one), Managers (Sales/Project/HR/Finance), HR, Finance Manager, Employee, Viewer; PBAC per module.
- Current
  - Roles extended in enum; seeded role_capabilities per module [seed_roles_capabilities.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231132100_seed_roles_capabilities.sql#L6-L27).
  - Unique Tenant Admin enforced via trigger [roles_modules_constraints.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231132000_roles_modules_constraints.sql#L46-L69).
- Gap
  - Some UI gating paths still static; PBAC not uniformly applied across all modules.
- Actions
  - Expand usePermissions integration and guard routes/components based on role_capabilities.

**Dashboard**
- Desired
  - Tenant Admin full; Manager/HR limited; Employee none; Viewer read-only.
- Current
  - Role-gated dashboard implemented; viewer read-only behavior present.
- Gap
  - Ensure PBAC drives widgets and actions consistently.
- Actions
  - Audit dashboard components to use role_capabilities for all controls.

**Leads**
- Desired
  - Manager creates; assignment flow manager→employee; visibility: manager’s own, employee assigned.
- Current
  - UI filters by role; org-scoped DB policies still broad [87339f...sql](file:///c:/Users/Hi/crm/supabase/migrations/20251228155720_87339f32-428a-4852-bfdb-08508b060e36.sql#L332-L349).
- Gap
  - DB visibility should reflect assignment rules, not just org.
- Actions
  - Add RLS using assigned_to and created_by to match spec.

**Deals**
- Desired
  - Anyone can create; manager sees all; employee sees assigned; activity log mandatory.
- Current
  - UI gating for assigned; org-scoped policies [87339f...sql](file:///c:/Users/Hi/crm/supabase/migrations/20251228155720_87339f32-428a-4852-bfdb-08508b060e36.sql#L318-L331).
- Gap
  - Enforce manager visibility and activity log requirements at DB/UI.
- Actions
  - RLS: managers broader select; enhance deal view with activity log.

**Contacts & Companies**
- Desired
  - Auto-create on lead qualification; conversion flow to deal.
- Current
  - Tables present; conversion automation not fully implemented.
- Gap
  - Missing triggers/process for qualification conversion.
- Actions
  - Implement conversion triggers and notifications.

**Calendar (Org Level)**
- Desired
  - Tenant Admin all; Manager all employees; Employee own only; no reschedule by employee.
- Current
  - PBAC updated to allow manager creation [permissions_visibility_updates.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231120000_permissions_visibility_updates.sql#L183-L187).
- Gap
  - Enforce reschedule restriction at UI and DB policy.
- Actions
  - Add update policy constraints; UI guard reschedule actions.

**Projects**
- Desired
  - Only Tenant Admin & Managers create; visibility only creator or assigned member; auto project chat; project tasks isolated; project meetings by Project Manager only.
- Current
  - Projects table and org policies [add_projects_notifications_extension.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230012000_add_projects_notifications_extension.sql#L62-L69).
  - Visibility policy: creator or member-only [permissions_visibility_updates.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231120000_permissions_visibility_updates.sql#L58-L71).
  - Frontend fixes: auto-add self as member in [ProjectsPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectsPage.tsx), group chat enforced and project chats hidden from main list in [ChatSidebar.tsx](file:///c:/Users/Hi/crm/src/components/chat/ChatSidebar.tsx).
- Gap
  - Auto-add all existing members at project creation into chat channel.
- Actions
  - Ensure trigger covers initial members; confirm creation gating in DB to admin/manager.

**Project Chat**
- Desired
  - Auto channel on project creation; auto-join all members; DM separate; role badges.
- Current
  - Auto channel and joins via triggers [update_to_spec.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231000000_update_to_spec.sql#L159-L215).
  - Role badges implemented in chat UI; project chats filtered from main chat [ChatSidebar.tsx](file:///c:/Users/Hi/crm/src/components/chat/ChatSidebar.tsx).
- Gap
  - Ensure add-all-members at project creation covers pre-existing entries.
- Actions
  - Confirm and, if needed, extend trigger to bulk-add members on insert.

**Project Tasks (Isolated)**
- Desired
  - Separate from global tasks, same UI/flow, isolated data.
- Current
  - project_tasks table and org-aware policies [update_to_spec.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231000000_update_to_spec.sql#L45-L101).
  - Member/owner-based visibility and modify policies [permissions_visibility_updates.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231120000_permissions_visibility_updates.sql#L131-L180).
- Gap
  - Verify UI separation across pages and navigation.
- Actions
  - Audit Tasks UI to keep project tasks in project submodule only.

**Project Meetings**
- Desired
  - Only Project Manager can create; time + link mandatory.
- Current
  - project_meetings table with org-aware policies [update_to_spec.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231000000_update_to_spec.sql#L103-L157).
  - Policies for members/owner select and manager insert [permissions_visibility_updates.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231120000_permissions_visibility_updates.sql#L76-L129).
- Gap
  - Enforce mandatory link at creation in UI and constraints.
- Actions
  - Add NOT NULL/validation for meeting_link; UI checks.

**Tasks (Global)**
- Desired
  - Same flow as current; detail, sidebar, activity log.
- Current
  - Global tasks with optional lead/deal links [add_task_links.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251229120000_add_task_links.sql).
- Gap
  - Ensure activity log presence and consistent PBAC.
- Actions
  - Add logs on task changes; verify policies.

**Chat (Org Level)**
- Desired
  - Department auto chat; group chat; DM; org-wide DMs.
- Current
  - Department auto chat present [department_auto_chat.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231130000_department_auto_chat.sql).
  - Chat RLS hardened to avoid recursion [fix_chat_rls.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230000002_fix_chat_rls.sql).
- Gap
  - Confirm org-wide DMs policy and UI support.
- Actions
  - Validate and extend chat_type usage; UI toggles.

**Meetings (Org Level)**
- Desired
  - Tenant Admin & Managers only; multiple types; separate from project meetings.
- Current
  - Org meetings in events (UI); PBAC updated for managers.
- Gap
  - DB-level enforcement for org meetings creation by roles.
- Actions
  - Add policies to events table aligned with role_capabilities.

**Employees**
- Desired
  - HR & Tenant Admin only.
- Current
  - RLS permits authenticated view [fix_issues_and_features.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230000006_fix_issues_and_features.sql#L12-L20).
- Gap
  - Restrict non-HR/Tenant Admin reads.
- Actions
  - Tighten employees SELECT policies to HR/Admin only.

**Attendance**
- Desired
  - HR full; others self-only.
- Current
  - Policies allow self-view and admin manage [87339f...sql](file:///c:/Users/Hi/crm/supabase/migrations/20251228155720_87339f32-428a-4852-bfdb-08508b060e36.sql#L352-L361).
- Gap
  - Explicit HR gating missing.
- Actions
  - Add HR role checks in RLS using role_capabilities.

**Payroll**
- Desired
  - HR creates drafts; Tenant Admin approves; clone previous month.
- Current
  - Payroll table exists; broad admin manage policy [87339f...sql](file:///c:/Users/Hi/crm/supabase/migrations/20251228155720_87339f32-428a-4852-bfdb-08508b060e36.sql#L364-L372).
- Gap
  - Draft/approve workflow and cloning missing.
- Actions
  - Add status, approval triggers, and cloning function.

**Leave Requests**
- Desired
  - Employee/Manager request; HR approves; HR leave → Tenant Admin approval.
- Current
  - Self-view and employee create; manager/HR logic partial [87339f...sql](file:///c:/Users/Hi/crm/supabase/migrations/20251228155720_87339f32-428a-4852-bfdb-08508b060e36.sql#L374-L393).
- Gap
  - HR-centric approval flow incomplete.
- Actions
  - Implement HR approval policies and notifications.

**Reports**
- Desired
  - Tenant Admin only; read-only.
- Current
  - Role_capabilities seeded for viewer/report access [seed_roles_capabilities.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231132100_seed_roles_capabilities.sql#L19-L21).
- Gap
  - Enforce Tenant Admin-only for sensitive reports.
- Actions
  - Tighten reports policies and UI gating.

**Departments & Designations**
- Desired
  - HR & Tenant Admin only.
- Current
  - Org-scoped visibility for all authenticated users [87339f...sql](file:///c:/Users/Hi/crm/supabase/migrations/20251228155720_87339f32-428a-4852-bfdb-08508b060e36.sql#L310-L317).
- Gap
  - Restrict reads to HR/Admin.
- Actions
  - Update RLS to role-based visibility.

**User Roles**
- Desired
  - Tenant Admin only.
- Current
  - Unique Tenant Admin enforced; broad admin manage policy.
- Gap
  - Further restrict management to Tenant Admin.
- Actions
  - Policies to check role_capabilities for user_roles mutations.

**Activity Logs**
- Desired
  - Keep latest 500; auto-delete old; visible to Tenant Admin/HR/Managers.
- Current
  - Activity logs table; visibility broader; no retention.
- Gap
  - Retention job and visibility restrictions missing.
- Actions
  - Add retention function and policies scoped to roles; scheduled job.

**Notifications**
- Desired
  - Triggers for assignment, task creation, deal creation, chat messages; only relevant users notified.
- Current
  - Notifications table linked to projects; some triggers present [notifications_triggers.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231001000_notifications_triggers.sql).
- Gap
  - Coverage incomplete for all specified events; PBAC alignment missing.
- Actions
  - Implement missing triggers and filter delivery by relevance.

**Email**
- Desired
  - Templates, variables, bulk send; subject/body configurable.
- Current
  - Not implemented.
- Gap
  - Entire module missing.
- Actions
  - Design tables, API endpoints, PBAC, and UI forms; add send functions.

**RLS & Recursion Fixes**
- Completed
  - Projects visibility policy implemented “creator or member within org” [permissions_visibility_updates.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231120000_permissions_visibility_updates.sql#L58-L71).
  - Fixed RLS recursion by simplifying project_members SELECT policy [20251231140000_fix_projects_rls_recursion.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231140000_fix_projects_rls_recursion.sql).
  - Chat RLS hardened via security definer functions [fix_chat_rls.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230000002_fix_chat_rls.sql).

**Action Plan**
- Short Term
  - Align RLS for Leads/Deals to assignment-based visibility.
  - Tighten Employees/Departments/Designations visibility to HR/Tenant Admin.
  - Enforce org meetings creation/update per role_capabilities.
  - Ensure project chat auto-add covers all members on creation.
- Medium Term
  - Implement HR workflows (Payroll approvals, Leave approvals).
  - Add activity log retention and scoped visibility.
  - Expand notifications coverage across modules.
  - Build Email module end-to-end.
- Long Term
  - Consider tenant vs organization convergence; platform-level metadata; Super Admin policy tightening.
