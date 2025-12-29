-- Add collaboration features: owners, collaborators, timings, messages, notifications
do $$
begin
  if not exists (select 1 from pg_type where typname = 'entity_type') then
    create type public.entity_type as enum ('task','deal','lead');
  end if;
end$$;

alter table public.tasks
  add column if not exists owner_id uuid;

alter table public.tasks
  add constraint tasks_owner_id_fk foreign key (owner_id) references public.profiles(id) on delete set null;

create table if not exists public.task_collaborators (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (task_id, user_id)
);

create table if not exists public.task_timings (
  task_id uuid primary key references public.tasks(id) on delete cascade,
  assigned_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  total_seconds integer
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  entity_type public.entity_type not null,
  entity_id uuid not null,
  author_id uuid not null references public.profiles(id) on delete set null,
  content text not null,
  mentions uuid[] default '{}',
  created_at timestamptz not null default now()
);

create index if not exists idx_messages_entity on public.messages(entity_type, entity_id, created_at);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null,
  entity_type public.entity_type,
  entity_id uuid,
  title text,
  body text,
  read boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_notifications_user on public.notifications(user_id, created_at, read);

