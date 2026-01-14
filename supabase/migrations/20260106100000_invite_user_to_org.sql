-- ============================================
-- Migration: invite_user_to_org RPC
-- Purpose : Allow org admins to invite users
--           by creating a notification while
--           bypassing RLS safely.
-- ============================================

BEGIN;

-- Drop existing function to avoid signature mismatch issues
DROP FUNCTION IF EXISTS public.invite_user_to_org(UUID, UUID, TEXT);

CREATE OR REPLACE FUNCTION public.invite_user_to_org(
  invited_user_id UUID,
  target_org_id UUID,
  invite_role TEXT
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  notif_id UUID;
BEGIN
  -- 🔐 Explicitly disable RLS for this transaction scope
  PERFORM set_config('row_security', 'off', true);

  INSERT INTO public.notifications (
    id,
    user_id,
    title,
    body,
    type,
    entity_id,
    read,
    organization_id
  ) VALUES (
    gen_random_uuid(),
    invited_user_id,
    'Organization Invite',
    'role:' || invite_role,
    'user_invite',
    target_org_id,
    false,
    target_org_id
  )
  RETURNING id INTO notif_id;

  RETURN notif_id;
END;
$$;

-- Restrict execution to authenticated users only
REVOKE ALL ON FUNCTION public.invite_user_to_org(UUID, UUID, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.invite_user_to_org(UUID, UUID, TEXT) TO authenticated;

COMMIT;
