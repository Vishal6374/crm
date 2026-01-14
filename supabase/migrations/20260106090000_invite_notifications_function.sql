CREATE OR REPLACE FUNCTION public.invite_user_to_org(invited_user_id UUID, target_org_id UUID, invite_role TEXT)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  invited_user_org UUID;
  notif_id UUID;
  caller_is_admin BOOLEAN;
BEGIN
  SELECT organization_id INTO invited_user_org FROM public.profiles WHERE id = invited_user_id;
  IF invited_user_org IS NULL THEN
    invited_user_org := target_org_id;
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM public.user_roles ur
    WHERE ur.user_id = auth.uid()
      AND ur.organization_id = target_org_id
      AND ur.role IN ('tenant_admin','admin')
  ) INTO caller_is_admin;

  IF NOT caller_is_admin THEN
    RAISE EXCEPTION 'not authorized';
  END IF;

  INSERT INTO public.notifications (
    id, user_id, title, body, type, entity_id, read, organization_id
  ) VALUES (
    gen_random_uuid(),
    invited_user_id,
    'Organization Invite',
    'role:' || invite_role,
    'user_invite',
    target_org_id,
    false,
    invited_user_org
  )
  RETURNING id INTO notif_id;

  RETURN notif_id;
END;
$$;
