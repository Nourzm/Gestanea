import 'package:equatable/equatable.dart';
import '../../domain/entities/pregnancy_dashboard.dart';
import '../../domain/entities/postpartum_dashboard.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class PregnancyDashboardLoaded extends DashboardState {
  final PregnancyDashboard dashboard;

  const PregnancyDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class PostpartumDashboardLoaded extends DashboardState {
  final PostpartumDashboard dashboard;

  const PostpartumDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// Additional states for specific dashboard components
class AppointmentsLoaded extends DashboardState {
  final List<AppointmentReminder> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class MedicineRemindersLoaded extends DashboardState {
  final List<MedicineReminder> reminders;

  const MedicineRemindersLoaded(this.reminders);

  @override
  List<Object?> get props => [reminders];
}

class HealthAlertsLoaded extends DashboardState {
  final List<HealthAlert> alerts;

  const HealthAlertsLoaded(this.alerts);

  @override
  List<Object?> get props => [alerts];
}

class VaccineRemindersLoaded extends DashboardState {
  final List<VaccineReminder> vaccines;

  const VaccineRemindersLoaded(this.vaccines);

  @override
  List<Object?> get props => [vaccines];
}
