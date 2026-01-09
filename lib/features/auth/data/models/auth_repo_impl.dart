import 'package:gestanea/core/database/models/user_model.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gestanea/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';
import 'package:uuid/uuid.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final SessionManager sessionManager;
  final ConnectivityService connectivityService;
  final Uuid _uuid = const Uuid();

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.sessionManager,
    required this.connectivityService,
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
    await remoteDataSource.signOut();
    await sessionManager.clearSession();
  }

  @override
  Future<void> sendOtp(String email) async {
    // Check connectivity before attempting remote operation
    if (!connectivityService.isOnline) {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    }

    await remoteDataSource.sendOtp(email);
  }

  @override
  Future<UserEntity> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    // Check connectivity before attempting remote operation
    if (!connectivityService.isOnline) {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    }

    // Verify OTP with Supabase
    final supabaseUser = await remoteDataSource.verifyOtp(
      email: email,
      token: otpCode,
    );

    // Check if user already exists locally
    UserModel? existingUser = await localDataSource.getUserByEmail(email);

    if (existingUser != null) {
      // User exists - just log them in
      await sessionManager.saveCurrentUserId(existingUser.id);
      return UserEntity.fromModel(existingUser);
    }

    // New user - create local record using Supabase UUID
    final now = DateTime.now();
    final userModel = UserModel(
      id: supabaseUser.id, // Use Supabase UUID
      email: email,
      name: email.split('@').first, // Default name from email
      phone: null,
      country: null,
      language: null,
      theme: null,
      notificationsEnabled: true,
      createdAt: now,
      updatedAt: now,
    );

    // Insert user into local database (no password needed for OTP users)
    await localDataSource.createUser(userModel);
    await sessionManager.saveCurrentUserId(userModel.id);

    return UserEntity.fromModel(userModel);
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
