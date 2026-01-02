-- Add subject and body to emails_outbox for history and template independence
ALTER TABLE public.emails_outbox ADD COLUMN IF NOT EXISTS subject TEXT;
ALTER TABLE public.emails_outbox ADD COLUMN IF NOT EXISTS body TEXT;

-- Update RLS if needed (already covers all columns)
