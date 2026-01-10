import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';

@GenerateMocks([AuthRepository])
import 'auth_bloc_test.mocks.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockRepository;
    late UserEntity testUser;

    setUp(() {
      mockRepository = MockAuthRepository();
      authBloc = AuthBloc(repository: mockRepository);
      testUser = UserEntity(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        phone: '+1234567890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('AppStarted', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user is logged in',
        build: () {
          when(
            mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>()
              .having((s) => s.user.id, 'user id', 'user123')
              .having((s) => s.user.email, 'user email', 'test@example.com'),
        ],
        verify: (_) {
          verify(mockRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when no user is logged in',
        build: () {
          when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
        verify: (_) {
          verify(mockRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when error occurs',
        build: () {
          when(
            mockRepository.getCurrentUser(),
          ).thenThrow(Exception('Database error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
      );
    });

    group('SignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when signup succeeds',
        build: () {
          when(
            mockRepository.signUp(
              name: anyNamed('name'),
              email: anyNamed('email'),
              password: anyNamed('password'),
              phone: anyNamed('phone'),
            ),
          ).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignUpRequested(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
            phone: '+1234567890',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>().having(
            (s) => s.user.name,
            'user name',
            'Test User',
          ),
        ],
        verify: (_) {
          verify(
            mockRepository.signUp(
              name: 'Test User',
              email: 'test@example.com',
              password: 'password123',
              phone: '+1234567890',
            ),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure, AuthUnauthenticated] when signup fails',
        build: () {
          when(
            mockRepository.signUp(
              name: anyNamed('name'),
              email: anyNamed('email'),
              password: anyNamed('password'),
              phone: anyNamed('phone'),
            ),
          ).thenThrow(Exception('Email already exists'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignUpRequested(
            name: 'Test User',
            email: 'existing@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'error message',
            contains('Email already exists'),
          ),
          isA<AuthUnauthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits states when signup without phone number',
        build: () {
          when(
            mockRepository.signUp(
              name: anyNamed('name'),
              email: anyNamed('email'),
              password: anyNamed('password'),
              phone: anyNamed('phone'),
            ),
          ).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignUpRequested(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
      );
    });

    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          when(
            mockRepository.login(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          LoginRequested(email: 'test@example.com', password: 'password123'),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>().having(
            (s) => s.user.email,
            'user email',
            'test@example.com',
          ),
        ],
        verify: (_) {
          verify(
            mockRepository.login(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure, AuthUnauthenticated] when login fails',
        build: () {
          when(
            mockRepository.login(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenThrow(Exception('Invalid credentials'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          LoginRequested(email: 'wrong@example.com', password: 'wrongpassword'),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'error message',
            contains('Invalid credentials'),
          ),
          isA<AuthUnauthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'handles network error during login',
        build: () {
          when(
            mockRepository.login(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenThrow(Exception('Network error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          LoginRequested(email: 'test@example.com', password: 'password123'),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
        build: () {
          when(mockRepository.logout()).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutRequested()),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
        verify: (_) {
          verify(mockRepository.logout()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when logout fails',
        build: () {
          when(mockRepository.logout()).thenThrow(Exception('Logout failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'error message',
            contains('Logout failed'),
          ),
        ],
      );
    });

    group('UpdateProfileRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] with updated user when update succeeds',
        build: () {
          final updatedUser = UserEntity(
            id: 'user123',
            email: 'test@example.com',
            name: 'Updated Name',
            phone: '+9876543210',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          when(
            mockRepository.updateUser(any),
          ).thenAnswer((_) async => updatedUser);
          return authBloc;
        },
        seed: () => AuthAuthenticated(testUser),
        act: (bloc) => bloc.add(
          UpdateProfileRequested(
            id: 'user123',
            email: 'test@example.com',
            name: 'Updated Name',
            phone: '+9876543210',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>()
              .having((s) => s.user.name, 'updated name', 'Updated Name')
              .having((s) => s.user.phone, 'updated phone', '+9876543210'),
        ],
        verify: (_) {
          verify(mockRepository.updateUser(any)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] and restores previous state when update fails',
        build: () {
          when(
            mockRepository.updateUser(any),
          ).thenThrow(Exception('Update failed'));
          return authBloc;
        },
        seed: () => AuthAuthenticated(testUser),
        act: (bloc) => bloc.add(
          UpdateProfileRequested(
            id: 'user123',
            email: 'test@example.com',
            name: 'Failed Update',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
          isA<AuthAuthenticated>().having(
            (s) => s.user.name,
            'original name',
            'Test User',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'handles update with optional fields',
        build: () {
          final updatedUser = UserEntity(
            id: 'user123',
            email: 'test@example.com',
            name: 'Test User',
            country: 'Algeria',
            language: 'ar',
            theme: 'dark',
            notificationsEnabled: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          when(
            mockRepository.updateUser(any),
          ).thenAnswer((_) async => updatedUser);
          return authBloc;
        },
        seed: () => AuthAuthenticated(testUser),
        act: (bloc) => bloc.add(
          UpdateProfileRequested(
            id: 'user123',
            email: 'test@example.com',
            name: 'Test User',
            country: 'Algeria',
            language: 'ar',
            theme: 'dark',
            notificationsEnabled: false,
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>()
              .having((s) => s.user.country, 'country', 'Algeria')
              .having(
                (s) => s.user.notificationsEnabled,
                'notifications',
                false,
              ),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<AuthBloc, AuthState>(
        'handles rapid sequential events',
        build: () {
          when(
            mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) {
          bloc.add(AppStarted());
          bloc.add(AppStarted());
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'handles empty string inputs gracefully',
        build: () {
          when(
            mockRepository.login(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenThrow(Exception('Invalid input'));
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginRequested(email: '', password: '')),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
          isA<AuthUnauthenticated>(),
        ],
      );
    });
  });
}
