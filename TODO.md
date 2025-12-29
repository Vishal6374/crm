# Fix Linting Errors in CRM Project

## Overview
Fix 61 errors and 18 warnings from ESLint and TypeScript:
- 61 errors: Mostly `@typescript-eslint/no-explicit-any` (any types)
- 18 warnings: Missing useEffect dependencies and other issues

## Steps

### 1. Define Additional Types (if needed)
- [ ] Review existing types in `src/integrations/supabase/types.ts`
- [ ] Add any missing types for chat functionality

### 2. Fix Chat Components (High Priority)
- [x] `src/components/chat/ChatSidebar.tsx` - 3 any types, 1 missing dependency
- [x] `src/components/chat/ChatWindow.tsx` - 5 any types, 2 missing dependencies

### 3. Fix Details Sheet Components
- [x] `src/components/companies/CompanyDetailsSheet.tsx` - 1 any type
- [x] `src/components/contacts/ContactDetailsSheet.tsx` - 1 any type
- [x] `src/components/deals/DealDetailsSheet.tsx` - 1 any type
- [ ] `src/components/employees/EmployeeDetailsSheet.tsx` - 1 any type

### 4. Fix Deals Components
- [ ] `src/components/deals/DealsKanban.tsx` - 6 any types
- [ ] `src/components/deals/DealsTable.tsx` - 4 any types

### 5. Fix Leads Components
- [ ] `src/components/leads/LeadDetailsSheet.tsx` - 2 any types, 1 missing dependency
- [ ] `src/components/leads/LeadForm.tsx` - 2 any types
- [ ] `src/components/leads/LeadsKanban.tsx` - 4 any types
- [ ] `src/components/leads/LeadsTable.tsx` - 5 any types

### 6. Fix Layout Components
- [ ] `src/components/layout/AppHeader.tsx` - 1 any type, 1 missing dependency

### 7. Fix Page Components
- [ ] `src/pages/CalendarPage.tsx` - 1 missing dependency
- [ ] `src/pages/ContactsPage.tsx` - 1 any type
- [ ] `src/pages/DealsPage.tsx` - 2 any types
- [ ] `src/pages/DepartmentsPage.tsx` - 1 any type
- [ ] `src/pages/DesignationsPage.tsx` - 2 any types
- [ ] `src/pages/EmployeesPage.tsx` - 4 any types, 1 missing dependency
- [ ] `src/pages/LeadsPage.tsx` - 6 any types
- [ ] `src/pages/ReportsPage.tsx` - 5 any types
- [ ] `src/pages/SettingsPage.tsx` - 1 missing dependency
- [ ] `src/pages/TasksPage.tsx` - 1 missing dependency
- [ ] `src/pages/UserRolesPage.tsx` - 2 any types

### 8. Fix UI Components
- [ ] `src/components/ui/command.tsx` - 1 empty interface
- [ ] `src/components/ui/textarea.tsx` - 1 empty interface

### 9. Verification
- [ ] Run `npm run lint` to verify all errors are fixed
- [ ] Test application functionality

## Notes
- Use types from `src/integrations/supabase/types.ts` where possible
- For useEffect dependencies, use useCallback for functions or add them to deps if stable
- Empty interfaces should be replaced with type aliases or proper interfaces
