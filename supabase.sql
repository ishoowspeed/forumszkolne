create table profiles (
  id uuid primary key references auth.users on delete cascade,
  name text not null,
  role text not null default 'Uczeń',
  klasa text default ''
);

create table messages (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  body text not null check (char_length(body) between 1 and 500),
  created_at timestamptz not null default now()
);

alter table profiles enable row level security;
alter table messages enable row level security;

create policy "profiles read" on profiles for select to authenticated using (true);
create policy "messages read" on messages for select to authenticated using (true);
create policy "messages insert" on messages for insert to authenticated with check (user_id = auth.uid());

alter publication supabase_realtime add table messages;
