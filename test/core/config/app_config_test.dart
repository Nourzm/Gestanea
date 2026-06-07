import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/config/app_config.dart';

void main() {
  group('AppConfig defaults', () {
    test('supabaseUrl points at the seeded project ref by default', () {
      // The build-time default. CI / device runs override via
      // --dart-define-from-file=env.json.
      expect(AppConfig.supabaseUrl, contains('supabase.co'));
    });

    test('isSupabaseConfigured is false without an anon key', () {
      // No --dart-define present in the test runner, so the empty default
      // is what we see here. The point is to encode that an empty anon
      // key disables Supabase (graceful offline fallback).
      expect(AppConfig.supabaseAnonKey, isEmpty);
      expect(AppConfig.isSupabaseConfigured, isFalse);
    });

    test('isPowerSyncConfigured is false without a sync URL', () {
      expect(AppConfig.powerSyncUrl, isEmpty);
      expect(AppConfig.isPowerSyncConfigured, isFalse);
    });
  });
}
