-- Conti personali e familiari: tabella movimenti con isolamento per utente
create table if not exists public.movimenti (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  data date not null,
  tipo text not null check (tipo in ('Entrata', 'Uscita')),
  descrizione text not null,
  categoria text not null default 'Altro',
  importo numeric(12,2) not null check (importo > 0),
  note text not null default '',
  created_at timestamptz not null default now()
);

alter table public.movimenti enable row level security;

drop policy if exists "Users can read own movements" on public.movimenti;
create policy "Users can read own movements"
on public.movimenti for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert own movements" on public.movimenti;
create policy "Users can insert own movements"
on public.movimenti for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can delete own movements" on public.movimenti;
create policy "Users can delete own movements"
on public.movimenti for delete
to authenticated
using (auth.uid() = user_id);

-- Non è prevista la modifica dei movimenti esistenti dall'app; per aggiornamenti futuri
-- aggiungere una policy UPDATE con USING e WITH CHECK basate su auth.uid() = user_id.
