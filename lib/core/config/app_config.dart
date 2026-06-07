/// Runtime configuration injected at build time via `--dart-define`.
///
/// Keep all environment-dependent secrets and URLs in this single file so a
/// fresh checkout can be wired up by passing the right flags (or by editing
/// the defaults during local development).
///
/// Recommended build invocation:
///   flutter run --dart-define-from-file=env.json
///
/// Where env.json looks like:
///   {
///     "SUPABASE_URL": "https://<project_ref>.supabase.co",
///     "SUPABASE_ANON_KEY": "<publishable anon key>",
///     "POWERSYNC_URL": "https://<instance>.powersync.journeyapps.com"
///   }
class AppConfig {
  AppConfig._();

  /// Supabase project URL. Derived from the project_ref already wired in
  /// `.mcp.json` (clreowcinwmwajzlysem). Override per environment.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://clreowcinwmwajzlysem.supabase.co',
  );

  /// Supabase anon / publishable key. **Required** — there is no safe
  /// default. Build will run but every Supabase call will fail with 401
  /// until this is supplied.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// PowerSync instance URL. Empty = sync disabled, app runs purely local.
  static const String powerSyncUrl = String.fromEnvironment(
    'POWERSYNC_URL',
    defaultValue: '',
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isPowerSyncConfigured => powerSyncUrl.isNotEmpty;
}
