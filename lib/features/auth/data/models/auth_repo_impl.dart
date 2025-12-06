import 'package:gestanea/core/database/models/user_model.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';
import 'package:uuid/uuid.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final SessionManager sessionManager;
  final Uuid _uuid = const Uuid();

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.sessionManager,
  });

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final exists = await localDataSource.emailExists(email);
    if (exists) {
      throw Exception('Email already in use');
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    final userModel = UserModel(
      id: id,
      email: email,
      name: name,
      phone: phone,
      country: null,
      language: null,
      theme: null,
      notificationsEnabled: true,
      createdAt: now,
      updatedAt: now,
    );

    await localDataSource.createUserWithPassword(
      user: userModel,
      password: password,
    );

    await sessionManager.saveCurrentUserId(id);

    return UserEntity.fromModel(userModel);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final userModel = await localDataSource.getUserByEmailAndPassword(
      email,
      password,
    );
    if (userModel == null) {
      throw Exception('Invalid credentials');
    }
    await sessionManager.saveCurrentUserId(userModel.id);
    return UserEntity.fromModel(userModel);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final id = await sessionManager.getCurrentUserId();
    if (id == null) return null;
    final userModel = await localDataSource.getUserById(id);
    if (userModel == null) return null;
    return UserEntity.fromModel(userModel);
  }

  @override
  Future<void> logout() async {
    await sessionManager.clearSession();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    // Ensure the user exists
    final existing = await localDataSource.getUserById(user.id);
    if (existing == null) {
      throw Exception('User not found');
    }

    final updatedAt = DateTime.now();

    // Build updated model preserving createdAt
    final updatedModel = UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      country: user.country,
      language: user.language,
      theme: user.theme,
      notificationsEnabled: user.notificationsEnabled,
      createdAt: existing.createdAt,
      updatedAt: updatedAt,
    );

    // Persist update
    await localDataSource.updateUser(updatedModel);

    // Re-read from DB to ensure what we return matches stored values (and parsing)
    final reloaded = await localDataSource.getUserById(user.id);
    if (reloaded == null) {
      throw Exception('Failed to load updated user');
    }

    return UserEntity.fromModel(reloaded);
  }
}
