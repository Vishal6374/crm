-- -- STRICT MULTI-TENANCY ENFORCEMENT
-- -- This migration enforces strict data isolation between organizations.
-- -- It ensures every business table has an organization_id and RLS policies that strictly filter by it.

-- DO $$
-- DECLARE
--   -- List of tables that must be strictly isolated by organization_id
--   _tables text[] := ARRAY[
--     'departments',
--     'designations',
--     'companies',
--     'contacts',
--     'leads',
--     'deals',
--     'employees',
--     'tasks',
--     'attendance',
--     'payroll',
--     'leave_requests',
--     'activity_logs',
--     'chat_channels',
--     'chat_participants',
--     'chat_messages',
--     'messages',
--     'projects',
--     'project_members',
--     'project_tasks',
--     'project_meetings',
--     'notifications',
--     'tenant_modules',
--     'email_templates',
--     'invitations',
--     'events',
--     'event_attendees',
--     'role_capabilities',
--     'user_roles',
--     'payments',
--     'settings',
--     'emails_outbox',
--     'task_collaborators',
--     'task_timings'
--   ];
--   _tbl text;
--   _default_org uuid;
-- BEGIN
--   -- Get a default org for backfilling if needed (to avoid constraint errors)
--   SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;

--   -- PRE-LOOP: SMART BACKFILL FOR DEPENDENT TABLES
--   -- We do this before the generic loop to ensure data consistency by inheriting organization_id from parents.
  
--   -- 1. task_collaborators (from tasks)
--   IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'task_collaborators') THEN
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'task_collaborators' AND column_name = 'organization_id') THEN
--       ALTER TABLE public.task_collaborators ADD COLUMN organization_id UUID;
--     END IF;
--     -- Smart backfill
--     UPDATE public.task_collaborators tc
--     SET organization_id = t.organization_id
--     FROM public.tasks t
--     WHERE tc.task_id = t.id AND tc.organization_id IS NULL;
--     -- Fallback
--     IF _default_org IS NOT NULL THEN
--       UPDATE public.task_collaborators SET organization_id = _default_org WHERE organization_id IS NULL;
--     END IF;
--   END IF;

--   -- 2. task_timings (from tasks)
--   IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'task_timings') THEN
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'task_timings' AND column_name = 'organization_id') THEN
--       ALTER TABLE public.task_timings ADD COLUMN organization_id UUID;
--     END IF;
--     -- Smart backfill
--     UPDATE public.task_timings tt
--     SET organization_id = t.organization_id
--     FROM public.tasks t
--     WHERE tt.task_id = t.id AND tt.organization_id IS NULL;
--     -- Fallback
--     IF _default_org IS NOT NULL THEN
--       UPDATE public.task_timings SET organization_id = _default_org WHERE organization_id IS NULL;
--     END IF;
--   END IF;

--   -- 3. payments (from deals)
--   IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'organization_id') THEN
--       ALTER TABLE public.payments ADD COLUMN organization_id UUID;
--     END IF;
--     -- Smart backfill
--     UPDATE public.payments p
--     SET organization_id = d.organization_id
--     FROM public.deals d
--     WHERE p.deal_id = d.id AND p.organization_id IS NULL;
--     -- Fallback
--     IF _default_org IS NOT NULL THEN
--       UPDATE public.payments SET organization_id = _default_org WHERE organization_id IS NULL;
--     END IF;
--   END IF;

--   -- 4. events (from tasks if type=task)
--   IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'events') THEN
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'organization_id') THEN
--       ALTER TABLE public.events ADD COLUMN organization_id UUID;
--     END IF;
--     -- Smart backfill from tasks
--     UPDATE public.events e
--     SET organization_id = t.organization_id
--     FROM public.tasks t
--     WHERE e.type = 'task' AND e.related_id = t.id AND e.organization_id IS NULL;
--     -- Fallback
--     IF _default_org IS NOT NULL THEN
--       UPDATE public.events SET organization_id = _default_org WHERE organization_id IS NULL;
--     END IF;
--   END IF;

--   -- 5. emails_outbox (from profiles/created_by)
--   IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'emails_outbox') THEN
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'emails_outbox' AND column_name = 'organization_id') THEN
--       ALTER TABLE public.emails_outbox ADD COLUMN organization_id UUID;
--     END IF;
--     -- Smart backfill
--     UPDATE public.emails_outbox e
--     SET organization_id = p.organization_id
--     FROM public.profiles p
--     WHERE e.created_by = p.id AND e.organization_id IS NULL;
--     -- Fallback
--     IF _default_org IS NOT NULL THEN
--       UPDATE public.emails_outbox SET organization_id = _default_org WHERE organization_id IS NULL;
--     END IF;
--   END IF;


