import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY;

// This client is ready for the shared-data migration once the SQL schema is applied.
export const supabase = url && key ? createClient(url, key) : null;
