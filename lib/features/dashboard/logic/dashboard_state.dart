import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/user.dart';
import 'package:gestanea/core/models/pregnancy.dart';
import 'package:gestanea/core/models/baby.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final User user;
  final Pregnancy? activePregnancy;
  final List<Baby> babies;

  const DashboardLoaded({
    required this.user,
    this.activePregnancy,
    this.babies = const [],
  });

  @override
  List<Object?> get props => [user, activePregnancy, babies];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
