import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/core/services/alarm_scheduler.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import '../data/repositories/medicine_repository.dart';
import '../data/repositories/appointment_repository.dart';
import 'dart:developer' as developer;
import 'dart:async';

// Events
abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlanData extends PlanEvent {
  final String userId;
  final DateTime date;

  const LoadPlanData({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}

class RefreshPlanData extends PlanEvent {
  final String userId;
  final DateTime date;

  const RefreshPlanData({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}

class AddMedicineEvent extends PlanEvent {
  final MedicineModel medicine;

  const AddMedicineEvent({required this.medicine});

  @override
  List<Object?> get props => [medicine];
}

class LogMedicineEvent extends PlanEvent {
  final MedicineLoggedModel log;

  const LogMedicineEvent({required this.log});

  @override
  List<Object?> get props => [log];
}

class AddAppointmentEvent extends PlanEvent {
  final AppointmentModel appointment;

  const AddAppointmentEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class LoadAppointments extends PlanEvent {
  final String userId;

  const LoadAppointments({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadMedicines extends PlanEvent {
  final String userId;

  const LoadMedicines({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// States
abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlanLoaded extends PlanState {
  final List<MedicineModel> medicines;
  final List<MedicineLoggedModel> medicineLogs;
  final List<AppointmentModel> appointments;

  const PlanLoaded({
    required this.medicines,
    required this.medicineLogs,
    required this.appointments,
  });

  @override
  List<Object?> get props => [medicines, medicineLogs, appointments];

  PlanLoaded copyWith({
    List<MedicineModel>? medicines,
    List<MedicineLoggedModel>? medicineLogs,
    List<AppointmentModel>? appointments,
  }) {
    return PlanLoaded(
      medicines: medicines ?? this.medicines,
      medicineLogs: medicineLogs ?? this.medicineLogs,
      appointments: appointments ?? this.appointments,
    );
  }
}

class AppointmentsLoaded extends PlanState {
  final List<AppointmentModel> appointments;

  const AppointmentsLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class MedicinesLoaded extends PlanState {
  final List<MedicineModel> medicines;
  final List<MedicineLoggedModel> medicineLogs;

  const MedicinesLoaded({required this.medicines, required this.medicineLogs});

  @override
  List<Object?> get props => [medicines, medicineLogs];
}

class PlanError extends PlanState {
  final String message;

  const PlanError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final MedicineRepository medicineRepository;
  final AppointmentRepository appointmentRepository;
  final AlarmScheduler alarmScheduler;
  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;

  PlanBloc({
    required this.medicineRepository,
    required this.appointmentRepository,
    required this.alarmScheduler,
    ConnectivityService? connectivityService,
  }) : _connectivityService = connectivityService ?? ConnectivityService(),
       super(PlanInitial()) {
    on<LoadPlanData>(_onLoadPlanData);
    on<RefreshPlanData>(_onRefreshPlanData);
    on<AddMedicineEvent>(_onAddMedicine);
    on<LogMedicineEvent>(_onLogMedicine);
    on<AddAppointmentEvent>(_onAddAppointment);
    on<LoadAppointments>(_onLoadAppointments);
    on<LoadMedicines>(_onLoadMedicines);

    // Listen for connectivity changes and trigger sync when coming online
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      isOnline,
    ) {
      if (isOnline) {
        print('📶 Connection restored - syncing pending data...');
        // Trigger a refresh to sync pending items
        if (state is PlanLoaded) {
          final currentState = state as PlanLoaded;
          // Get user ID from current medicines or appointments
          if (currentState.medicines.isNotEmpty) {
            final userId = currentState.medicines.first.userId;
            add(RefreshPlanData(userId: userId!, date: DateTime.now()));
          } else if (currentState.appointments.isNotEmpty) {
            final userId = currentState.appointments.first.userId;
            add(LoadAppointments(userId: userId));
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadPlanData(
    LoadPlanData event,
    Emitter<PlanState> emit,
  ) async {
    emit(PlanLoading());
    try {
      final medicines = await medicineRepository.getMedicinesByDate(
        event.userId,
        event.date,
      );
      final logs = await medicineRepository.getMedicineLogs(
        event.userId,
        event.date,
      );
      final appointments = await appointmentRepository.getUpcomingAppointments(
        event.userId,
      );

      emit(
        PlanLoaded(
          medicines: medicines,
          medicineLogs: logs,
          appointments: appointments,
        ),
      );
    } catch (e) {
      emit(PlanError(message: 'Failed to load plan data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshPlanData(
    RefreshPlanData event,
    Emitter<PlanState> emit,
  ) async {
    try {
      final medicines = await medicineRepository.getMedicinesByDate(
        event.userId,
        event.date,
      );
      final logs = await medicineRepository.getMedicineLogs(
        event.userId,
        event.date,
      );
      final appointments = await appointmentRepository.getUpcomingAppointments(
        event.userId,
      );

      emit(
        PlanLoaded(
          medicines: medicines,
          medicineLogs: logs,
          appointments: appointments,
        ),
      );
    } catch (e) {
      emit(PlanError(message: 'Failed to refresh plan data: ${e.toString()}'));
    }
  }

  Future<void> _onAddMedicine(
    AddMedicineEvent event,
    Emitter<PlanState> emit,
  ) async {
    developer.log(
      '💊 Adding medicine: ${event.medicine.medicineName}',
      name: 'PlanBloc',
    );
    print('💊 Adding medicine: ${event.medicine.medicineName}');

    try {
      final result = await medicineRepository.insertMedicine(event.medicine);
      if (result.state) {
        developer.log('✅ Medicine saved to database', name: 'PlanBloc');
        print('✅ Medicine saved to database');

        // Schedule alarms for this medicine
        if (event.medicine.scheduledTimes != null &&
            event.medicine.scheduledTimes!.isNotEmpty) {
          developer.log(
            '⏰ Scheduling alarms for medicine...',
            name: 'PlanBloc',
          );
          print('⏰ Scheduling alarms for medicine...');
          print('   Times: ${event.medicine.scheduledTimes}');

          await alarmScheduler.scheduleMedicineAlarms(
            medicineId: event.medicine.id,
            medicineName: event.medicine.medicineName,
            dosage: event.medicine.dosage,
            scheduledTimes: event.medicine.scheduledTimes!,
            startDate: event.medicine.startDate,
            endDate: event.medicine.endDate,
          );

          developer.log('✅ Alarms scheduled for medicine', name: 'PlanBloc');
          print('✅ Alarms scheduled for medicine');
        } else {
          developer.log('⚠️ No scheduled times for medicine', name: 'PlanBloc');
          print('⚠️ No scheduled times for medicine');
        }

        // Reload data after adding
        if (state is PlanLoaded) {
          final currentState = state as PlanLoaded;
          final medicines = await medicineRepository.getMedicinesByDate(
            event.medicine.userId ?? '',
            DateTime.now(),
          );
          emit(currentState.copyWith(medicines: medicines));
        }
      } else {
        developer.log(
          '❌ Failed to save medicine: ${result.message}',
          name: 'PlanBloc',
        );
        print('❌ Failed to save medicine: ${result.message}');
        emit(PlanError(message: result.message));
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error adding medicine: $e',
        name: 'PlanBloc',
        error: e,
        stackTrace: stackTrace,
      );
      print('❌ Error adding medicine: $e');
      emit(PlanError(message: 'Failed to add medicine: ${e.toString()}'));
    }
  }

  Future<void> _onLogMedicine(
    LogMedicineEvent event,
    Emitter<PlanState> emit,
  ) async {
    try {
      final result = await medicineRepository.logMedicine(event.log);
      if (result.state) {
        // Reload data after logging
        if (state is PlanLoaded) {
          final currentState = state as PlanLoaded;
          final logs = await medicineRepository.getMedicineLogs(
            event.log.userId,
            event.log.loggedDate,
          );
          emit(currentState.copyWith(medicineLogs: logs));
        } else if (state is MedicinesLoaded) {
          final currentState = state as MedicinesLoaded;
          final logs = await medicineRepository.getMedicineLogs(
            event.log.userId,
            event.log.loggedDate,
          );
          emit(
            MedicinesLoaded(
              medicines: currentState.medicines,
              medicineLogs: logs,
            ),
          );
        }
      } else {
        emit(PlanError(message: result.message));
      }
    } catch (e) {
      emit(PlanError(message: 'Failed to log medicine: ${e.toString()}'));
    }
  }

  Future<void> _onAddAppointment(
    AddAppointmentEvent event,
    Emitter<PlanState> emit,
  ) async {
    developer.log(
      '📅 Adding appointment: ${event.appointment.title}',
      name: 'PlanBloc',
    );
    print('📅 Adding appointment: ${event.appointment.title}');

    try {
      final result = await appointmentRepository.insertAppointment(
        event.appointment,
      );
      if (result.state) {
        developer.log('✅ Appointment saved to database', name: 'PlanBloc');
        print('✅ Appointment saved to database');

        // Schedule alarm for this appointment (30 minutes before)
        developer.log(
          '⏰ Scheduling alarm for appointment...',
          name: 'PlanBloc',
        );
        print('⏰ Scheduling alarm for appointment...');
        print('   Date: ${event.appointment.appointmentDate}');

        await alarmScheduler.scheduleAppointmentAlarm(
          appointmentId: event.appointment.id,
          title: event.appointment.title,
          appointmentDate: event.appointment.appointmentDate,
          location: event.appointment.location,
          reminderMinutesBefore: 30,
        );

        developer.log('✅ Alarm scheduled for appointment', name: 'PlanBloc');
        print('✅ Alarm scheduled for appointment');

        // Reload data after adding
        if (state is PlanLoaded) {
          final currentState = state as PlanLoaded;
          final appointments = await appointmentRepository
              .getUpcomingAppointments(event.appointment.userId);
          emit(currentState.copyWith(appointments: appointments));
        }
      } else {
        developer.log(
          '❌ Failed to save appointment: ${result.message}',
          name: 'PlanBloc',
        );
        print('❌ Failed to save appointment: ${result.message}');
        emit(PlanError(message: result.message));
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error adding appointment: $e',
        name: 'PlanBloc',
        error: e,
        stackTrace: stackTrace,
      );
      print('❌ Error adding appointment: $e');
      emit(PlanError(message: 'Failed to add appointment: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<PlanState> emit,
  ) async {
    emit(PlanLoading());
    try {
      final appointments = await appointmentRepository.getAppointments(
        event.userId,
      );
      emit(AppointmentsLoaded(appointments: appointments));
    } catch (e) {
      emit(PlanError(message: 'Failed to load appointments: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMedicines(
    LoadMedicines event,
    Emitter<PlanState> emit,
  ) async {
    emit(PlanLoading());
    try {
      final medicines = await medicineRepository.getMedicines(event.userId);
      final logs = await medicineRepository.getMedicineLogs(
        event.userId,
        DateTime.now(),
      );
      emit(MedicinesLoaded(medicines: medicines, medicineLogs: logs));
    } catch (e) {
      emit(PlanError(message: 'Failed to load medicines: ${e.toString()}'));
    }
  }
}
