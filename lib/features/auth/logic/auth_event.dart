import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;

  SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });

  @override
  List<Object?> get props => [name, email, password, phone];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class SendOtpRequested extends AuthEvent {
  final String email;

  SendOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String otpCode;

  VerifyOtpRequested({required this.email, required this.otpCode});

  @override
  List<Object?> get props => [email, otpCode];
}

class ResendOtpRequested extends AuthEvent {
  final String email;

  ResendOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateProfileRequested extends AuthEvent {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? country;
  final String? language;
  final String? theme;
  final bool? notificationsEnabled;
  final String? profilePictureUrl;

  UpdateProfileRequested({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.country,
    this.language,
    this.theme,
    this.notificationsEnabled,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    country,
    language,
    theme,
    notificationsEnabled,
    profilePictureUrl,
  ];
}

/// Event for updating profile picture
class UpdateProfilePictureRequested extends AuthEvent {
  final String userId;
  final String imageFilePath;

  UpdateProfilePictureRequested({
    required this.userId,
    required this.imageFilePath,
  });

  @override
  List<Object?> get props => [userId, imageFilePath];
}

/// Event for changing password
class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
