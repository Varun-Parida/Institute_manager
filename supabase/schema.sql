-- Run this once in Supabase Dashboard → SQL Editor → New query.
-- It creates the shared data structure for CoachWise / Arun Institute AI.

create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  roll text not null unique,
  name text not null,
  gender text not null check (gender in ('Male','Female')),
  created_at timestamptz not null default now()
);

create table if not exists public.attendance_settings (
  id boolean primary key default true check (id),
  start_date date,
  end_date date,
  updated_at timestamptz not null default now()
);
insert into public.attendance_settings (id) values (true) on conflict (id) do nothing;

create table if not exists public.attendance_records (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  attendance_date date not null,
  status text not null check (status in ('Present','Absent')),
  created_at timestamptz not null default now(),
  unique (student_id, attendance_date)
);

create table if not exists public.enrollment_applications (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  gender text not null check (gender in ('Male','Female')),
  mobile text not null,
  email text,
  course text not null,
  status text not null default 'Pending' check (status in ('Pending','Approved','Rejected')),
  created_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  published_at date not null default current_date,
  created_at timestamptz not null default now()
);

create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subject text not null,
  course text,
  description text,
  access_type text not null check (access_type in ('Free','Paid')),
  price numeric(10,2) not null default 0,
  file_path text,
  published boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  transaction_id text not null,
  kind text not null,
  screenshot_path text,
  status text not null default 'Pending' check (status in ('Pending','Verified','Rejected')),
  created_at timestamptz not null default now()
);

-- Private buckets: use signed URLs in the app for screenshots and paid notes.
insert into storage.buckets (id, name, public) values
  ('payment-screenshots', 'payment-screenshots', false),
  ('study-notes', 'study-notes', false)
on conflict (id) do nothing;

-- Security note: keep Row Level Security enabled. The next integration step uses
-- Supabase Auth for the single faculty account, so only that account can write
-- students, attendance, notes, announcements, or payment decisions.
alter table public.students enable row level security;
alter table public.attendance_settings enable row level security;
alter table public.attendance_records enable row level security;
alter table public.enrollment_applications enable row level security;
alter table public.announcements enable row level security;
alter table public.notes enable row level security;
alter table public.payments enable row level security;
