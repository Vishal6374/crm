**Executive Summary**
- Current project partially aligns with updates.md on multi-tenant isolation, PBAC, projects, and chat. Significant gaps remain around roles (Super Admin, Tenant Admin uniqueness, HR/Finance/Viewer), module toggles, HR workflows, approvals, activity log retention, and email.
- Immediate next steps: push migrations, tighten frontend gating, add missing roles and constraints, and wire module enable/disable. Follow with HR/payroll/leave workflows and activity log retention.

**Scope Compared**
- Source of truth: updates.md [updates.md](file:///c:/Users/Hi/crm/updates.md)
- Current implementation surveyed across migrations, policies, and frontend:
  - Migrations: [migrations](file:///c:/Users/Hi/crm/supabase/migrations)
  - Role capabilities: [20251230011000_role_capabilities_permissions.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230011000_role_capabilities_permissions.sql)
  - Multi-tenancy helpers and org policies: [20251230010010_add_organizations_multi_tenancy.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230010010_add_organizations_multi_tenancy.sql)
  - Projects and notifications extension: [20251230012000_add_projects_notifications_extension.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230012000_add_projects_notifications_extension.sql)
  - Project members and chat linkage: [20251230014000_add_project_members_and_chat_project.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230014000_add_project_members_and_chat_project.sql)
  - Visibility and permissions updates: [20251231120000_permissions_visibility_updates.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231120000_permissions_visibility_updates.sql)
  - Department auto chat: [20251231130000_department_auto_chat.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231130000_department_auto_chat.sql)
  - Project meetings schema fix: [20251231131000_project_meetings_schema_fix.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231131000_project_meetings_schema_fix.sql)
  - Frontend key pages: [ProjectsPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectsPage.tsx), [ProjectDetailPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectDetailPage.tsx), [MeetingsPage.tsx](file:///c:/Users/Hi/crm/src/pages/MeetingsPage.tsx)

**Key Differences**
- Multi-Tenant Model
  - updates.md: tenant_id everywhere, Super Admin at platform level, Tenant Admin uniqueness per tenant, module toggle via tenant_modules.
  - current: organization_id implemented and enforced via RLS; helper current_org_id exists. Super Admin concept not present. Tenant Admin role and uniqueness constraint absent. tenant_modules table is missing; module enable/disable not wired.
- Roles & Access
  - updates.md: Super Admin, Tenant Admin, Managers (Sales/Project/HR/Finance), HR, Finance Manager, Employee, Viewer.
  - current: app_role enum limited to admin, manager, employee. No HR/Finance/Viewer roles. No Super Admin. Role_capabilities exist but seeded for admin/manager/employee only; calendar create for manager recently enabled per PBAC.
- Dashboard Module
  - updates.md: gated by role (Tenant Admin full, Manager/HR limited, Employee none, Viewer read-only).
  - current: dashboard gated by role; employees denied; viewer read-only; sections and actions conditioned on capabilities.
- Leads & Deals Visibility
  - updates.md: Manager sees their own leads; employee sees assigned; deals manager sees all.
  - current: UI filters leads by role (manager sees own, employee sees assigned); deals page gates create/edit/delete, employees see assigned; DB policies remain org-scoped for now.
- Projects
  - updates.md: only Tenant Admin & Managers can create; visible only to creator or members; auto project chat; project tasks isolated; project meetings only Project Manager.
  - current: creator/member-only visibility enforced at DB; project creation policy recently tightened to admin/manager; auto chat implemented for owner and member-join on add (does not auto-add all existing members at creation); project_tasks exist and are isolated; project_meetings require start/end and link per schema fix; frontend gates project meetings to manager role.
- Chat
  - updates.md: department auto chat; DM separate; role badges.
  - current: chat tables exist; department auto chat added; project chat auto-create and auto-join on member add exist; role badges implemented in chat messages; DM supported via enum.
- Meetings (Org-Level)
  - updates.md: org-wide meetings by Tenant Admin & Managers only; project meetings separate.
  - current: MeetingsPage uses events table for org meetings; PBAC updated so managers can create; project meetings are separate via project_meetings table.
- HR/Attendance/Payroll/Leave
  - updates.md: HR full access; employee self-attendance; payroll draft/approval workflow by Tenant Admin; HR approves leave.
  - current: attendance and payroll exist; approvals not implemented; RLS grants admin manage, authenticated broader view; HR role missing; leave approvals tied to manager capability instead of HR.
- Activity Logs
  - updates.md: keep latest 500 logs, auto-delete old, visible to Tenant Admin/HR/Managers.
  - current: logs table exists; no retention enforcement; visibility broader via policies.
- Notifications & Email
  - updates.md: notifications on assignment, creation, chat messages; email templates/variables/bulk send.
  - current: notifications for tasks/deals and chat messages exist; email system not implemented.
- Module Enable/Disable
  - updates.md: tenant_modules controls modules per tenant.
  - current: no tenant_modules; UI and policies not conditioned on module enablement.

**What To Do Next**
- Push and verify database migrations in Supabase CLI.
  - Command: npx supabase db push
  - Migrations include project visibility, project meetings schema, department auto chat.
- Completed: Migrations pushed, including roles/modules constraints and seeding.
- Completed: Fixed projects RLS recursion; simplified project_members SELECT policy [20251231140000_fix_projects_rls_recursion.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251231140000_fix_projects_rls_recursion.sql)
- Tighten frontend gating to match policies and spec.
  - Projects: gate New Project button to admin/manager in [ProjectsPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectsPage.tsx).
  - Project meetings: gate schedule UI to project managers in [ProjectDetailPage.tsx](file:///c:/Users/Hi/crm/src/pages/ProjectDetailPage.tsx).
  - Employees: hide module for non-HR/Tenant Admin; adjust sidebar in [AppSidebar.tsx](file:///c:/Users/Hi/crm/src/components/layout/AppSidebar.tsx).
- Completed: Basic module toggles applied to sidebar via tenant_modules with [use-modules.ts](file:///c:/Users/Hi/crm/src/hooks/use-modules.ts). Projects page gated for creation via role capabilities.
- Add missing roles and capabilities.
  - Extend app_role enum and seed role_capabilities for HR, Finance, Viewer; adjust use-permissions and UI.
  - Create Super Admin model separate from tenant data.
- Completed: Roles extended (tenant_admin, hr, finance, viewer, super_admin) and capabilities seeded. profiles.super_admin added.
- Implement Tenant Admin uniqueness per tenant.
  - Add unique partial index on user_roles for role='TENANT_ADMIN' by organization_id.
- Completed: Trigger-based enforcement added to user_roles to ensure a single tenant_admin per organization.
- Introduce tenant_modules and wire module toggles.
  - Table creation, seed defaults, check in UI routing and sidebar.
- Completed: tenant_modules created and seeded; sidebar respects module enable/disable.
- Completed: Dashboard gated by role with employee denied and viewer read-only; charts, stats, and quick actions respect PBAC.

**Path To Full Alignment**
- Roles & Hierarchy
  - Add roles: SUPER_ADMIN, TENANT_ADMIN, HR, FINANCE, VIEWER; map to PBAC in [20251230011000_role_capabilities_permissions.sql](file:///c:/Users/Hi/crm/supabase/migrations/20251230011000_role_capabilities_permissions.sql).
  - Implement Super Admin access limited to platform metadata; create tenants and enable modules; disallow tenant CRM data reads.
  - Enforce exactly one Tenant Admin per organization with a unique constraint.
- Module Toggles
  - Create tenant_modules table; add checks in policies (WITH CHECK) and in UI to hide modules when disabled.
- HR Workflows
  - Attendance: restrict to self for non-HR; HR full access; policies update in org-aware migration.
  - Payroll: implement draft→approve by Tenant Admin; add approval triggers and notifications.
  - Leave Requests: HR approves; add RLS gating for HR and approval triggers.
- Projects
  - Auto chat: add trigger to auto-add all existing project members at creation into the project channel.
  - Meetings: ensure frontend requires meeting_link; enforce manager gating in UI to match DB.
- Activity Logs
  - Add retention job to keep last 500 per org; delete older; scope visibility to Tenant Admin/HR/Managers.
- Notifications
  - Extend to include project task creation/assignment and project meeting scheduling.
- Email Module
  - Implement templates, variables, bulk send; add PBAC; add UI forms and send endpoints.
- Dashboard
  - Implement role-based views and data filters; hide for Employee; read-only for Viewer.

**Verification Plan**
- Run migrations and check policies with test users across roles.
- Validate UI gating via usePermissions and DB-level RLS by attempting disallowed actions.
- Run eslint and smoke test pages: Projects, Project Detail, Employees, Attendance, Payroll, Meetings, Chat.
- Confirm auto chat behaviors for departments and projects with multiple members.
