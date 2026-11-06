-- Run this after schema.sql in Supabase Dashboard → SQL Editor.
-- Before using the app, create ONE faculty user in Authentication → Users.
-- Disable public email sign-ups in Authentication → Providers → Email.

-- Only the signed-in faculty account may administer institute data.
create policy "Faculty manages students" on public.students
  for all to authenticated using (true) with check (true);
create policy "Faculty manages attendance settings" on public.attendance_settings
  for all to authenticated using (true) with check (true);
create policy "Faculty manages attendance" on public.attendance_records
  for all to authenticated using (true) with check (true);
create policy "Faculty manages applications" on public.enrollment_applications
  for all to authenticated using (true) with check (true);
create policy "Faculty manages announcements" on public.announcements
  for all to authenticated using (true) with check (true);
create policy "Faculty manages notes" on public.notes
  for all to authenticated using (true) with check (true);
create policy "Faculty manages payments" on public.payments
  for all to authenticated using (true) with check (true);

-- Students may submit an enrollment request or payment details.
create policy "Public submits enrollments" on public.enrollment_applications
  for insert to anon, authenticated with check (true);
create policy "Public submits payments" on public.payments
  for insert to anon, authenticated with check (true);

-- Public pages can read only published notes and announcements.
create policy "Public reads announcements" on public.announcements
  for select to anon, authenticated using (true);
create policy "Public reads published notes" on public.notes
  for select to anon, authenticated using (published = true);

-- A safe, roll-number-only attendance lookup. It does not expose the full register.
create or replace function public.get_student_attendance(p_roll text)
returns table (
  roll text,
  name text,
  gender text,
  attendance_date date,
  status text
)
language sql
security definer
set search_path = public
as $$
  select s.roll, s.name, s.gender, ar.attendance_date, ar.status
  from public.students s
  left join public.attendance_records ar on ar.student_id = s.id
  where lower(s.roll) = lower(trim(p_roll))
  order by ar.attendance_date desc nulls last;
$$;
grant execute on function public.get_student_attendance(text) to anon, authenticated;

-- Private screenshot uploads: public users may submit a proof image; only faculty
-- can view or delete images. The frontend enforces the 1 MB size rule.
create policy "Public uploads payment proof" on storage.objects
  for insert to anon, authenticated
  with check (bucket_id = 'payment-screenshots');
create policy "Faculty views payment proof" on storage.objects
  for select to authenticated using (bucket_id = 'payment-screenshots');
create policy "Faculty deletes payment proof" on storage.objects
  for delete to authenticated using (bucket_id = 'payment-screenshots');

-- Only faculty may manage note files. Files remain private and are served through
-- signed URLs after a verified purchase.
create policy "Faculty manages note files" on storage.objects
  for all to authenticated
  using (bucket_id = 'study-notes')
  with check (bucket_id = 'study-notes');
