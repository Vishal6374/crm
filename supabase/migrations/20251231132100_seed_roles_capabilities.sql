DO $$
DECLARE
  _org UUID;
BEGIN
  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;
  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
  SELECT _org, 'tenant_admin', m, true, true, true, true
  FROM unnest(ARRAY['dashboard','chat','leads','deals','tasks','calendar','payroll','attendance','reports','leave_requests','projects','employees','departments','designations','user_roles','activity_logs','settings']) AS m
  ON CONFLICT DO NOTHING;

  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
  VALUES 
    (_org, 'hr', 'employees', true, true, true, false),
    (_org, 'hr', 'attendance', true, true, true, false),
    (_org, 'hr', 'payroll', true, true, true, false),
    (_org, 'hr', 'leave_requests', true, false, true, true),
    (_org, 'hr', 'reports', true, false, false, false),
    (_org, 'finance', 'payroll', true, false, false, false),
    (_org, 'viewer', 'dashboard', true, false, false, false),
    (_org, 'viewer', 'reports', true, false, false, false)
  ON CONFLICT DO NOTHING;

  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
  VALUES 
    (_org, 'admin', 'projects', true, true, true, true),
    (_org, 'manager', 'projects', true, true, true, false)
  ON CONFLICT DO NOTHING;
END $$;

