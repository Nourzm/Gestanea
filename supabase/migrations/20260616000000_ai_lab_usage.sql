-- Per-user usage log for the analyze-lab Edge Function's daily rate limit.
-- Rows are written by the function using the service role; clients never
-- read or write this table directly (RLS denies all client access).

create table if not exists public.ai_lab_usage (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create index if not exists ai_lab_usage_user_day_idx
  on public.ai_lab_usage (user_id, created_at);

alter table public.ai_lab_usage enable row level security;

-- No client policies: only the service-role key (used by the Edge Function)
-- can read/insert. RLS with zero policies denies all anon/authenticated access.
