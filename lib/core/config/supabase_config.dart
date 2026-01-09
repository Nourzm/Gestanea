import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration and client initialization
class SupabaseConfig {
  static const String _supabaseUrl = 'https://clreowcinwmwajzlysem.supabase.co';
  static const String _supabaseAnonKey = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNscmVvd2Npbndtd2Fqemx5c2VtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY5NTE1MzUsImV4cCI6MjA4MjUyNzUzNX0.s7PlvAcS7h2MAV2UUxea6DXlrNj3OeaPaN5cTL_OGRs';

  /// Initialize Supabase client
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
}
