-- Viaggi Mensili: esegui in Supabase SQL Editor
create table if not exists public.viaggi (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 data_notte date not null,
 importo numeric(12,2) not null check(importo >= 0),
 descrizione text not null default '',
 note text not null default '',
 created_at timestamptz not null default now()
);
create index if not exists viaggi_user_data_idx on public.viaggi(user_id,data_notte);
alter table public.viaggi enable row level security;
drop policy if exists "Users read own trips" on public.viaggi;
create policy "Users read own trips" on public.viaggi for select to authenticated using(auth.uid()=user_id);
drop policy if exists "Users insert own trips" on public.viaggi;
create policy "Users insert own trips" on public.viaggi for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "Users delete own trips" on public.viaggi;
create policy "Users delete own trips" on public.viaggi for delete to authenticated using(auth.uid()=user_id);

create table if not exists public.impostazioni_mensili (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 anno integer not null check(anno between 2000 and 2100),
 mese integer not null check(mese between 1 and 12),
 paga_base numeric(12,2) not null default 1250 check(paga_base >= 0),
 quattordicesima numeric(12,2) not null default 81 check(quattordicesima >= 0),
 note text not null default '',
 created_at timestamptz not null default now(),
 unique(user_id,anno,mese)
);
alter table public.impostazioni_mensili enable row level security;
drop policy if exists "Users read own monthly settings" on public.impostazioni_mensili;
create policy "Users read own monthly settings" on public.impostazioni_mensili for select to authenticated using(auth.uid()=user_id);
drop policy if exists "Users insert own monthly settings" on public.impostazioni_mensili;
create policy "Users insert own monthly settings" on public.impostazioni_mensili for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "Users update own monthly settings" on public.impostazioni_mensili;
create policy "Users update own monthly settings" on public.impostazioni_mensili for update to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
