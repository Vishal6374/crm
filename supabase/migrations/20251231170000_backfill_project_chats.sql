-- 1. Ensure all projects have a chat channel
DO $$
DECLARE
  _r RECORD;
BEGIN
  FOR _r IN 
    SELECT p.id, p.name, p.organization_id, p.owner_id 
    FROM public.projects p
    WHERE NOT EXISTS (SELECT 1 FROM public.chat_channels cc WHERE cc.project_id = p.id)
  LOOP
    INSERT INTO public.chat_channels (organization_id, type, name, project_id, created_by)
    VALUES (_r.organization_id, 'project', _r.name, _r.id, _r.owner_id);
  END LOOP;
END $$;

-- 2. Ensure all project members are in the chat channel
INSERT INTO public.chat_participants (channel_id, user_id)
SELECT 
  cc.id,
  e.user_id
FROM public.project_members pm
JOIN public.chat_channels cc ON cc.project_id = pm.project_id
JOIN public.employees e ON e.id = pm.employee_id
WHERE NOT EXISTS (
  SELECT 1 FROM public.chat_participants cp 
  WHERE cp.channel_id = cc.id AND cp.user_id = e.user_id
);

-- 3. Ensure project owners are in the chat channel
INSERT INTO public.chat_participants (channel_id, user_id)
SELECT 
  cc.id,
  p.owner_id
FROM public.projects p
JOIN public.chat_channels cc ON cc.project_id = p.id
WHERE p.owner_id IS NOT NULL
AND NOT EXISTS (
  SELECT 1 FROM public.chat_participants cp 
  WHERE cp.channel_id = cc.id AND cp.user_id = p.owner_id
);
