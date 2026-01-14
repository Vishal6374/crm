-- Enhance email module: specific users, manual emails, and ensure permissions
-- 1) Drop old function to replace with new signature
-- 2) New enqueue_bulk_email with user_ids and manual_emails support
-- 3) Ensure permissions are correctly seeded

BEGIN;

-- 1) Drop old function (signature match)
DROP FUNCTION IF EXISTS public.enqueue_bulk_email(UUID, public.app_role);

-- 2) New enqueue_bulk_email
CREATE OR REPLACE FUNCTION public.enqueue_bulk_email(
  _template_id UUID, 
  _target_role public.app_role DEFAULT NULL,
  _specific_user_ids UUID[] DEFAULT NULL,
  _manual_emails TEXT[] DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _batch_id UUID;
  _org UUID;
  _uid UUID := auth.uid();
  rec RECORD;
  _sub TEXT;
  _body TEXT;
  _manual_email TEXT;
BEGIN
  _org := public.current_org_id();
  
  -- Permission check
  IF NOT public.can_capability(_uid, 'email', 'can_create') THEN
    RAISE EXCEPTION 'not authorized: missing email.can_create capability';
  END IF;

  INSERT INTO public.email_batches (organization_id, template_id, target_role, created_by)
  VALUES (_org, _template_id, _target_role, _uid)
  RETURNING id INTO _batch_id;

  -- A) Target Role (if provided)
  IF _target_role IS NOT NULL THEN
    FOR rec IN
      SELECT p.id AS user_id, p.email
      FROM public.profiles p
      JOIN public.user_roles ur ON ur.user_id = p.id AND ur.organization_id = _org
      WHERE ur.role = _target_role
    LOOP
      SELECT subject, body INTO _sub, _body FROM public.resolve_email_template(_template_id, rec.user_id);
      INSERT INTO public.email_batch_recipients (batch_id, user_id, email, subject, body)
      VALUES (_batch_id, rec.user_id, rec.email, _sub, _body)
      ON CONFLICT (batch_id, user_id) DO NOTHING;
    END LOOP;
  END IF;

  -- B) Specific Users (if provided)
  IF _specific_user_ids IS NOT NULL THEN
    FOR rec IN
      SELECT p.id AS user_id, p.email
      FROM public.profiles p
      WHERE p.id = ANY(_specific_user_ids)
        AND p.organization_id = _org
    LOOP
      -- Avoid duplicates if caught by role
      SELECT subject, body INTO _sub, _body FROM public.resolve_email_template(_template_id, rec.user_id);
      INSERT INTO public.email_batch_recipients (batch_id, user_id, email, subject, body)
      VALUES (_batch_id, rec.user_id, rec.email, _sub, _body)
      ON CONFLICT (batch_id, user_id) DO NOTHING;
    END LOOP;
  END IF;

  -- C) Manual Emails (if provided)
  IF _manual_emails IS NOT NULL THEN
    FOREACH _manual_email IN ARRAY _manual_emails
    LOOP
      -- For manual emails, we can't resolve {{name}} or {{role}} easily from DB, 
      -- so we might resolve with empty values or use the email as name.
      SELECT subject, body INTO _sub, _body FROM public.email_templates WHERE id = _template_id;
      _sub := replace(_sub, '{{name}}', 'Guest');
      _sub := replace(_sub, '{{role}}', '');
      _body := replace(_body, '{{name}}', 'Guest');
      _body := replace(_body, '{{role}}', '');

      -- We use a NULL user_id for manual recipients? 
      -- The table definition says: user_id UUID NOT NULL REFERENCES auth.users(id).
      -- Problem: manual emails might not be users.
      -- FIX: Modify email_batch_recipients to allow null user_id? 
      -- Or just skip for now? The user asked for "manual typing and adding of any mail id".
      -- We must support non-user emails.
      
      -- Let's ALTER the table inside this migration to allow NULL user_id.
    END LOOP;
  END IF;

  -- Log events
  INSERT INTO public.email_events (batch_id, user_id, event, message)
  SELECT _batch_id, user_id, 'queued', 'queued for send'
  FROM public.email_batch_recipients
  WHERE batch_id = _batch_id;

  RETURN _batch_id;
END;
$$;

-- 3) Support non-user recipients
-- Need to drop primary key if it includes user_id
ALTER TABLE public.email_batch_recipients DROP CONSTRAINT IF EXISTS email_batch_recipients_pkey;
ALTER TABLE public.email_batch_recipients ALTER COLUMN user_id DROP NOT NULL;
-- Add a new ID or use (batch_id, email) as PK
ALTER TABLE public.email_batch_recipients ADD COLUMN IF NOT EXISTS id UUID PRIMARY KEY DEFAULT gen_random_uuid();
-- Add unique constraint on batch_id + email
CREATE UNIQUE INDEX IF NOT EXISTS idx_batch_email ON public.email_batch_recipients(batch_id, email);


