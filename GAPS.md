# GAPS — honest audit

Ordered most-severe first. Each: what, where, why it matters, and a small fix.

> **Status 2026-06:** #2 (install-id rate limiting), #3 (v8/v9 migration tests), #4 (dead feature deleted), #6 (`current_user` literals), #7 (real UUID), #10 (README note), and the doc-drift items of #11 are ✅ implemented. #2's function redeploy is pending the Supabase project being resumed. #1 (sync data plane), #5 (OCR limits), #8 (image backup), #9 (region constants) remain open.

---

## 1. [HIGH] PowerSync sync is wired but its data plane was never migrated — sync is inert
**What:** The sync stack (`PowerSyncService`, `SupabaseConnector`, `powerSyncSchema`) opens a *separate* DB `gestanea_powersync.db` and can connect to Supabase, but **no feature reads or writes it**. All 19 DB-touching files use `DatabaseHelper.instance` → `gestanea.db`. So even fully configured + signed in, nothing actually syncs.
**Where:** `lib/core/sync/*` (built) vs. every `lib/features/*/data/datasources/*` and health blocs (use `DatabaseHelper`).
**Why it matters:** Reinstall = data loss; no multi-device. Anyone reading the code assumes sync works. It's a large half-finished abstraction.
**Fix (small, incremental):** Pick ONE table (e.g. `measurements`). Route just that table's reads/writes through `PowerSyncService.instance.db` when `isReady`, else `DatabaseHelper`. Verify a row round-trips to Supabase. Repeat per table later. OR (smaller) add a one-line doc comment at the top of `powersync_service.dart` stating "not yet used by feature code" so no one is misled.

## 2. [HIGH / SECURITY] `analyze-lab` is callable by anyone with the shippable anon key
**What:** The Edge Function accepts the anon key and falls back to `userId="anonymous"` (needed because offline users have no Supabase session). The daily rate limit then buckets all anonymous callers together, and the anon key ships inside the APK (extractable).
**Where:** `supabase/functions/analyze-lab/index.ts` (auth block + rate-limit block).
**Why it matters:** Cost abuse — a scraper with the anon key can burn the AI provider quota/bill.
**Fix (small):** (a) Lower `LAB_AI_DAILY_LIMIT`; (b) have the Flutter client send a stable per-install id (e.g. a UUID persisted in SharedPreferences) in the body and rate-limit on that instead of `"anonymous"`; (c) longer term, require a real Supabase session and drop the anonymous path once auth is Supabase-only.

## 3. [MEDIUM] Test coverage is minimal; newest migrations lack explicit assertions
**What:** Only 4 test files. `db_migration_test.dart` asserts **only the v7 salt migration**; v8 (moods `energy_level`/`sleep_quality`) and v9 (pregnancies `pre_pregnancy_weight`/`height_cm`) are exercised transitively but have no assertions of their own. No bloc tests, no auth tests, no repository tests.
**Where:** `test/core/database/db_migration_test.dart`; missing coverage across `lib/features/*/logic/*`.
**Why it matters:** Migrations are the most dangerous code in the app. **Proof:** this suite caught a real bug (2026-06) — the v9 step bare-`ALTER`ed `pregnancies` without a table-existence guard and crashed on minimal fixtures ("no such table"); it has been fixed to the self-healing pattern (`CREATE TABLE IF NOT EXISTS` + PRAGMA check) and all 13 tests pass again. But without explicit v8/v9 assertions, a silent regression (e.g. a column quietly not added) would still slip through.
**Fix (small, single task):** Add tests to `db_migration_test.dart`: open a v7 fixture, run `upgradeSchema(db, 7, schemaVersion)`, assert `moods` has `energy_level`/`sleep_quality` and `pregnancies` has `pre_pregnancy_weight`/`height_cm`; assert idempotency on re-run; include a fixture that lacks the `pregnancies` table entirely.

## 4. [MEDIUM] Dead duplicate feature: `health_analysis`
**What:** `lib/features/health_analysis/` (datasource, `HealthBloc`, page, widget) duplicates the live `health` feature and is referenced nowhere.
**Where:** `lib/features/health_analysis/**` (4 files).
**Why it matters:** Confuses navigation ("which health bloc?"), rots, inflates the codebase.
**Fix (small):** Confirm zero imports (`grep -r health_analysis lib`), then delete the directory.

