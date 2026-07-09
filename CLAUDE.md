# CLAUDE.md — Gestanéa

Flutter pregnancy/baby-care app. **Offline-first**, 3 languages (en/fr/ar, ar is RTL), purple brand.
Architecture & narrative: **[PROJECT.md](PROJECT.md)**. Known problems, ordered by severity: **[GAPS.md](GAPS.md)**.

## Commands (run from this folder, `gestanea/`)

```bash
flutter analyze lib            # must be clean before you're done
flutter test                   # 13 tests; must pass, esp. db_migration_test
dart format lib                # formatter is the style authority
flutter gen-l10n               # REQUIRED after editing any lib/l10n/*.arb
flutter run --dart-define-from-file=env.json    # env.example.json is the template
dart run flutter_launcher_icons                 # only when app icon changes
```

- **Windows build gotcha:** `flutter build apk` can fail with "Unable to establish loopback connection" (JDK temp-dir bug). Fix: `TMP='D:\tmp' TEMP='D:\tmp' JAVA_TOOL_OPTIONS='-Djava.io.tmpdir=D:\tmp' flutter build apk`.
- Deploy of the AI Edge Function: see `supabase/functions/analyze-lab/README.md` (Supabase CLI is at `D:\tools\supabase\supabase.exe`, project ref `clreowcinwmwajzlysem`).

## Conventions

- **State:** `flutter_bloc` only (Bloc or Cubit per feature). No Riverpod/Provider-for-state — the README's "Riverpod" claim is stale.
- **Layout:** feature-first. `lib/features/<name>/{data,logic,presentation}/`. Shared code in `lib/core/`. DB models in `lib/core/database/models/` with `toMap()/fromMap()/copyWith()`.
- **Data access:** everything goes through `DatabaseHelper.instance.database` (sqflite, `gestanea.db`). Queries that touch user data MUST filter `where: 'user_id = ?'`; blocs stamp the real owner on insert via `copyWith(userId: userId)`.
- **Current user id:** `context.read<AuthBloc>().state` → `AuthAuthenticated.user.id` (fallback `'0'`). Never invent another source.
- **Localization:** every user-facing string is an `AppLocalizations` key. Add to **all three** ARBs (`app_en.arb` is the template; `en` carries `@key` placeholder metadata), then `flutter gen-l10n`. Never hardcode UI text; never store localized text in the DB — store canonical English/keys (e.g. mood `very_happy`) and map to labels at display time.
- **Dates:** `DateFormat('…', Localizations.localeOf(context).languageCode)` for locale-aware display.
- **Cloud calls:** always guarded — `SupabaseService.instance.isReady`, `AppConfig.isSupabaseConfigured`, etc. The app must keep working with no backend at all.
- **const traps:** inserting `l10n.someKey` into a `const` widget tree causes `invalid_constant`. Remove `const` from the parent, re-add to inner literal children.

## Rules — do not break these

1. **`lib/core/database/db_helper.dart` migrations:** to change schema, bump `schemaVersion`, add a NEW `if (oldVersion < N)` block using the self-healing pattern (`CREATE TABLE IF NOT EXISTS` + PRAGMA column check before `ALTER`). Never edit an old block; never bare-`ALTER` (a missing table returns an empty PRAGMA list and the ALTER bricks the upgrade — this bug has happened twice). Mirror new columns in the model class AND `lib/core/sync/powersync_schema.dart`. Run `flutter test test/core/database/`.
2. **`lib/l10n/app_localizations*.dart` are GENERATED** — never edit by hand; edit ARBs and regen. The three ARBs must stay in key parity.
3. **`FancyNavBar` (`features/dashboard/presentation/widgets/navbar.dart`) is intentionally wrapped in `Directionality(ltr)`** — its notch/circle use left-edge index math. Don't "fix" that for RTL; side tab-bars mirroring in Arabic is correct behavior. The owner is sensitive about this widget's look — don't restyle it unasked.
4. **Never put an AI/API key in Flutter code.** Model calls go through `supabase/functions/analyze-lab/` (provider switchable via `LAB_AI_PROVIDER` secret: gemini | openrouter | anthropic). Client and function must keep the same result JSON shape (`LabAiResult`).
5. **Auth is dual-mode** (`auth_repo_impl.dart`): Supabase when configured, salted-bcrypt local otherwise. Password hashes are `$2…` bcrypt; don't weaken, don't log credentials.
6. **Git:** never add Claude co-author lines or "Generated with Claude" to commits/PRs. Repo: `github.com/Nourzm/Gestanea`, work happens on feature branches (currently `feat/supabase-sync-and-auth`).
7. **`patches/flutter_inset_box_shadow/`** is a vendored dependency override — don't touch unless fixing that package.

## Gotchas

- **PowerSync sync is inert**: `lib/core/sync/*` is fully built but no feature uses its DB — everything reads/writes `gestanea.db`. Don't assume data syncs (GAPS #1).
- **`lib/features/health_analysis/` is DEAD code** (zero external imports). The live feature is `lib/features/health/`. Don't extend the dead one.
- **Two DBs on device:** `gestanea.db` (real) and `gestanea_powersync.db` (unused). Use `DatabaseHelper.instance`.
- **`userId: 'current_user'` literals** in some health dialogs are harmless (blocs overwrite on insert) but never copy that pattern to a new insert path.
- **`supabase db push` may fail** against the live project (init migration recreates existing tables). The Edge Function deliberately works without its rate-limit table (best-effort try/catch); create `ai_lab_usage` via the dashboard SQL editor if needed.
- **AI button needs**: function deployed + a provider key secret + app built with a real `SUPABASE_ANON_KEY` dart-define. Otherwise it falls back with a "needs connection" snackbar — that's by design, not a bug.
- **Emergency number** is `kEmergencyNumber = '115'` (Algeria SAMU) in `risk_alerts_tab_content.dart` — regional by intent.
- App runs from `gestanea/` inside `D:\Desktop\Gestanea\` — don't run flutter commands from the outer folder.