--   -- GENERIC LOOP
--   FOREACH _tbl IN ARRAY _tables
--   LOOP
--     -- 1. Ensure organization_id column exists (if not handled above)
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = _tbl AND column_name = 'organization_id') THEN
--       EXECUTE format('ALTER TABLE public.%I ADD COLUMN organization_id UUID', _tbl);
      
--       -- Backfill if table has data (unsafe to leave null if we enforce not null later)
--       IF _default_org IS NOT NULL THEN
--          EXECUTE format('UPDATE public.%I SET organization_id = %L WHERE organization_id IS NULL', _tbl, _default_org);
--       END IF;
--     END IF;

--     -- 2. Ensure Foreign Key constraint exists
--     -- 2. Ensure Foreign Key constraint exists
-- IF NOT EXISTS (
--   SELECT 1 FROM information_schema.table_constraints tc
--   JOIN information_schema.constraint_column_usage ccu
--     ON tc.constraint_name = ccu.constraint_name
--   WHERE tc.table_name = _tbl
--     AND ccu.column_name = 'organization_id'
--     AND tc.constraint_type = 'FOREIGN KEY'
-- ) THEN
--   EXECUTE format(
--     'ALTER TABLE public.%I ADD CONSTRAINT %I_org_fkey
--      FOREIGN KEY (organization_id)
--      REFERENCES public.organizations(id)
--      ON DELETE CASCADE',
--     _tbl, _tbl
--   );
-- END IF;


--     -- 3. Enable RLS
--     EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', _tbl);

--     -- 4. Drop ALL existing policies to ensure clean slate
--     EXECUTE format('DROP POLICY IF EXISTS "org_select_%I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "org_insert_%I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "org_update_%I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "org_delete_%I" ON public.%I', _tbl, _tbl);
    
