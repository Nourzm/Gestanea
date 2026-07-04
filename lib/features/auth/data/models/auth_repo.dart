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

  /// Logout current user.
  Future<void> logout();
}
