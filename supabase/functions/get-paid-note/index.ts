import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  try {
    const { noteId, buyerName, transactionId, action = 'check' } = await req.json()
    if (!noteId || !buyerName) {
      return Response.json({ verified: false, message: 'Enter your username.' }, { headers: corsHeaders })
    }

    const admin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { data: payment } = await admin
      .from('payments')
      .select('id, download_used_at')
      .eq('kind', `Note: ${noteId}`)
      .ilike('name', buyerName.trim())
      .eq('status', 'Verified')
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()

    if (!payment) {
      return Response.json({ verified: false, message: 'Payment is pending or could not be verified yet.' }, { headers: corsHeaders })
    }

    if (action === 'download') {
      const { data: consumed, error: consumeError } = await admin
        .from('payments')
        .update({ download_used_at: new Date().toISOString() })
        .eq('id', payment.id)
        .is('download_used_at', null)
        .select('id')
        .maybeSingle()
      if (consumeError) throw consumeError
      if (!consumed) return Response.json({ verified: false, message: 'Download limit reached. This note can only be downloaded once.' }, { headers: corsHeaders })
    }

    const { data: note } = await admin
      .from('notes')
      .select('file_path, published')
      .eq('id', noteId)
      .eq('published', true)
      .maybeSingle()

    if (!note?.file_path) {
      return Response.json({ verified: false, message: 'The note file is not available.' }, { headers: corsHeaders })
    }

    if (action !== 'download') {
      return Response.json({ verified: true, message: 'Payment verified. You may download this note once.' }, { headers: corsHeaders })
    }

    const { data: signed, error } = await admin.storage
      .from('study-notes')
      .createSignedUrl(note.file_path, 60)

    if (error || !signed) throw error ?? new Error('Could not create a download link.')
    return Response.json({ verified: true, url: signed.signedUrl }, { headers: corsHeaders })
  } catch (error) {
    return Response.json({ verified: false, message: error.message ?? 'Download could not be prepared.' }, { status: 500, headers: corsHeaders })
  }
})
