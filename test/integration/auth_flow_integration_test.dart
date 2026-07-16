import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';

// Mock repository for integration testing
class MockAuthRepository implements AuthRepository {
  final Map<String, UserEntity> _users = {};
  UserEntity? _currentUser;

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (_users.containsKey(email)) {
      throw Exception('Email already exists');
    }

    if (password.length < 6) {
      throw Exception('Password too short');
    }

    final user = UserEntity(
      id: 'user_${_users.length + 1}',
      email: email,
      name: name,
      phone: phone,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _users[email] = user;
    _currentUser = user;

    return user;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_users.containsKey(email)) {
      throw Exception('User not found');
    }

    if (password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    _currentUser = _users[email];
    return _currentUser!;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _currentUser;
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    final updatedUser = UserEntity(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      country: user.country,
      language: user.language,
      theme: user.theme,
      notificationsEnabled: user.notificationsEnabled,
      createdAt: _currentUser!.createdAt,
      updatedAt: DateTime.now(),
    );

    _users[user.email] = updatedUser;
    _currentUser = updatedUser;

    return updatedUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _currentUser = null;
  }

  @override
  Future<void> sendOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Simulate sending OTP - in mock, we just validate the email
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Invalid email');
    }
  }

  @override
  Future<UserEntity> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // For testing, accept any 6-digit code
    if (otpCode.length != 6) {
      throw Exception('Invalid OTP code');
    }

    // Return existing user or create a basic one
    if (_users.containsKey(email)) {
      _currentUser = _users[email];
      return _currentUser!;
    }

    final user = UserEntity(
      id: 'user_${_users.length + 1}',
      email: email,
      name: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _users[email] = user;
    _currentUser = user;
    return user;
  }

  @override
  Future<UserEntity> completeOnboarding({
    required String name,
    String? phone,
    String? country,
    String? language,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    final updatedUser = UserEntity(
      id: _currentUser!.id,
      email: _currentUser!.email,
      name: name,
      phone: phone,
      country: country,
      language: language,
      createdAt: _currentUser!.createdAt,
      updatedAt: DateTime.now(),
    );

    _users[_currentUser!.email] = updatedUser;
    _currentUser = updatedUser;

    return updatedUser;
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_users.containsKey(email)) {
      throw Exception('User not found');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    if (newPassword.length < 6) {
      throw Exception('Password too short');
    }

    // In a real implementation, we'd verify currentPassword
    // For mock purposes, we just accept it
  }

  // Test helper methods
  void reset() {
    _users.clear();
    _currentUser = null;
  }

  bool get hasCurrentUser => _currentUser != null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    late MockAuthRepository mockRepository;
    late AuthBloc authBloc;

    setUp(() {
      mockRepository = MockAuthRepository();
      authBloc = AuthBloc(repository: mockRepository);
    });

    tearDown(() {
      authBloc.close();
      mockRepository.reset();
    });

    test('Complete signup flow', () async {
      // Start signup
      authBloc.add(
        SignUpRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          phone: '+1234567890',
        ),
      );

      // Wait for loading state
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          anyOf(isA<OtpSent>(), isA<AuthAuthenticated>()),
        ]),
      );

      expect(mockRepository.hasCurrentUser, true);
    });

    test('Signup with existing email fails', () async {
      // First signup
      authBloc.add(
        SignUpRequested(
          name: 'User One',
          email: 'duplicate@example.com',
          password: 'password123',
        ),
      );

      await authBloc.stream.first;
      await authBloc.stream.first;

      // Try to signup again with same email
      final secondBloc = AuthBloc(repository: mockRepository);
      secondBloc.add(
        SignUpRequested(
          name: 'User Two',
          email: 'duplicate@example.com',
          password: 'password456',
        ),
      );

      await expectLater(
        secondBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'error',
            contains('already exists'),
          ),
          isA<AuthUnauthenticated>(),
        ]),
      );

      secondBloc.close();
    });

    test('Signup with short password fails', () async {
      authBloc.add(
        SignUpRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: '123', // Too short
        ),
      );

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'error',
            contains('too short'),
          ),
          isA<AuthUnauthenticated>(),
        ]),
      );
    });

    test('Complete login flow', () async {
      // First create a user
      await mockRepository.signUp(
        name: 'Test User',
        email: 'login@example.com',
        password: 'password123',
      );
      await mockRepository.logout();

      // Now login
      authBloc.add(
        LoginRequested(email: 'login@example.com', password: 'password123'),
      );

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthAuthenticated>().having(
            (s) => s.user.email,
            'email',
            'login@example.com',
          ),
        ]),
      );
    });

    test('Login with invalid credentials fails', () async {
      authBloc.add(
        LoginRequested(
          email: 'nonexistent@example.com',
          password: 'wrongpassword',
        ),
      );

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'error',
            contains('not found'),
          ),
          isA<AuthUnauthenticated>(),
        ]),
      );
    });

    test('Complete logout flow', () async {
      // Setup: Login first
      await mockRepository.signUp(
        name: 'Test User',
        email: 'logout@example.com',
        password: 'password123',
      );

      // Logout
      authBloc.add(LogoutRequested());

      await expectLater(
        authBloc.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthUnauthenticated>()]),
      );

      expect(mockRepository.hasCurrentUser, false);
    });

    test('Update profile flow', () async {
      // Setup: Create and login user
      await mockRepository.signUp(
        name: 'Original Name',
        email: 'update@example.com',
        password: 'password123',
      );

      // Update profile
      authBloc.add(
        UpdateProfileRequested(
          id: mockRepository._currentUser!.id,
          email: 'update@example.com',
          name: 'Updated Name',
          phone: '+9876543210',
          country: 'Algeria',
        ),
      );

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthAuthenticated>()
              .having((s) => s.user.name, 'name', 'Updated Name')
              .having((s) => s.user.phone, 'phone', '+9876543210')
              .having((s) => s.user.country, 'country', 'Algeria'),
        ]),
      );
    });

    test('App startup with existing session', () async {
      // Setup: Create a logged-in user
      await mockRepository.signUp(
        name: 'Existing User',
        email: 'existing@example.com',
        password: 'password123',
      );

      // Create new bloc and check app startup
      final newBloc = AuthBloc(repository: mockRepository);
      newBloc.add(AppStarted());

      await expectLater(
        newBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthAuthenticated>().having(
            (s) => s.user.email,
            'email',
            'existing@example.com',
          ),
        ]),
      );

      newBloc.close();
    });

    test('App startup without session', () async {
      // Ensure no user is logged in
      mockRepository.reset();

      authBloc.add(AppStarted());

      await expectLater(
        authBloc.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthUnauthenticated>()]),
      );
    });

    test('Sequential authentication operations', () async {
      // Signup
      authBloc.add(
        SignUpRequested(
          name: 'Test User',
          email: 'sequential@example.com',
          password: 'password123',
        ),
      );

      await authBloc.stream.first; // Loading
      await authBloc.stream.first; // Authenticated

      // Logout
      authBloc.add(LogoutRequested());

      await authBloc.stream.first; // Loading
      await authBloc.stream.first; // Unauthenticated

      expect(mockRepository.hasCurrentUser, false);

      // Login again
      authBloc.add(
        LoginRequested(
          email: 'sequential@example.com',
          password: 'password123',
        ),
      );

      await authBloc.stream.first; // Loading
      final finalState = await authBloc.stream.first; // Authenticated

      // Final state may be OtpSent (signup requires OTP) or authenticated
      expect(finalState is AuthAuthenticated || finalState is OtpSent, true);
      if (finalState is AuthAuthenticated) {
        expect(finalState.user.email, 'sequential@example.com');
      }
    });

    test('Update profile failure restores previous state', () async {
      // Setup
      await mockRepository.signUp(
        name: 'Original Name',
        email: 'restore@example.com',
        password: 'password123',
      );

      final originalUser = mockRepository._currentUser!;

      // Create a scenario that will fail (simulate by logging out first)
      await mockRepository.logout();

      final newBloc = AuthBloc(repository: mockRepository);

      // Try to update without being logged in
      newBloc.add(
        UpdateProfileRequested(
          id: originalUser.id,
          email: originalUser.email,
          name: 'Should Fail',
        ),
      );

      await expectLater(
        newBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthFailure>(),
          isA<AuthUnauthenticated>(),
        ]),
      );

      newBloc.close();
    });
  });

  group('Edge Cases and Error Scenarios', () {
    late MockAuthRepository mockRepository;
    late AuthBloc authBloc;

    setUp(() {
      mockRepository = MockAuthRepository();
      authBloc = AuthBloc(repository: mockRepository);
    });

    tearDown(() {
      authBloc.close();
      mockRepository.reset();
    });

    test('Empty email and password', () async {
      authBloc.add(LoginRequested(email: '', password: ''));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthFailure>(),
          isA<AuthUnauthenticated>(),
        ]),
      );
    });

    test('Very long inputs', () async {
      final longString = 'a' * 1000;

      authBloc.add(
        SignUpRequested(
          name: longString,
          email: '${longString}@example.com',
          password: 'password123',
        ),
      );

      await expectLater(authBloc.stream, emits(isA<AuthLoading>()));
    });

    test('Special characters in inputs', () async {
      authBloc.add(
        SignUpRequested(
          name: 'Test@#\$%User',
          email: 'special+chars@test.com',
          password: 'P@ssw0rd!',
        ),
      );

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          anyOf(isA<OtpSent>(), isA<AuthAuthenticated>()),
        ]),
      );
    });
  });
}
