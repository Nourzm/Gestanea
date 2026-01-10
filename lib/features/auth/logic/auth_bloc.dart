import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/services/profile_picture_service.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  void _log(String msg) => print('[AuthBloc] $msg');

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUp);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<ForgotPasswordRequested>(_onForgotPassword);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<UpdateProfilePictureRequested>(_onUpdateProfilePicture);
    on<ChangePasswordRequested>(_onChangePassword);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    _log('AppStarted');
    emit(AuthLoading());
    try {
      final user = await repository.getCurrentUser();
      if (user != null) {
        _log('Already authenticated as ${user.id}');
        emit(AuthAuthenticated(user));
      } else {
        _log('No current user');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      _log('AppStarted error: $e');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    _log('SignUpRequested email=${event.email}');
    emit(AuthLoading());
    try {
      await repository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
      );
      // After sign up, send OTP is triggered inside repository; now wait for user to verify
      _log('SignUp success -> OtpSent ${event.email}');
      emit(OtpSent(event.email));
    } catch (e) {
      _log('SignUp error: $e');
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    _log('LoginRequested email=${event.email}');
    emit(AuthLoading());
    try {
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );
      _log('Login success userId=${user.id}');
      emit(AuthAuthenticated(user));
    } catch (e) {
      _log('Login error: $e');
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    _log('LogoutRequested');
    emit(AuthLoading());
    try {
      await repository.logout();
      _log('Logout success');
      emit(AuthUnauthenticated());
    } catch (e) {
      _log('Logout error: $e');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSendOtp(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    _log('SendOtpRequested email=${event.email}');
    emit(AuthLoading());
    try {
      await repository.sendOtp(event.email);
      _log('SendOtp success ${event.email}');
      emit(OtpSent(event.email));
    } catch (e) {
      _log('SendOtp error: $e');
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    _log('VerifyOtpRequested email=${event.email}');
    emit(AuthLoading());
    try {
      final user = await repository.verifyOtp(
        email: event.email,
        otpCode: event.otpCode,
      );
      _log('VerifyOtp success userId=${user.id}');
      emit(AuthAuthenticated(user));
    } catch (e) {
      _log('VerifyOtp error: $e');
      emit(AuthFailure(e.toString()));
      // Return to OtpSent state so user can try again
      emit(OtpSent(event.email));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    _log('ResendOtpRequested email=${event.email}');
    emit(AuthLoading());
    try {
      await repository.sendOtp(event.email);
      _log('ResendOtp success ${event.email}');
      emit(AuthOTPResent(event.email));
    } catch (e) {
      _log('ResendOtp error: $e');
      emit(AuthFailure(e.toString()));
      emit(OtpSent(event.email));
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    _log('ForgotPasswordRequested email=${event.email}');
    emit(AuthLoading());
    try {
      await repository.sendPasswordReset(email: event.email);
      _log('Password reset email sent ${event.email}');
      emit(PasswordResetEmailSent(event.email));
      emit(AuthUnauthenticated());
    } catch (e) {
      _log('ForgotPassword error: $e');
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Keep a copy of previous state so we can restore it on failure
    final prevState = state;
    _log('UpdateProfileRequested id=${event.id}');
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
        profilePictureUrl: event.profilePictureUrl,
        createdAt:
            DateTime.now(), // placeholder, repository preserves createdAt
        updatedAt: DateTime.now(),
      );

      final user = await repository.updateUser(updatedEntity);

      // Emit authenticated with updated user
      _log('UpdateProfile success id=${user.id}');
      emit(AuthAuthenticated(user));
    } catch (e) {
      // On failure, emit failure but restore previous state (do NOT unauthenticate)
      _log('UpdateProfile error: $e');
      emit(AuthFailure(e.toString()));
      // restore previous authenticated state if it was authenticated
      if (prevState is AuthAuthenticated) {
        emit(prevState);
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePictureRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prevState = state;
    _log('UpdateProfilePictureRequested userId=${event.userId}');
    emit(AuthLoading());

    try {
      final profilePictureService = ProfilePictureService();
      final imageFile = File(event.imageFilePath);

      if (!await imageFile.exists()) {
        throw Exception('Image file not found');
      }

      // Upload to Supabase Storage and get URL
      final imageUrl = await profilePictureService.uploadProfilePicture(
        userId: event.userId,
        imageFile: imageFile,
      );

      // Get current user to update with new profile picture URL
      if (prevState is AuthAuthenticated) {
        final updatedEntity = UserEntity(
          id: prevState.user.id,
          email: prevState.user.email,
          name: prevState.user.name,
          phone: prevState.user.phone,
          country: prevState.user.country,
          language: prevState.user.language,
          theme: prevState.user.theme,
          notificationsEnabled: prevState.user.notificationsEnabled,
          profilePictureUrl: imageUrl,
          createdAt: prevState.user.createdAt,
          updatedAt: DateTime.now(),
        );

        final user = await repository.updateUser(updatedEntity);
        _log('UpdateProfilePicture success id=${user.id}');
        emit(AuthAuthenticated(user));
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      _log('UpdateProfilePicture error: $e');
      emit(AuthFailure(e.toString()));
      // Restore previous state
      if (prevState is AuthAuthenticated) {
        emit(prevState);
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prevState = state;
    _log('ChangePasswordRequested');
    emit(AuthLoading());

    try {
      await repository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      _log('ChangePassword success');
      emit(PasswordChangedSuccess());
      
      // Return to authenticated state after a brief delay
      if (prevState is AuthAuthenticated) {
        await Future.delayed(const Duration(seconds: 1));
        emit(prevState);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      _log('ChangePassword error: $e');
      emit(AuthFailure(e.toString()));
      // Restore previous state
      if (prevState is AuthAuthenticated) {
        emit(prevState);
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }
}
