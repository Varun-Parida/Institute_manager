-- Run once in Supabase SQL Editor.
-- Each verified payment can receive one download link.
alter table public.payments
  add column if not exists download_used_at timestamptz;
