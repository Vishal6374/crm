CREATE OR REPLACE FUNCTION public.enqueue_bulk_email(
  _template_id UUID,
  _target_role app_role DEFAULT NULL,
  _specific_user_ids UUID[] DEFAULT NULL,
  _manual_emails TEXT[] DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
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
  -- Resolve organization
  _org := public.current_org_id();

  -- 🔐 ROLE-BASED AUTH
  IF NOT EXISTS (
    SELECT 1
    FROM public.user_roles ur
    WHERE ur.user_id = _uid
      AND ur.organization_id = _org
      AND ur.role IN ('tenant_admin', 'manager', 'hr')
  ) THEN
    RAISE EXCEPTION 'not authorized';
  END IF;

  INSERT INTO public.email_batches (
    organization_id,
    template_id,
    target_role,
    created_by
  )
  VALUES (
    _org,
    _template_id,
    _target_role,
    _uid
  )
  RETURNING id INTO _batch_id;

  SELECT subject, body
  INTO _tmpl_sub, _tmpl_body
  FROM public.email_templates
  WHERE id = _template_id
    AND organization_id = _org;

  IF _tmpl_sub IS NULL THEN
    RAISE EXCEPTION 'invalid email template';
  END IF;

  -- A) Target role
  IF _target_role IS NOT NULL THEN
    FOR rec IN
      SELECT p.id AS user_id, p.email
      FROM public.profiles p
      JOIN public.user_roles ur
        ON ur.user_id = p.id
       AND ur.organization_id = _org
      WHERE ur.role = _target_role
        AND p.organization_id = _org
    LOOP
      SELECT subject, body
      INTO _sub, _body
      FROM public.resolve_email_template(_template_id, rec.user_id);

      INSERT INTO public.email_batch_recipients (
        batch_id, user_id, email, subject, body
      )
      VALUES (
        _batch_id, rec.user_id, rec.email, _sub, _body
      )
      ON CONFLICT (batch_id, email) DO NOTHING;
    END LOOP;
  END IF;

  -- B) Specific users
  IF _specific_user_ids IS NOT NULL THEN
    FOR rec IN
      SELECT p.id AS user_id, p.email
      FROM public.profiles p
      WHERE p.id = ANY(_specific_user_ids)
        AND p.organization_id = _org
    LOOP
      SELECT subject, body
      INTO _sub, _body
      FROM public.resolve_email_template(_template_id, rec.user_id);

      INSERT INTO public.email_batch_recipients (
        batch_id, user_id, email, subject, body
      )
      VALUES (
        _batch_id, rec.user_id, rec.email, _sub, _body
      )
      ON CONFLICT (batch_id, email) DO NOTHING;
    END LOOP;
  END IF;

  -- C) Manual emails
  IF _manual_emails IS NOT NULL THEN
    FOREACH _manual_email IN ARRAY _manual_emails LOOP
      _sub := replace(_tmpl_sub, '{{name}}', 'Guest');
      _sub := replace(_sub, '{{role}}', '');
      _body := replace(_tmpl_body, '{{name}}', 'Guest');
      _body := replace(_body, '{{role}}', '');

      INSERT INTO public.email_batch_recipients (
        batch_id, user_id, email, subject, body
      )
      VALUES (
        _batch_id, NULL, _manual_email, _sub, _body
      )
      ON CONFLICT (batch_id, email) DO NOTHING;
    END LOOP;
  END IF;

  INSERT INTO public.email_events (
    batch_id, user_id, event, message
  )
  SELECT
    _batch_id,
    user_id,
    'queued',
    'queued for send'
  FROM public.email_batch_recipients
  WHERE batch_id = _batch_id;

  RETURN _batch_id;
END;
$$;
