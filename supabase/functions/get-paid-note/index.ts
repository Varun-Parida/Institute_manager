import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  try {
    const { noteId, buyerName, transactionId } = await req.json()
    if (!noteId || !buyerName || !transactionId) {
      return Response.json({ verified: false, message: 'Enter your name and transaction ID.' }, { headers: corsHeaders })
    }

    const admin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { data: payment } = await admin
      .from('payments')
      .select('id')
      .eq('kind', `Note: ${noteId}`)
      .ilike('name', buyerName.trim())
      .eq('transaction_id', transactionId.trim())
      .eq('status', 'Verified')
      .maybeSingle()

    if (!payment) {
      return Response.json({ verified: false, message: 'Payment is pending or could not be verified yet.' }, { headers: corsHeaders })
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

    const { data: signed, error } = await admin.storage
      .from('study-notes')
      .createSignedUrl(note.file_path, 60)

    if (error || !signed) throw error ?? new Error('Could not create a download link.')
    return Response.json({ verified: true, url: signed.signedUrl }, { headers: corsHeaders })
  } catch (error) {
    return Response.json({ verified: false, message: error.message ?? 'Download could not be prepared.' }, { status: 500, headers: corsHeaders })
  }
})
