import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/features/plan/data/repositories/appointment_repository.dart';

// Events
abstract class UpcomingAppointmentsEvent extends Equatable {
  const UpcomingAppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUpcomingAppointments extends UpcomingAppointmentsEvent {
  final String userId;

  const LoadUpcomingAppointments({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshUpcomingAppointments extends UpcomingAppointmentsEvent {
  final String userId;

  const RefreshUpcomingAppointments({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// States
abstract class UpcomingAppointmentsState extends Equatable {
  const UpcomingAppointmentsState();

  @override
  List<Object?> get props => [];
}

class UpcomingAppointmentsInitial extends UpcomingAppointmentsState {}

class UpcomingAppointmentsLoading extends UpcomingAppointmentsState {}

class UpcomingAppointmentsLoaded extends UpcomingAppointmentsState {
  final List<AppointmentModel> appointments;

  const UpcomingAppointmentsLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class UpcomingAppointmentsEmpty extends UpcomingAppointmentsState {}

class UpcomingAppointmentsError extends UpcomingAppointmentsState {
  final String message;

  const UpcomingAppointmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class UpcomingAppointmentsCubit extends Cubit<UpcomingAppointmentsState> {
  final AppointmentRepository _appointmentRepository =
      AppointmentRepository.getInstance();

  static final UpcomingAppointmentsCubit _instance =
      UpcomingAppointmentsCubit._internal();

  UpcomingAppointmentsCubit._internal() : super(UpcomingAppointmentsInitial());

  factory UpcomingAppointmentsCubit() {
    return _instance;
  }

  static UpcomingAppointmentsCubit getInstance() {
    return _instance;
  }

  Future<void> loadUpcomingAppointments(String userId) async {
    try {
      emit(UpcomingAppointmentsLoading());
      final appointments =
          await _appointmentRepository.getUpcomingAppointments(userId);

      if (appointments.isEmpty) {
        emit(UpcomingAppointmentsEmpty());
      } else {
        // Filter to only show appointments within next 7 days
        final now = DateTime.now();
        final sevenDaysLater =
            now.add(const Duration(days: 7));
        final filteredAppointments = appointments.where((apt) {
          return apt.appointmentDate.isAfter(now) &&
              apt.appointmentDate.isBefore(sevenDaysLater);
        }).toList();

        if (filteredAppointments.isEmpty) {
          emit(UpcomingAppointmentsEmpty());
        } else {
          emit(UpcomingAppointmentsLoaded(appointments: filteredAppointments));
        }
      }
    } catch (e) {
      emit(UpcomingAppointmentsError(message: 'Failed to load appointments'));
    }
  }

  Future<void> refreshUpcomingAppointments(String userId) async {
    // Small delay to ensure database is updated
    await Future.delayed(const Duration(milliseconds: 500));
    await loadUpcomingAppointments(userId);
  }
}
