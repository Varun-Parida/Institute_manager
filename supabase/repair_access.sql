-- Run this in Supabase Dashboard → SQL Editor to repair admin database access.
-- Safe to run even if access.sql was already run.

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.students to authenticated;
grant select, insert, update, delete on public.attendance_settings to authenticated;
grant select, insert, update, delete on public.attendance_records to authenticated;
grant select, insert, update, delete on public.enrollment_applications to authenticated;
grant select, insert, update, delete on public.payments to authenticated;
grant select, insert, update, delete on public.announcements to authenticated;
grant select, insert, update, delete on public.notes to authenticated;
grant insert on public.enrollment_applications to anon;
grant insert on public.payments to anon;
grant select on public.announcements to anon;
grant select on public.notes to anon;

drop policy if exists "Faculty manages students" on public.students;
drop policy if exists "Faculty manages attendance settings" on public.attendance_settings;
drop policy if exists "Faculty manages attendance" on public.attendance_records;
drop policy if exists "Faculty manages applications" on public.enrollment_applications;
drop policy if exists "Faculty manages announcements" on public.announcements;
drop policy if exists "Faculty manages notes" on public.notes;
drop policy if exists "Faculty manages payments" on public.payments;
drop policy if exists "Public submits enrollments" on public.enrollment_applications;
drop policy if exists "Public submits payments" on public.payments;
drop policy if exists "Public reads announcements" on public.announcements;
drop policy if exists "Public reads published notes" on public.notes;

create policy "Faculty manages students" on public.students for all to authenticated using (true) with check (true);
create policy "Faculty manages attendance settings" on public.attendance_settings for all to authenticated using (true) with check (true);
create policy "Faculty manages attendance" on public.attendance_records for all to authenticated using (true) with check (true);
create policy "Faculty manages applications" on public.enrollment_applications for all to authenticated using (true) with check (true);
create policy "Faculty manages announcements" on public.announcements for all to authenticated using (true) with check (true);
create policy "Faculty manages notes" on public.notes for all to authenticated using (true) with check (true);
create policy "Faculty manages payments" on public.payments for all to authenticated using (true) with check (true);
create policy "Public submits enrollments" on public.enrollment_applications for insert to anon, authenticated with check (true);
create policy "Public submits payments" on public.payments for insert to anon, authenticated with check (true);
create policy "Public reads announcements" on public.announcements for select to anon, authenticated using (true);
create policy "Public reads published notes" on public.notes for select to anon, authenticated using (published = true);

-- Verify the faculty account can read the primary table after signing in.
-- The query should return an empty result rather than an error.
select * from public.students limit 1;
