-- Run once in Supabase SQL Editor.
-- Free files are stored under study-notes/free/. Paid files stay private.
drop policy if exists "Public reads free note files" on storage.objects;
create policy "Public reads free note files" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'study-notes' and name like 'free/%');
