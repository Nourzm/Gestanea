import 'package:gestanea/features/auth/data/models/user_entity.dart';

abstract class AuthRepository {
  /// Sign up (create user + credentials). Returns created user.
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  /// Login with email and password.
  Future<UserEntity> login({required String email, required String password});

  /// Get currently logged in user (or null).
  Future<UserEntity?> getCurrentUser();

  Future<UserEntity> updateUser(UserEntity user);

  /// Send OTP code to email using Supabase
  Future<void> sendOtp(String email);

  /// Verify OTP code and create/authenticate user
  Future<UserEntity> verifyOtp({
    required String email,
    required String otpCode,
  });

  /// Complete onboarding by saving user profile to Supabase users table
  Future<UserEntity> completeOnboarding({
    required String name,
    String? phone,
    String? country,
    String? language,
  });

  /// Logout current user.
  Future<void> logout();

  /// Send password reset email.
  Future<void> sendPasswordReset({required String email});

  /// Change user password (requires current password verification).
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
