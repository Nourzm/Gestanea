import 'package:gestanea/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSource() : _client = SupabaseConfig.client;

  void _log(String msg) => print('[AuthRemote] $msg');

  /// Sign up new user with OTP (NO MAGIC LINKS!)
  Future<String> signUpWithOtp({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    _log('signUpWithOtp start email=$email name=$name');
    try {
      // Defensive: check our profiles table first to avoid sending OTP to existing users.
      // If RLS hides rows, this may return null even for existing users; in that case
      // Supabase Auth below will still throw "User already registered".
      final existingProfile = await _client
          .from('users')
          .select('id')
          .eq('email', email)
          .maybeSingle();
      print(existingProfile);

      if (existingProfile != null) {
        _log('users table already has $email -> account exists');
        throw AuthException('User already registered');
      }

      // Auth-level check: probe login with a guaranteed-wrong password.
      // If Supabase says invalid credentials / already registered, treat as existing user.
      // try {
      //   await _client.auth.signInWithPassword(
      //     email: email,
      //     password: '__INVALID__PROBE__PASSWORD__',
      //   );
      //   _log('probe login succeeded unexpectedly -> marking as existing');
      //   throw AuthException('User already registered');
      // } on AuthException catch (e) {
      //   final msg = e.message.toLowerCase();
      //   print(msg);
      //   if (msg.contains('invalid login credentials') ||
      //       msg.contains('email not confirmed') ||
      //       msg.contains('already registered') ||
      //       msg.contains('already exists')) {
      //     _log('auth probe indicates existing account for $email');
      //     throw AuthException('User already registered');
      //   }
      //   _log('auth probe inconclusive for $email, continuing signup');
      // }

      // Rely on Supabase Auth to enforce uniqueness for new accounts.
      await _client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        emailRedirectTo: null,
        data: {
          'name': name,
          'phone': phone,
          'password_hash': password, // Store for later password login
        },
      );
      _log('OTP sent for $email');

      return email;
    } on AuthException catch (e) {
      // Check if user already exists in auth.users
      if (e.message.contains('User already registered') ||
          e.message.contains('already registered') ||
          e.message.contains('already exists')) {
        _log('Supabase reports already registered for $email');
        throw AuthException('User already registered');
      }
      _log('AuthException signUpWithOtp $email: ${e.message}');
      throw e;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        _log('Postgres duplicate for $email');
        throw AuthException('User already registered');
      }
      _log('PostgrestException signUpWithOtp $email: ${e.message}');
      throw e;
    }
  }

  /// Send OTP to existing or new user (for login flow)
  Future<void> sendOtp(String email) async {
    _log('sendOtp email=$email');
    // Explicitly disable magic links by setting emailRedirectTo to null
    await _client.auth.signInWithOtp(
      email: email,
      shouldCreateUser: true, // Allow creating new users via OTP
      emailRedirectTo: null, // Explicitly disable magic links
    );
  }

  /// Verify OTP (pure OTP, no password required)
  Future<User> verifyOtp({required String email, required String token}) async {
    _log('verifyOtp email=$email token=$token');
    try {
      // Verify OTP
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );

      if (response.user == null) {
        _log('verifyOtp failed: null user for $email');
        throw AuthException('Verification failed');
      }

      _log('verifyOtp success for $email');
      return response.user!;
    } on AuthException catch (e) {
      _log('verifyOtp AuthException $email: ${e.message}');
      throw e;
    }
  }

  /// Verify OTP and set password (for backward compatibility)
  Future<User> verifyOtpAndSetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    _log('verifyOtpAndSetPassword email=$email token=$token');
    try {
      // Verify OTP
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );

      if (response.user == null) {
        _log('verifyOtpAndSetPassword failed: null user for $email');
        throw AuthException('Verification failed');
      }

      // Set password so user can login with password later
      if (password.isNotEmpty) {
        _log('update password after OTP for $email');
        await _client.auth.updateUser(UserAttributes(password: password));
      }

      _log('verifyOtpAndSetPassword success for $email');
      return response.user!;
    } on AuthException catch (e) {
      _log('verifyOtpAndSetPassword AuthException $email: ${e.message}');
      throw e;
    }
  }

  /// Sign in with password
  Future<User> signInWithPassword({
    required String email,
    required String password,
  }) async {
    _log('signInWithPassword email=$email');
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      _log('signInWithPassword returned null user for $email');
      throw AuthException('Login failed');
    }

    _log('signInWithPassword success for $email userId=${response.user!.id}');
    return response.user!;
  }

  /// Upsert user profile
  Future<Map<String, dynamic>> upsertUserProfile({
    required String id,
    required String email,
    required String name,
    String? phone,
    String? country,
    String? language,
    String? theme,
    bool notificationsEnabled = true,
    String? profilePictureUrl,
  }) async {
    final notifValue = notificationsEnabled ? 1 : 0;
    final response = await _client
        .from('users')
        .upsert({
          'id': id,
          'email': email,
          'name': name,
          'phone': phone,
          'country': country,
          'language': language,
          'theme': theme,
          'notifications_enabled': notifValue,
          'profile_picture_url': profilePictureUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .maybeSingle();

    _log(
      'upsertUserProfile id=$id email=$email -> ${response?['id'] ?? 'null'}',
    );
    return response ?? {};
  }

  /// Send password reset email (Supabase built-in)
  Future<void> sendPasswordResetEmail({
    required String email,
    String? redirectUrl,
  }) async {
    _log('sendPasswordResetEmail email=$email');
    await _client.auth.resetPasswordForEmail(email, redirectTo: redirectUrl);
  }

  /// Update user password (requires authentication)
  /// Verifies current password by attempting to re-authenticate
  Future<void> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    _log('updatePassword email=$email');
    
    // First verify current password by attempting to sign in
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: currentPassword,
      );
    } catch (e) {
      _log('updatePassword: Current password verification failed');
      throw AuthException('Current password is incorrect');
    }

    // If verification succeeds, update password
    await _client.auth.updateUser(UserAttributes(password: newPassword));
    _log('updatePassword: Password updated successfully');
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String id) async {
    _log('getUserProfile id=$id');
    return await _client.from('users').select().eq('id', id).maybeSingle();
  }

  /// Sign out
  Future<void> signOut() async {
    _log('signOut');
    await _client.auth.signOut();
  }
}