## 5. [MEDIUM] Brittle OCR parser silently mis-reads real reports
**What:** `parseLabResults` is regex-on-OCR-text. It only captures the first number after a known label on the same line and knows ~6 tests. Real multi-column lab layouts frequently don't match.
**Where:** `lib/core/services/ocr_service.dart`.
**Why it matters:** Users see missing/blank extracted values; it's the free path when AI isn't deployed.
**Fix (small):** It's inherently limited — the real answer is the AI extraction path. Add a code comment + a UI hint that on-device extraction is best-effort and "Analyze with AI" is the accurate path. Optionally broaden the label list.

## 6. [MEDIUM] `current_user` string literals in insert paths
**What:** Five files still build models with `userId: 'current_user'`. Harmless today because `MeasurementsBloc`/`SymptomsBloc`/`LabResultsBloc` overwrite `user_id` via `copyWith(userId: ...)` on insert — but it's misleading and a trap if someone bypasses the bloc.
**Where:** `manual_lab_entry_page.dart`, `ocr_extraction_page.dart`, `pdf_extraction_page.dart`, `dialogs/add_measurment_dialog.dart`, `dialogs/add_symptom_dialog.dart` (all under `lib/features/health/presentation/`).
**Why it matters:** A future insert that doesn't route through the stamping bloc would write cross-user rows.
**Fix (small):** Replace the literal with the real id from `context.read<AuthBloc>()`, or add a `// stamped by the bloc` comment at each site.

## 7. [LOW] Hand-rolled UUID in auth
**What:** `AuthRepositoryImpl._uuid()` builds a UUID-ish string by hand while `uuid: ^4.5.2` is already a dependency. Not RFC-4122-correct; higher collision risk; only used on the offline signup path.
**Where:** `lib/features/auth/data/models/auth_repo_impl.dart` (bottom).
**Why it matters:** Offline account ids could theoretically collide / are non-standard.
**Fix (small):** `import 'package:uuid/uuid.dart';` and replace `_uuid()` with `const Uuid().v4()`.

## 8. [LOW] Lab images are device-local only
**What:** `ImageStorageService` saves lab photos to app documents; they aren't uploaded/backed up, and the ZIP export is the only way out.
**Where:** `lib/core/services/image_storage_service.dart`, `lib/features/health/logic/bloc/lab_results_bloc.dart`.
**Why it matters:** Reinstall loses images; no multi-device. (Same root cause as #1.)
**Fix (later, larger):** Upload to Supabase Storage with local cache. Not a one-shot task; note it.

## 9. [LOW] Region-specific constants hardcoded
**What:** Emergency number `115` and Algeria assumptions are constants, not config.
**Where:** `kEmergencyNumber` in `lib/features/health/presentation/widgets/risk_alerts_tab_content.dart`.
**Why it matters:** Wrong number outside Algeria.
**Fix (small):** Acceptable for now (single-region app). If internationalizing, move to config/locale.

## 10. [LOW] `supabase/migrations` may conflict with `supabase db push`
**What:** `20260607000000_init_schema.sql` recreates the full Postgres schema. If the linked project already has those tables, `supabase db push` errors. The AI deploy deliberately avoided `db push` (function works without the `ai_lab_usage` table thanks to best-effort try/catch).
**Where:** `supabase/migrations/*`.
**Why it matters:** A naive `supabase db push` on a populated project fails confusingly.
**Fix (small):** Document in `supabase/functions/analyze-lab/README.md` that the rate-limit table can be created by pasting `20260616000000_ai_lab_usage.sql` into the dashboard SQL editor instead of `db push`.

## 11. [LOW] Inconsistencies / misc debt
- **README architecture drift:** `README.md` says "Clean Architecture + Riverpod" — the app actually uses `flutter_bloc` everywhere. A new contributor following the README would add the wrong package. Fix: correct the README section (single-line edit).
- **Auth doc-comment drift:** `LabAiService`/`lab_ai_result_sheet.dart` comments still say "Claude"/"user's Supabase session" though the provider is now Gemini/OpenRouter-first and auth is anon. Harmless; update wording when convenient.
- **~11 TODOs** across `lib` (e.g. baby gender extraction in `dashboard_page.dart`). None critical.
- **BMI "expected gain"** (`bmi_card.dart`) is a rough linear heuristic, not a clinical curve — labeled "expected" but approximate.
- **Two "health" trees** (`health`, `health_analysis`) — see #4.
- **Naming:** dialogs folder has `add_measurment_dialog.dart` (typo "measurment") — cosmetic; renaming touches imports, low priority.
