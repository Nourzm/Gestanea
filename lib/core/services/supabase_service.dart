import 'package:flutter/foundation.dart';
import 'package:gestanea/core/config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around `Supabase.instance.client` so feature code can be
/// written against a single, mockable surface (and so we can skip
/// initialization gracefully when no anon key is configured — useful for
/// running the app fully offline during development).
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  bool _initialized = false;

  /// Idempotent; safe to call from main() and again from any feature.
  /// Returns true if Supabase was actually wired up.
  Future<bool> init() async {
    if (_initialized) return true;
    if (!AppConfig.isSupabaseConfigured) {
      debugPrint(
        'SupabaseService: SUPABASE_ANON_KEY not configured — '
        'running in fully offline mode.',
      );
      return false;
    }
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _initialized = true;
    return true;
  }

  bool get isReady => _initialized;

  SupabaseClient get client => Supabase.instance.client;

  GoTrueClient get auth => client.auth;

  Session? get currentSession =>
      _initialized ? client.auth.currentSession : null;

  User? get currentUser => _initialized ? client.auth.currentUser : null;
}