--     -- Also drop common lax policies if they exist
--     EXECUTE format('DROP POLICY IF EXISTS "Authenticated users can view %I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "Users can view their own %I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "Public view %I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "Authenticated users can view all %I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('DROP POLICY IF EXISTS "Users can view %I" ON public.%I', _tbl, _tbl);

--     -- 5. Create STRICT policies
--     -- SELECT: Visible only if record.organization_id matches user's current_org_id()
--     EXECUTE format('CREATE POLICY "org_strict_select_%I" ON public.%I FOR SELECT USING (organization_id = public.current_org_id())', _tbl, _tbl);
    
--     -- INSERT: Allowed only if new.organization_id matches user's current_org_id()
--     EXECUTE format('CREATE POLICY "org_strict_insert_%I" ON public.%I FOR INSERT WITH CHECK (organization_id = public.current_org_id())', _tbl, _tbl);
    
--     -- UPDATE: Allowed only if record matches AND new record matches
--     EXECUTE format('CREATE POLICY "org_strict_update_%I" ON public.%I FOR UPDATE USING (organization_id = public.current_org_id()) WITH CHECK (organization_id = public.current_org_id())', _tbl, _tbl);
    
--     -- DELETE: Allowed only if record matches
--     EXECUTE format('CREATE POLICY "org_strict_delete_%I" ON public.%I FOR DELETE USING (organization_id = public.current_org_id())', _tbl, _tbl);

--   END LOOP;
-- END $$;


-- -- SPECIAL HANDLING: SETTINGS (Fix Unique Constraint)
-- -- Settings was originally global (key unique). It must be per-org (organization_id, key unique).
-- DO $$
-- BEGIN
--   IF EXISTS (
--     SELECT 1 FROM information_schema.table_constraints 
--     WHERE table_name = 'settings' AND constraint_name = 'settings_key_key'
--   ) THEN
--     ALTER TABLE public.settings DROP CONSTRAINT settings_key_key;
--     ALTER TABLE public.settings ADD CONSTRAINT settings_org_key_key UNIQUE (organization_id, key);
--   END IF;
-- END $$;


-- -- SPECIAL HANDLING: PROFILES
-- -- Profiles table is shared (conceptually) but we want to restrict visibility.
-- -- You can only see a profile if:
-- -- 1. It is your own profile.
-- -- 2. The user is an employee in the SAME organization as you.
-- -- 3. You are a super admin.

-- ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- DROP POLICY IF EXISTS "Authenticated users can view all profiles" ON public.profiles;
-- DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
-- DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
-- DROP POLICY IF EXISTS "Org restricted profile view" ON public.profiles;

-- CREATE POLICY "Org restricted profile view" ON public.profiles
-- FOR SELECT USING (
--   id = auth.uid() 
--   OR 
--   EXISTS (
--     SELECT 1 FROM public.employees e 
--     WHERE e.user_id = profiles.id 
--     AND e.organization_id = public.current_org_id()
--   )
--   OR
--   public.is_super_admin()
-- );

-- -- Allow users to update their own profile
-- CREATE POLICY "Users can update own profile" ON public.profiles
-- FOR UPDATE USING (id = auth.uid());


-- -- SPECIAL HANDLING: ORGANIZATIONS
-- -- Users can only see their own organization.
-- DROP POLICY IF EXISTS "Users can view their own organization" ON public.organizations;
-- CREATE POLICY "Users can view their own organization" ON public.organizations
-- FOR SELECT USING (
--   id = public.current_org_id() 
--   OR public.is_super_admin()
-- );


-- -- RE-APPLY SUPER ADMIN ACCESS
-- DO $$
-- DECLARE
--   _tables text[] := ARRAY[
--     'departments', 'designations', 'companies', 'contacts', 'leads', 'deals', 
--     'employees', 'tasks', 'attendance', 'payroll', 'leave_requests', 'activity_logs', 
--     'chat_channels', 'chat_participants', 'chat_messages', 'messages', 
--     'projects', 'project_members', 'project_tasks', 'project_meetings', 'notifications', 
--     'tenant_modules', 'email_templates', 'invitations', 'events', 'event_attendees', 
--     'role_capabilities', 'user_roles', 'payments', 'settings',
--     'emails_outbox', 'task_collaborators', 'task_timings'
--   ];
--   _tbl text;
-- BEGIN
--   FOREACH _tbl IN ARRAY _tables
--   LOOP
--     EXECUTE format('DROP POLICY IF EXISTS "super_admin_all_%I" ON public.%I', _tbl, _tbl);
--     EXECUTE format('CREATE POLICY "super_admin_all_%I" ON public.%I FOR ALL USING (public.is_super_admin())', _tbl, _tbl);
--   END LOOP;
-- END $$;



-- ============================================================
-- STRICT MULTI-TENANCY ENFORCEMENT (PRODUCTION SAFE)
-- ============================================================

DO $$
DECLARE
  _tables text[] := ARRAY[
    'departments','designations','companies','contacts','leads','deals',
    'employees','tasks','attendance','payroll','leave_requests','activity_logs',
    'chat_channels','chat_participants','chat_messages','messages',
    'projects','project_members','project_tasks','project_meetings','notifications',
    'tenant_modules','email_templates','invitations','events','event_attendees',
    'role_capabilities','user_roles','payments','settings',
    'emails_outbox','task_collaborators','task_timings'
  ];
  _tbl text;
  _default_org uuid;
BEGIN
  SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;

  -- ============================================================
  -- SMART BACKFILL (DEPENDENT TABLES)
  -- ============================================================

  -- task_collaborators → tasks
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='task_collaborators') THEN
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_name='task_collaborators' AND column_name='organization_id'
    ) THEN
      ALTER TABLE public.task_collaborators ADD COLUMN organization_id uuid;
    END IF;

    UPDATE public.task_collaborators tc
    SET organization_id = t.organization_id
    FROM public.tasks t
    WHERE tc.task_id=t.id AND tc.organization_id IS NULL;

    IF _default_org IS NOT NULL THEN
      UPDATE public.task_collaborators SET organization_id=_default_org WHERE organization_id IS NULL;
    END IF;
  END IF;

  -- task_timings → tasks
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='task_timings') THEN
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_name='task_timings' AND column_name='organization_id'
    ) THEN
      ALTER TABLE public.task_timings ADD COLUMN organization_id uuid;
    END IF;

    UPDATE public.task_timings tt
    SET organization_id=t.organization_id
    FROM public.tasks t
    WHERE tt.task_id=t.id AND tt.organization_id IS NULL;

    IF _default_org IS NOT NULL THEN
      UPDATE public.task_timings SET organization_id=_default_org WHERE organization_id IS NULL;
    END IF;
  END IF;

  -- payments → deals
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='payments') THEN
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_name='payments' AND column_name='organization_id'
    ) THEN
      ALTER TABLE public.payments ADD COLUMN organization_id uuid;
    END IF;

    UPDATE public.payments p
    SET organization_id=d.organization_id
    FROM public.deals d
    WHERE p.deal_id=d.id AND p.organization_id IS NULL;

    IF _default_org IS NOT NULL THEN
      UPDATE public.payments SET organization_id=_default_org WHERE organization_id IS NULL;
    END IF;
  END IF;

  -- ============================================================
  -- GENERIC LOOP
  -- ============================================================

  FOREACH _tbl IN ARRAY _tables LOOP

    -- ensure organization_id
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_schema='public' AND table_name=_tbl AND column_name='organization_id'
    ) THEN
      EXECUTE format('ALTER TABLE public.%I ADD COLUMN organization_id uuid', _tbl);
      IF _default_org IS NOT NULL THEN
        EXECUTE format(
          'UPDATE public.%I SET organization_id=%L WHERE organization_id IS NULL',
          _tbl,_default_org
        );
      END IF;
    END IF;

    -- FK by NAME (FIXES YOUR ERROR)
    IF NOT EXISTS (
      SELECT 1 FROM pg_constraint
      WHERE conname = format('%s_org_fkey',_tbl)
    ) THEN
      EXECUTE format(
        'ALTER TABLE public.%I
         ADD CONSTRAINT %I_org_fkey
         FOREIGN KEY (organization_id)
         REFERENCES public.organizations(id)
         ON DELETE CASCADE',
        _tbl,_tbl
      );
    END IF;

    -- enable RLS
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY',_tbl);

    -- drop old policies
    EXECUTE format('DROP POLICY IF EXISTS org_select_%I ON public.%I',_tbl,_tbl);
    EXECUTE format('DROP POLICY IF EXISTS org_insert_%I ON public.%I',_tbl,_tbl);
    EXECUTE format('DROP POLICY IF EXISTS org_update_%I ON public.%I',_tbl,_tbl);
    EXECUTE format('DROP POLICY IF EXISTS org_delete_%I ON public.%I',_tbl,_tbl);

    -- strict tenant policies
    EXECUTE format(
      'CREATE POLICY org_strict_select_%I ON public.%I
       FOR SELECT USING (organization_id = public.current_org_id())',
      _tbl,_tbl
    );

    EXECUTE format(
      'CREATE POLICY org_strict_insert_%I ON public.%I
       FOR INSERT WITH CHECK (organization_id = public.current_org_id())',
      _tbl,_tbl
    );

    EXECUTE format(
      'CREATE POLICY org_strict_update_%I ON public.%I
       FOR UPDATE USING (organization_id = public.current_org_id())
       WITH CHECK (organization_id = public.current_org_id())',
      _tbl,_tbl
    );

    EXECUTE format(
      'CREATE POLICY org_strict_delete_%I ON public.%I
       FOR DELETE USING (organization_id = public.current_org_id())',
      _tbl,_tbl
    );

  END LOOP;
