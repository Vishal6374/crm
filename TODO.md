# User Creation Flow Restructure

## Phase 1: Remove Existing User Creation Methods
- [ ] Remove signup tab from AuthPage.tsx
- [ ] Remove AcceptInvitePage.tsx entirely
- [ ] Remove invitation routes from routing
- [ ] Update handle_new_user function to not auto-assign organizations/roles

## Phase 2: Add Super Admin User Creation
- [ ] Add user creation form to SuperAdminPage.tsx for tenant_admins
- [ ] Implement Supabase admin auth user creation
- [ ] Generate and display credentials for created users

## Phase 3: Add Tenant Admin User Creation
- [ ] Add user creation form to UserRolesPage.tsx
- [ ] Allow tenant admins to create users within their organization
- [ ] Generate and display credentials for created users

## Phase 4: Database Updates
- [ ] Create migration to remove invitation system
- [ ] Update handle_new_user function
- [ ] Remove invitation-related tables and functions

## Phase 5: Testing
- [ ] Test super admin user creation
- [ ] Test tenant admin user creation
- [ ] Verify login works with created credentials
