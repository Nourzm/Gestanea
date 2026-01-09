import 'package:gestanea/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for Supabase authentication
class AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSource() : _client = SupabaseConfig.client;

  /// Send OTP code to email
  Future<void> sendOtp(String email) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null, // No redirect, code-based only
      );
    } on AuthException catch (e) {
      throw Exception('Failed to send OTP: ${e.message}');
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  /// Verify OTP code and return authenticated user
  Future<User> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );

      if (response.user == null) {
        throw Exception('Verification failed: No user returned');
      }

      return response.user!;
    } on AuthException catch (e) {
      throw Exception('OTP verification failed: ${e.message}');
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  /// Sign out from Supabase
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      // Ignore sign out errors
    }
  }
}
