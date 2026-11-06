-- Run once in Supabase SQL Editor.
-- Keeps compatibility with the existing payment table and records the note price.
alter table public.payments add column if not exists student_name text;
alter table public.payments add column if not exists amount numeric;

update public.payments
set student_name = coalesce(student_name, name),
    name = coalesce(name, student_name)
where name is null or student_name is null;
