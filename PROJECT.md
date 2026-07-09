# Gestanéa — Project Overview

> Read this for architecture and context. For known problems see [GAPS.md](GAPS.md); for day-to-day commands and rules see [CLAUDE.md](CLAUDE.md).

## What this is

**Gestanéa** is a mobile app (Flutter) for **pregnancy and early baby care**. The user is an expecting mother or a new parent. It runs in one of two modes that the app switches between automatically based on the user's data:

- **Pregnancy mode** — week-by-week tracking, fetal development, kick counter, weight/vitals, lab results, appointments, symptoms, mood.
- **Postpartum/baby mode** — feeding logs, growth tracking, milestones, vaccines.

Around those it adds a **Health** log (vitals, symptoms, lab results with AI interpretation, risk alerts, mood), a **Plan** tab (appointments + medicines), a **Doctors** directory with a map, a **Marketplace** (baby products), and **Education/Tips** content.

The audience is regional — **Algeria-focused**: three languages **English / French / Arabic** (Arabic is full RTL), doctors are keyed by `wilaya`, and the emergency call button dials **115** (Algeria SAMU). The brand is purple (`AppColors.main*`).

The guiding principle is **offline-first**: the app is fully functional with no backend, no account server, and no internet. Cloud features (Supabase auth, PowerSync sync, AI lab analysis) are **optional add-ons** that light up only when configured at build time.

## Tech stack (and why)

