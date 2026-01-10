import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUp);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Keep a copy of previous state so we can restore it on failure
    final prevState = state;
    emit(AuthLoading());
    try {
      final updatedEntity = UserEntity(
        id: event.id,
        email: event.email,
        name: event.name,
        phone: event.phone,
        country: event.country,
        language: event.language,
        theme: event.theme,
        notificationsEnabled: event.notificationsEnabled ?? true,
        createdAt:
            DateTime.now(), // placeholder, repository preserves createdAt
        updatedAt: DateTime.now(),
      );

      final user = await repository.updateUser(updatedEntity);

      // Emit authenticated with updated user
      emit(AuthAuthenticated(user));
    } catch (e) {
      // On failure, emit failure but restore previous state (do NOT unauthenticate)
      emit(AuthFailure(e.toString()));
      // restore previous authenticated state if it was authenticated
      if (prevState is AuthAuthenticated) {
        emit(prevState);
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }
}
