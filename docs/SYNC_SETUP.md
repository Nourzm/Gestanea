# Supabase + PowerSync Setup

Gestanéa is **offline-first**: SQLite on device is always the source of
truth for reads. Online sync layers on top via Supabase (auth + backend
DB) and PowerSync (bidirectional sync engine).

If you only want to run the app locally with no backend, you can skip
everything below — the app gracefully falls back to a fully offline
mode when no environment variables are supplied.

---

## 1. Supabase

### 1a. Apply the schema migration

The schema lives at:

```
supabase/migrations/20260607000000_init_schema.sql
```

It creates every Postgres table mirroring the local SQLite schema, plus
Row Level Security policies so users can only ever read/write their own
rows, plus a trigger that auto-creates a `public.users` row when a user
signs up.

Apply it with the Supabase CLI from the project root:

```bash
supabase db push
```

…or via the Supabase MCP tool: `apply_migration` with the file
contents.

### 1b. Grab your keys

In the Supabase dashboard for project **clreowcinwmwajzlysem**:

- **Settings → API → Project URL** → already
  `https://clreowcinwmwajzlysem.supabase.co`
- **Settings → API → Project API keys → `anon` `public`** → copy this

---

## 2. PowerSync (optional but recommended for sync)

1. Sign up at <https://www.powersync.com> — the free tier covers this
   app easily.
2. Create a new **PowerSync instance** and point it at your Supabase
   project (it will guide you through enabling logical replication on
   the Supabase side).
3. Open **Manage instance → Sync rules** and paste the contents of
   `supabase/config/powersync-rules.yaml`.
4. Copy the **instance URL** — looks like
   `https://<id>.powersync.journeyapps.com`.

If you skip PowerSync, leave `POWERSYNC_URL` empty in your `env.json`
and the app will run with Supabase Auth + local SQLite only (no sync).

---

## 3. Wire the keys into the app

Copy the template:

```bash
cp env.example.json env.json
```

Edit `env.json` and replace the `REPLACE_ME` placeholders. **Do not
commit `env.json`** — it's gitignored.

Then always run / build with the `--dart-define-from-file` flag so the
keys are baked in:

```bash
flutter run    --dart-define-from-file=env.json
flutter build apk --dart-define-from-file=env.json
flutter build ipa --dart-define-from-file=env.json
```

---

## 4. Sanity check

After running with valid keys you should see in the debug console:

- No `SUPABASE_ANON_KEY not configured` warning.
- After sign-up or login: `PowerSyncService.connect: …` start lines
  followed by streaming bucket subscriptions.

On the device, create a medicine in the Plan tab and you should see
the row appear in your Supabase `medicines` table within a few
seconds.

---

## 5. Migrating feature repos to sync

PowerSync is wired and ready, but the current feature repositories
(e.g. `MedicineRepository`, `PregnancyLocalDataSource`) still talk to
the legacy `DatabaseHelper` (sqflite). To put a table on sync, swap
the DB handle in that repository:

```dart
// Before:
final db = await DatabaseHelper.instance.database;
await db.insert('medicines', medicine.toMap());

// After:
final db = PowerSyncService.instance.db;
await db.execute(
  'INSERT INTO medicines (id, user_id, medicine_name, ...) '
  'VALUES (?, ?, ?, ...)',
  [medicine.id, medicine.userId, medicine.medicineName, ...],
);
```

PowerSync's `execute` accepts the same SQL you already use. Reads
become `db.getAll(...)` / `db.get(...)`. Once a repo is migrated,
every insert/update/delete is automatically queued and pushed to
Supabase.

Suggested migration order (least risky first):

1. `MedicineRepository` (medicines + medicine_logged) — clean
   single-purpose repo.
2. `AppointmentRepository`.
3. `PregnancyLocalDataSource` (already has String-ID overloads).
4. `BabyLocalDataSource`.
5. Health log blocs (measurements / symptoms / lab_results).
6. Dashboard data sources.
7. Marketplace + orders (last — these hit several tables together).

---

## 6. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `Supabase user is not signed in — cannot fetch sync token` | Trying to sync before login | Expected; PowerSync auto-connects after login |
| RLS denied writes (HTTP 403) | RLS policy mismatch | Check that the row's `user_id` equals `auth.uid()` |
| Local writes never appear in Supabase | Repo still using `DatabaseHelper` instead of PowerSync DB | Migrate that repo (see §5) |
| `RealtimeChannel error` in console | Supabase realtime not enabled | Enable it in Project Settings → Realtime |