| Piece | Package | Why it's here |
|---|---|---|
| UI framework | Flutter | Single codebase, Android-primary (iOS/web/desktop folders exist but Android is the target). |
| State management | `flutter_bloc` (BLoC + Cubit) | Every feature uses Bloc/Cubit. No Riverpod/Provider-for-state. |
| Local database | `sqflite` | The **source of truth**. One SQLite file `gestanea.db`, hand-written schema + migrations in `DatabaseHelper`. Chosen so the app works fully offline. |
| Auth (optional) | `supabase_flutter` | When a Supabase anon key is provided, real email/password auth. |
| Auth (offline) | `bcrypt` + sqflite | Fallback local account store (salted bcrypt) when Supabase isn't configured. |
| Sync (optional, **half-built**) | `powersync` | Intended cloud sync. Plumbing exists; **the data plane was never migrated onto it** (see GAPS #1). |
| OCR | `google_mlkit_text_recognition` | On-device text extraction from lab-report photos (free, offline). |
| AI lab interpretation | Supabase Edge Function (Deno) → Gemini / OpenRouter / Claude | Server-side proxy so the AI key never ships in the app. Provider is swappable via a secret. |
| Charts | `fl_chart` | Weight-progress and other charts. |
| Maps | `flutter_map` + `geolocator` + `latlong2` | Doctors directory map. |
| Notifications | `flutter_local_notifications` + `timezone` | Local reminders. |
| Localization | `flutter_localizations` + `intl` + ARB files | en/fr/ar. |
| Nav bar | custom `FancyNavBar` (CustomPainter) | The notched bottom bar with the floating purple circle. |

## Architecture

**Feature-first** layout. Each feature is `lib/features/<name>/` split into `data/` (datasources, models, repositories), `logic/` (blocs/cubits), and `presentation/` (pages, widgets). Shared code lives in `lib/core/`.

```
main.dart ──> app.dart (MyApp)
  │            • MaterialApp, named routes (lib/routes.dart + core/constants/app_routes.dart)
  │            • locale state (setAppLocale), l10n delegates
  │            • provides AuthBloc app-wide (RepositoryProvider + BlocProvider)
  │            • initialRoute = splash → onboarding → auth → dashboard
  │
  ├─ SupabaseService.init()     (no-op if SUPABASE_ANON_KEY empty)
  ├─ PowerSyncService.init()    (no-op if POWERSYNC_URL empty)
  └─ NotificationsService.init()

DashboardPage  ← the app shell
  • 5-tab IndexedStack: Home / Track / Health / Plan / Market
  • FancyNavBar (custom notched bar, forced LTR)
  • Home & Track swap pregnancy vs postpartum widgets based on DashboardCubit state

UI (widget)
  └─ Bloc/Cubit (logic)
       └─ Repository / DataSource (data)
            └─ DatabaseHelper.instance.database  →  sqflite  gestanea.db   ← SOURCE OF TRUTH
```

**Data flow:** everything reads/writes `gestanea.db` through `DatabaseHelper.instance`. Models (`lib/core/database/models/*.dart`) carry `toMap()` / `fromMap()` / `copyWith()`. There is no ORM.

**Auth is dual-mode** (`features/auth/data/models/auth_repo_impl.dart`):
- **Online** (Supabase configured): `signUp` / `signInWithPassword` against Supabase Auth, then the Supabase user is **mirrored into the local `users` table** so the rest of the app can read profile data synchronously from sqflite. A real Supabase session exists → PowerSync `connect()` is kicked off.
- **Offline** (no anon key): local bcrypt account in `auth_credentials` (salted), user id from `SessionManager` (SharedPreferences `current_user_id`).
The current user id everywhere else comes from `context.read<AuthBloc>().state` → `AuthAuthenticated.user.id`.

**Optional cloud sync (PowerSync):** `PowerSyncService` opens a *separate* local DB `gestanea_powersync.db`; `SupabaseConnector` streams its CRUD queue to Supabase. `powerSyncSchema` (`core/sync/powersync_schema.dart`) mirrors the Postgres tables. **But no feature reads or writes the PowerSync DB** — they all use the legacy `DatabaseHelper`. So sync is currently inert even when fully configured. (See GAPS #1.)

**AI lab analysis:** `supabase/functions/analyze-lab/` (Deno). The Flutter client `LabAiService` calls it via `Supabase…functions.invoke('analyze-lab')`, sending the lab image and/or OCR text plus pregnancy context. The function picks a provider (`LAB_AI_PROVIDER` secret: `gemini` default, `openrouter`, or `anthropic`), returns a fixed JSON shape (`LabAiResult`), and the app shows it in `lab_ai_result_sheet.dart` (with a red-flag escalation banner + medical disclaimer). One-time consent is stored in SharedPreferences (`LabAiConsent`). Offline/unconfigured → falls back to the on-device threshold view.

## Key design decisions

- **Offline-first, backend-optional.** `AppConfig` reads `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `POWERSYNC_URL` from `--dart-define`. Empty keys → services no-op; the app runs on local SQLite alone. This is why every cloud call is guarded by `isReady`/`isConfigured`.
- **Config at build time**, not runtime: `flutter run --dart-define-from-file=env.json` (template `env.example.json`).
- **Localization is mandatory** for user-facing text. ARB files in `lib/l10n/` (`app_en.arb` is the template per `l10n.yaml`, plus `app_fr.arb`, `app_ar.arb`). `AppLocalizations` is **generated** by `flutter gen-l10n`.
- **Enums stored in English, localized for display.** DB columns like `feeding_type`, `severity`, `trimester`, `mood` store canonical English/keys; the UI maps them to translated labels. (e.g. `MoodModel` stores `very_happy`, shows `l10n.veryHappy`.) This keeps stored data language-stable.
- **Versioned schema with self-healing migrations.** `DatabaseHelper.schemaVersion` is the single source of truth; each `oldVersion < N` step uses the safe pattern **`CREATE TABLE IF NOT EXISTS` + PRAGMA-checked `ALTER`** so a device in any prior state upgrades without crashing. This exists because an earlier bare `ALTER` bricked installs (see `test/core/database/db_migration_test.dart`).
- **AI key never in the client.** All model calls go through the Edge Function.

## Critical paths (touch carefully)

- **`lib/core/database/db_helper.dart`** — schema + migrations. Load-bearing. A wrong migration bricks every DB call. Always bump `schemaVersion` and add a guarded migration step; never edit an old step.
- **`lib/core/config/app_config.dart`** — the wiring switch for all cloud features.
- **`lib/l10n/*.arb`** — three files must stay in key parity; regen after edits or the build breaks.
- **`lib/features/dashboard/presentation/pages/dashboard_page.dart`** — the shell; owns tab state and the navbar.
- **`lib/features/auth/data/models/auth_repo_impl.dart`** — dual-mode auth; changing it affects sessions, sync, and the mirrored `users` table.
- **`lib/core/services/supabase_service.dart` / `powersync_service.dart`** — cloud lifecycle.

**Safe to change casually:** individual presentation widgets and tab-content files (`features/*/presentation/widgets/*`), colors/spacing, copy (as long as you add l10n keys).

## Surprising / non-obvious things

1. **The repo root Flutter project is `gestanea/`** inside `D:\Desktop\Gestanea\`. Run everything from `gestanea/`.
2. **Two SQLite databases exist** (`gestanea.db` = real data via DatabaseHelper; `gestanea_powersync.db` = sync, currently unused by features). Always use `DatabaseHelper.instance` for app data.
3. **`lib/features/health_analysis/` is dead** — a duplicate/older `HealthBloc` feature not referenced anywhere. The live health feature is `lib/features/health/`.
4. **Auth is dual-mode** — don't assume "local only." When Supabase is configured, real sessions exist and profiles are mirrored into `users`.
5. **The bottom navbar is forced LTR** (`Directionality(textDirection: ltr)` in `navbar.dart`) because its notch/floating-circle are positioned with left-edge index math that would mis-align in Arabic. Side tab-bars (health/marketplace) *do* mirror in RTL — that's intended.
6. **`auth_repo_impl.dart` hand-rolls a UUID** (`_uuid()`) even though the `uuid` package is a dependency (see GAPS).
7. **`current_user` string literals** still appear in a few lab/symptom/measurement dialogs; they're now harmless because the blocs stamp the real `user_id` on insert, but they're misleading.
8. **AI lab analysis is deployed and working** against Supabase project `clreowcinwmwajzlysem`; it just needs a provider key set (Gemini free tier is region-blocked for the owner's Google account, so the plan is a free **OpenRouter** key).