-- 4) Update the function again to handle the manual insertion now that schema supports it
CREATE OR REPLACE FUNCTION public.enqueue_bulk_email(
  _template_id UUID, 
  _target_role public.app_role DEFAULT NULL,
  _specific_user_ids UUID[] DEFAULT NULL,
  _manual_emails TEXT[] DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _batch_id UUID;
  _org UUID;
  _uid UUID := auth.uid();
  rec RECORD;
  _sub TEXT;
  _body TEXT;
  _manual_email TEXT;
  _tmpl_sub TEXT;
  _tmpl_body TEXT;
BEGIN
  _org := public.current_org_id();
  
  -- Permission check
  IF NOT public.can_capability(_uid, 'email', 'can_create') THEN
    RAISE EXCEPTION 'not authorized: missing email.can_create capability';
  END IF;

  INSERT INTO public.email_batches (organization_id, template_id, target_role, created_by)
  VALUES (_org, _template_id, _target_role, _uid)
  RETURNING id INTO _batch_id;

  -- Cache template
  SELECT subject, body INTO _tmpl_sub, _tmpl_body FROM public.email_templates WHERE id = _template_id;

  -- A) Target Role (if provided)
  IF _target_role IS NOT NULL THEN
    FOR rec IN
      SELECT p.id AS user_id, p.email
      FROM public.profiles p
      JOIN public.user_roles ur ON ur.user_id = p.id AND ur.organization_id = _org
      WHERE ur.role = _target_role
    LOOP
      SELECT subject, body INTO _sub, _body FROM public.resolve_email_template(_template_id, rec.user_id);
      INSERT INTO public.email_batch_recipients (batch_id, user_id, email, subject, body)
      VALUES (_batch_id, rec.user_id, rec.email, _sub, _body)
      ON CONFLICT (batch_id, email) DO NOTHING;
    END LOOP;
  END IF;

  -- B) Specific Users (if provided)
  IF _specific_user_ids IS NOT NULL THEN
    FOR rec IN
      SELECT p.id AS user_id, p.email
      FROM public.profiles p
      WHERE p.id = ANY(_specific_user_ids)
        AND p.organization_id = _org
    LOOP
      SELECT subject, body INTO _sub, _body FROM public.resolve_email_template(_template_id, rec.user_id);
      INSERT INTO public.email_batch_recipients (batch_id, user_id, email, subject, body)
      VALUES (_batch_id, rec.user_id, rec.email, _sub, _body)
      ON CONFLICT (batch_id, email) DO NOTHING;
    END LOOP;
  END IF;

  -- C) Manual Emails (if provided)
  IF _manual_emails IS NOT NULL THEN
    FOREACH _manual_email IN ARRAY _manual_emails
    LOOP
      _sub := replace(_tmpl_sub, '{{name}}', 'Guest');
      _sub := replace(_sub, '{{role}}', '');
      _body := replace(_tmpl_body, '{{name}}', 'Guest');
      _body := replace(_body, '{{role}}', '');

      INSERT INTO public.email_batch_recipients (batch_id, user_id, email, subject, body)
      VALUES (_batch_id, NULL, _manual_email, _sub, _body)
      ON CONFLICT (batch_id, email) DO NOTHING;
    END LOOP;
  END IF;

  -- Log events
  INSERT INTO public.email_events (batch_id, user_id, event, message)
  SELECT _batch_id, user_id, 'queued', 'queued for send'
  FROM public.email_batch_recipients
  WHERE batch_id = _batch_id;

  RETURN _batch_id;
END;
$$;

-- 5) Re-seed permissions (Fix for 'Not Authorized')
DO $$
DECLARE
  _org UUID;
BEGIN
  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;
  IF _org IS NOT NULL THEN
      -- Ensure module is enabled
      BEGIN
        INSERT INTO public.tenant_modules(organization_id, module_name, enabled)
        VALUES (_org, 'email', true)
        ON CONFLICT DO NOTHING;
      EXCEPTION WHEN OTHERS THEN
        INSERT INTO public.tenant_modules(organization_id, module, enabled)
        VALUES (_org, 'email', true)
        ON CONFLICT DO NOTHING;
      END;

      -- Grant permissions to Admin and Tenant Admin
      INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)
      VALUES 
        (_org, 'tenant_admin', 'email', true, true, true, true),
        (_org, 'admin', 'email', true, true, true, true)
      ON CONFLICT (organization_id, role, module) 
      DO UPDATE SET can_view=true, can_create=true;
  END IF;
END $$;

COMMIT;
