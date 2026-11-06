-- Run once in Supabase SQL Editor.
-- Students may create payment requests; the authenticated faculty account can see and manage all of them.
grant usage on schema public to anon, authenticated;
grant insert on public.payments to anon;
grant select, insert, update, delete on public.payments to authenticated;

alter table public.payments enable row level security;

drop policy if exists "Public submits payments" on public.payments;
drop policy if exists "Faculty manages payments" on public.payments;

create policy "Public submits payments"
on public.payments
for insert
to anon, authenticated
with check (true);

create policy "Faculty manages payments"
on public.payments
for all
to authenticated
using (true)
with check (true);
