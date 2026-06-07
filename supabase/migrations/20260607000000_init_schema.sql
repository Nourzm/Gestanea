-- Gestanéa initial Supabase schema — mirrors lib/core/database/db_helper.dart
-- (sqflite local DB) so PowerSync can sync rows bidirectionally.
--
-- Every table uses TEXT primary keys (UUID strings) to match the local
-- schema 1:1. Every table that holds user-scoped data carries a `user_id`
-- column that defaults to auth.uid() so PowerSync writes don't need to
-- echo it, and is enforced by RLS so a user can NEVER read or write
-- another user's rows.
--
-- Run with:
--   supabase db push                    (from CLI)
-- or apply via Supabase MCP `apply_migration`.

-- =========================================================================
-- Helper: updated_at trigger
-- =========================================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =========================================================================
-- USERS PROFILE (mirrors auth.users; do NOT store credentials here)
-- =========================================================================
create table if not exists public.users (
  id text primary key,                            -- = auth.uid()
  email text unique not null,
  name text not null,
  phone text,
  country text,
  language text,
  theme text,
  notifications_enabled integer default 1,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create trigger users_set_updated_at
  before update on public.users
  for each row execute function public.set_updated_at();

-- =========================================================================
-- PREGNANCIES
-- =========================================================================
create table if not exists public.pregnancies (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  lmp_date date not null,
  due_date date not null,
  current_week integer,
  current_trimester text,
  is_active integer default 1,
  medical_conditions text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index if not exists pregnancies_user_idx on public.pregnancies(user_id);

-- =========================================================================
-- KICK COUNTS
-- =========================================================================
create table if not exists public.kick_counts (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  kick_count integer not null,
  duration_minutes integer,
  recorded_at timestamptz default now(),
  notes text,
  created_at timestamptz default now()
);
create index if not exists kick_counts_user_idx on public.kick_counts(user_id);

-- =========================================================================
-- BABIES
-- =========================================================================
create table if not exists public.babies (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  name text not null,
  gender text,
  date_of_birth date not null,
  birth_weight numeric,
  birth_height numeric,
  theme_color text,
  is_active integer default 1,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index if not exists babies_user_idx on public.babies(user_id);

-- =========================================================================
-- BABY GROWTH
-- =========================================================================
create table if not exists public.baby_growth (
  id text primary key,
  baby_id text not null references public.babies(id) on delete cascade,
  recorded_date date not null,
  weight numeric,
  weight_percentile integer,
  height_percentile integer,
  growth_status text,
  notes text,
  created_at timestamptz default now()
);
create index if not exists baby_growth_baby_idx on public.baby_growth(baby_id);

-- =========================================================================
-- MILESTONES
-- =========================================================================
create table if not exists public.milestones (
  id text primary key,
  baby_id text not null references public.babies(id) on delete cascade,
  milestone_name text not null,
  expected_age_months integer,
  achieved_date date,
  notes text,
  created_at timestamptz default now()
);

-- =========================================================================
-- FEEDING LOGS
-- =========================================================================
create table if not exists public.feeding_logs (
  id text primary key,
  baby_id text not null references public.babies(id) on delete cascade,
  feeding_type text not null,
  duration_minutes integer,
  amount_ml numeric,
  breast_side text,
  logged_at timestamptz default now(),
  notes text,
  created_at timestamptz default now()
);

-- =========================================================================
-- HEALTH LOG TABLES
-- =========================================================================
create table if not exists public.vitals (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  vital_type text not null,
  value numeric not null,
  unit text,
  recorded_at timestamptz default now(),
  notes text,
  created_at timestamptz default now()
);
create index if not exists vitals_user_idx on public.vitals(user_id);

create table if not exists public.measurements (
  id text primary key,
  user_id text not null default auth.uid()::text,
  weight numeric,
  heart_rate integer,
  systolic integer,
  diastolic integer,
  recorded_at timestamptz not null,
  notes text,
  created_at timestamptz not null default now()
);
create index if not exists measurements_user_idx on public.measurements(user_id);

create table if not exists public.symptoms (
  id text primary key,
  user_id text not null default auth.uid()::text,
  symptom_name text not null,
  severity text,
  notes text,
  recorded_at timestamptz not null,
  created_at timestamptz not null default now()
);
create index if not exists symptoms_user_idx on public.symptoms(user_id);

create table if not exists public.moods (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  mood text not null,
  intensity integer,
  notes text,
  recorded_at timestamptz default now(),
  created_at timestamptz default now()
);

create table if not exists public.lab_results (
  id text primary key,
  user_id text not null default auth.uid()::text,
  test_name text not null,
  value numeric,
  unit text,
  normal_range_min numeric,
  normal_range_max numeric,
  interpretation text,
  lab_date date not null,
  report_image_url text,
  extracted_by_ocr integer default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.risk_alerts (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  alert_type text not null,
  severity text not null,
  message text not null,
  recommendation text,
  is_resolved integer default 0,
  detected_at timestamptz default now(),
  resolved_at timestamptz,
  created_at timestamptz default now()
);

-- =========================================================================
-- PLAN: APPOINTMENTS, MEDICINES, REMINDERS
-- =========================================================================
create table if not exists public.appointments (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  baby_id text references public.babies(id) on delete cascade,
  title text not null,
  doctor_name text,
  appointment_type text,
  appointment_date timestamptz not null,
  location text,
  notes text,
  reminder_time timestamptz,
  is_completed integer default 0,
  created_at timestamptz default now()
);
create index if not exists appointments_user_idx on public.appointments(user_id);

create table if not exists public.medicines (
  id text primary key,
  user_id text default auth.uid()::text
    references public.users(id) on delete cascade,
  baby_id text references public.babies(id) on delete cascade,
  medicine_name text not null,
  dosage text not null,
  type text,
  frequency_type text not null,
  frequency_value integer,
  scheduled_times text,
  start_date date not null,
  end_date date,
  medicine_image_url text,
  is_active integer default 1,
  created_at timestamptz default now()
);
create index if not exists medicines_user_idx on public.medicines(user_id);

create table if not exists public.medicine_logged (
  id text primary key,
  medicine_id text not null references public.medicines(id) on delete cascade,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  logged_date timestamptz not null,
  status text not null,
  notes text,
  logged_at timestamptz default now()
);

create table if not exists public.reminders (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  reminder_type text not null,
  reference_id text,
  title text not null,
  description text,
  reminder_time timestamptz not null,
  repeat_pattern text,
  is_completed integer default 0,
  completed_at timestamptz,
  created_at timestamptz default now()
);

-- =========================================================================
-- CONTENT TABLES (shared, read-only-ish for users)
-- =========================================================================
create table if not exists public.tips (
  id text primary key,
  title text not null,
  content text not null,
  category text,
  target_audience text,
  image_url text,
  source text,
  is_active integer default 1,
  created_at timestamptz default now()
);

create table if not exists public.user_saved_tips (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  tip_id text not null references public.tips(id) on delete cascade,
  saved_at timestamptz default now()
);

create table if not exists public.doctors (
  id text primary key,
  name text not null,
  specialty text,
  distance numeric,
  gender text,
  phone text,
  email text,
  latitude numeric,
  longitude numeric,
  rating numeric,
  reviews_count integer default 0,
  address text,
  isfavorite integer,
  wilaya text
);

-- =========================================================================
-- MARKETPLACE (catalog public-read, cart/orders user-scoped)
-- =========================================================================
create table if not exists public.product_categories (
  id text primary key,
  name text,
  image_url text,
  display_order integer,
  created_at timestamptz default now()
);

create table if not exists public.products (
  id text primary key,
  product_name text not null,
  description text,
  category_id text references public.product_categories(id) on delete set null,
  target_audience text,
  price numeric not null,
  original_price numeric,
  discount_percentage integer,
  currency text default 'USD',
  rating numeric default 0,
  reviews_count integer default 0,
  image_urls text not null,
  vendor_name text,
  is_available integer default 1,
  created_at timestamptz default now()
);

create table if not exists public.product_variants (
  id text primary key,
  product_id text not null references public.products(id) on delete cascade,
  type text not null,
  value text not null,
  color_hex text,
  stock integer default 0,
  created_at timestamptz default now()
);

create table if not exists public.product_specs (
  id text primary key,
  product_id text not null references public.products(id) on delete cascade,
  name text not null,
  value text not null,
  created_at timestamptz default now()
);

create table if not exists public.product_reviews (
  id text primary key,
  product_id text not null references public.products(id) on delete cascade,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  reviewer_name text not null,
  rating integer not null,
  review_text text,
  created_at timestamptz default now()
);

create table if not exists public.cart_items (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  product_id text not null references public.products(id) on delete cascade,
  product_name text not null,
  product_price numeric not null,
  variant_color text,
  variant_size text,
  quantity integer not null default 1,
  added_at timestamptz default now()
);

create table if not exists public.orders (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  full_name text not null,
  phone_number text not null,
  delivery_address text not null,
  city text not null,
  special_instructions text,
  payment_method text not null,
  subtotal numeric not null,
  delivery_fee numeric not null,
  total_amount numeric not null,
  status text not null default 'pending',
  order_date timestamptz default now(),
  created_at timestamptz default now()
);

create table if not exists public.order_items (
  id text primary key,
  order_id text not null references public.orders(id) on delete cascade,
  product_id text references public.products(id) on delete set null,
  product_name text not null,
  variant_color text,
  variant_size text,
  quantity integer not null,
  unit_price numeric not null,
  subtotal numeric not null
);

create table if not exists public.user_activity_log (
  id text primary key,
  user_id text not null default auth.uid()::text
    references public.users(id) on delete cascade,
  activity_type text not null,
  activity_details text,
  page_visited text,
  session_id text,
  created_at timestamptz default now()
);

-- =========================================================================
-- ROW LEVEL SECURITY
-- =========================================================================
-- USER-SCOPED tables: row.user_id must equal auth.uid()
do $$
declare
  t text;
  user_scoped text[] := array[
    'users','pregnancies','kick_counts','babies','vitals','measurements',
    'symptoms','moods','lab_results','risk_alerts','appointments','medicines',
    'medicine_logged','reminders','user_saved_tips','product_reviews',
    'cart_items','orders','user_activity_log'
  ];
begin
  foreach t in array user_scoped loop
    execute format('alter table public.%I enable row level security', t);

    -- Drop and recreate so re-runs are safe.
    execute format('drop policy if exists "%s_select_own" on public.%I', t, t);
    execute format('drop policy if exists "%s_modify_own" on public.%I', t, t);

    if t = 'users' then
      execute format($p$create policy "users_select_own" on public.users
        for select using (id = auth.uid()::text)$p$);
      execute format($p$create policy "users_modify_own" on public.users
        for all using (id = auth.uid()::text)
        with check (id = auth.uid()::text)$p$);
    else
      execute format($p$create policy "%s_select_own" on public.%I
        for select using (user_id = auth.uid()::text)$p$, t, t);
      execute format($p$create policy "%s_modify_own" on public.%I
        for all using (user_id = auth.uid()::text)
        with check (user_id = auth.uid()::text)$p$, t, t);
    end if;
  end loop;
end $$;

-- BABY-SCOPED tables (joined via babies.user_id)
do $$
declare
  t text;
  baby_scoped text[] := array['baby_growth','milestones','feeding_logs'];
begin
  foreach t in array baby_scoped loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "%s_select_via_baby" on public.%I', t, t);
    execute format('drop policy if exists "%s_modify_via_baby" on public.%I', t, t);
    execute format($p$create policy "%s_select_via_baby" on public.%I
      for select using (
        exists (select 1 from public.babies b
                 where b.id = %I.baby_id and b.user_id = auth.uid()::text)
      )$p$, t, t, t);
    execute format($p$create policy "%s_modify_via_baby" on public.%I
      for all using (
        exists (select 1 from public.babies b
                 where b.id = %I.baby_id and b.user_id = auth.uid()::text)
      ) with check (
        exists (select 1 from public.babies b
                 where b.id = %I.baby_id and b.user_id = auth.uid()::text)
      )$p$, t, t, t, t);
  end loop;
end $$;

-- ORDER ITEMS — scoped via parent order
alter table public.order_items enable row level security;
drop policy if exists order_items_select on public.order_items;
drop policy if exists order_items_modify on public.order_items;
create policy order_items_select on public.order_items
  for select using (
    exists (select 1 from public.orders o
             where o.id = order_items.order_id and o.user_id = auth.uid()::text)
  );
create policy order_items_modify on public.order_items
  for all using (
    exists (select 1 from public.orders o
             where o.id = order_items.order_id and o.user_id = auth.uid()::text)
  ) with check (
    exists (select 1 from public.orders o
             where o.id = order_items.order_id and o.user_id = auth.uid()::text)
  );

-- PUBLIC CATALOG tables — readable by anyone signed in
do $$
declare
  t text;
  public_read text[] := array[
    'tips','doctors','product_categories','products','product_variants',
    'product_specs'
  ];
begin
  foreach t in array public_read loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "%s_public_read" on public.%I', t, t);
    execute format($p$create policy "%s_public_read" on public.%I
      for select using (true)$p$, t, t);
  end loop;
end $$;

-- =========================================================================
-- AUTH HOOK: auto-create a profile row whenever a user signs up
-- =========================================================================
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.users (id, email, name, phone)
  values (
    new.id::text,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    new.raw_user_meta_data->>'phone'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
