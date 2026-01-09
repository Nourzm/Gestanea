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

class UpdateProfileRequested extends AuthEvent {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? country;
  final String? language;
  final String? theme;
  final bool? notificationsEnabled;

  UpdateProfileRequested({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.country,
    this.language,
    this.theme,
    this.notificationsEnabled,
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
  ];
}
