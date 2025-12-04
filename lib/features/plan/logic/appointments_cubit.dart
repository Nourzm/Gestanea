import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/models/appointment.dart';
import 'package:gestanea/core/repositories/appointment_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentRepository _appointmentRepository;
  final UserRepository _userRepository;

  AppointmentsCubit({
    AppointmentRepository? appointmentRepository,
    UserRepository? userRepository,
  })  : _appointmentRepository = appointmentRepository ?? getIt<AppointmentRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(AppointmentsInitial()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    emit(AppointmentsLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(AppointmentsError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final result = await _appointmentRepository.getAppointments(userResult.data!.id);
    
    if (result.isSuccess) {
      emit(AppointmentsLoaded(result.data ?? []));
    } else {
      emit(AppointmentsError(result.message ?? 'Failed to load appointments'));
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    final result = await _appointmentRepository.addAppointment(appointment);
    
    if (result.isSuccess) {
      emit(AppointmentsOperationSuccess(result.message ?? 'Appointment added successfully'));
      await loadAppointments();
    } else {
      emit(AppointmentsError(result.message ?? 'Failed to add appointment'));
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    final result = await _appointmentRepository.updateAppointment(appointment);
    
    if (result.isSuccess) {
      emit(AppointmentsOperationSuccess(result.message ?? 'Appointment updated successfully'));
      await loadAppointments();
    } else {
      emit(AppointmentsError(result.message ?? 'Failed to update appointment'));
    }
  }

  Future<void> deleteAppointment(String id) async {
    final result = await _appointmentRepository.deleteAppointment(id);
    
    if (result.isSuccess) {
      emit(AppointmentsOperationSuccess(result.message ?? 'Appointment deleted successfully'));
      await loadAppointments();
    } else {
      emit(AppointmentsError(result.message ?? 'Failed to delete appointment'));
    }
  }
}