END $$;

-- ============================================================
-- SETTINGS UNIQUE FIX
-- ============================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name='settings' AND constraint_name='settings_key_key'
  ) THEN
    ALTER TABLE public.settings DROP CONSTRAINT settings_key_key;
    ALTER TABLE public.settings ADD CONSTRAINT settings_org_key_key UNIQUE (organization_id,key);
  END IF;
END $$;

-- ============================================================
-- PROFILES RLS
-- ============================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS profile_read ON public.profiles;
CREATE POLICY profile_read ON public.profiles
FOR SELECT USING (
  id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM public.employees e
    WHERE e.user_id=profiles.id
    AND e.organization_id=public.current_org_id()
  )
  OR public.is_super_admin()
);

DROP POLICY IF EXISTS profile_update_self ON public.profiles;
CREATE POLICY profile_update_self ON public.profiles
FOR UPDATE USING (id=auth.uid());

-- ============================================================
-- ORGANIZATIONS VISIBILITY
-- ============================================================
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS org_view_self ON public.organizations;
CREATE POLICY org_view_self ON public.organizations
FOR SELECT USING (
  id = public.current_org_id()
  OR public.is_super_admin()
);

-- ============================================================
-- SUPER ADMIN OVERRIDE
-- ============================================================
DO $$
DECLARE _tbl text;
BEGIN
  FOREACH _tbl IN ARRAY ARRAY[
    'departments','designations','companies','contacts','leads','deals',
    'employees','tasks','attendance','payroll','leave_requests','activity_logs',
    'chat_channels','chat_participants','chat_messages','messages',
    'projects','project_members','project_tasks','project_meetings','notifications',
    'tenant_modules','email_templates','invitations','events','event_attendees',
    'role_capabilities','user_roles','payments','settings',
    'emails_outbox','task_collaborators','task_timings'
  ]
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS super_admin_all_%I ON public.%I',_tbl,_tbl);
    EXECUTE format(
      'CREATE POLICY super_admin_all_%I ON public.%I
       FOR ALL USING (public.is_super_admin())',
      _tbl,_tbl
    );
  END LOOP;
END $$;
