import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:gestanea/features/plan/logic/plan_bloc.dart';
import 'package:gestanea/features/plan/data/repositories/medicine_repository.dart'
    as med_repo;
import 'package:gestanea/features/plan/data/repositories/appointment_repository.dart'
    as appt_repo;
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/core/services/alarm_scheduler.dart';

import 'plan_bloc_test.mocks.dart';

@GenerateMocks([
  med_repo.MedicineRepository,
  appt_repo.AppointmentRepository,
  AlarmScheduler,
])
void main() {
  group('PlanBloc', () {
    late MockMedicineRepository mockMedicineRepository;
    late MockAppointmentRepository mockAppointmentRepository;
    late MockAlarmScheduler mockAlarmScheduler;
    late PlanBloc planBloc;

    setUp(() {
      mockMedicineRepository = MockMedicineRepository();
      mockAppointmentRepository = MockAppointmentRepository();
      mockAlarmScheduler = MockAlarmScheduler();

      // Set up default mock responses
      when(
        mockMedicineRepository.getMedicines(any),
      ).thenAnswer((_) async => []);
      when(
        mockMedicineRepository.getMedicinesByDate(any, any),
      ).thenAnswer((_) async => []);
      when(
        mockMedicineRepository.getMedicineLogs(any, any),
      ).thenAnswer((_) async => []);
      when(mockMedicineRepository.insertMedicine(any)).thenAnswer(
        (_) async => med_repo.ReturnResult(state: true, message: 'Success'),
      );
      when(mockMedicineRepository.logMedicine(any)).thenAnswer(
        (_) async => med_repo.ReturnResult(state: true, message: 'Success'),
      );

      when(
        mockAppointmentRepository.getAppointments(any),
      ).thenAnswer((_) async => []);
      when(
        mockAppointmentRepository.getAppointmentsByDate(any, any),
      ).thenAnswer((_) async => []);
      when(mockAppointmentRepository.insertAppointment(any)).thenAnswer(
        (_) async => appt_repo.ReturnResult(state: true, message: 'Success'),
      );

      planBloc = PlanBloc(
        medicineRepository: mockMedicineRepository,
        appointmentRepository: mockAppointmentRepository,
        alarmScheduler: mockAlarmScheduler,
      );
    });

    tearDown(() {
      planBloc.close();
    });

    test('initial state should be PlanInitial', () {
      expect(planBloc.state, equals(PlanInitial()));
    });

    group('LoadMedicines', () {
      final testMedicines = [
        MedicineModel(
          id: 'med_1',
          userId: 'user_1',
          medicineName: 'Prenatal Vitamins',
          dosage: '1 tablet',
          frequencyType: 'Daily',
          scheduledTimes: ['09:00'],
          startDate: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
        ),
        MedicineModel(
          id: 'med_2',
          userId: 'user_1',
          medicineName: 'Iron Supplement',
          dosage: '65mg',
          frequencyType: 'Twice daily',
          scheduledTimes: ['09:00', '21:00'],
          startDate: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
        ),
      ];

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, MedicinesLoaded] when medicines are loaded successfully',
        build: () => planBloc,
        act: (bloc) => bloc.add(const LoadMedicines(userId: 'user_1')),
        expect: () => [
          isA<PlanLoading>(),
          isA<MedicinesLoaded>().having(
            (state) => state is MedicinesLoaded,
            'is MedicinesLoaded',
            true,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, PlanError] when loading medicines fails',
        build: () => planBloc,
        act: (bloc) => bloc.add(const LoadMedicines(userId: 'invalid_user')),
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanError>().having(
            (state) => state is PlanError,
            'is PlanError',
            true,
          ),
        ],
      );
    });

    group('AddMedicineEvent', () {
      final testMedicine = MedicineModel(
        id: 'new_med',
        userId: 'user_1',
        medicineName: 'Folic Acid',
        dosage: '400mcg',
        frequencyType: 'Daily',
        scheduledTimes: ['08:00'],
        startDate: DateTime.now(),
        isActive: true,
        createdAt: DateTime.now(),
      );

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, PlanLoaded] when medicine is added successfully',
        build: () => planBloc,
        act: (bloc) => bloc.add(AddMedicineEvent(medicine: testMedicine)),
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>().having(
            (state) => state is PlanLoaded,
            'is PlanLoaded',
            true,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'handles medicine with empty name gracefully',
        build: () => planBloc,
        act: (bloc) => bloc.add(
          AddMedicineEvent(medicine: testMedicine.copyWith(medicineName: '')),
        ),
        expect: () => [isA<PlanLoading>(), isA<PlanError>()],
      );
    });

    group('LogMedicineEvent', () {
      final testLog = MedicineLoggedModel(
        id: 'log_1',
        medicineId: 'med_1',
        userId: 'user_1',
        loggedDate: DateTime.now(),
        status: 'taken',
        notes: 'Taken on time',
        loggedAt: DateTime.now(),
      );

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, PlanLoaded] when medicine is logged successfully',
        build: () => planBloc,
        act: (bloc) => bloc.add(LogMedicineEvent(log: testLog)),
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>().having(
            (state) => state is PlanLoaded,
            'is PlanLoaded',
            true,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'handles missed medicine logging',
        build: () => planBloc,
        act: (bloc) =>
            bloc.add(LogMedicineEvent(log: testLog.copyWith(status: 'missed'))),
        expect: () => [isA<PlanLoading>(), isA<PlanLoaded>()],
      );

      blocTest<PlanBloc, PlanState>(
        'handles skipped medicine logging',
        build: () => planBloc,
        act: (bloc) => bloc.add(
          LogMedicineEvent(log: testLog.copyWith(status: 'skipped')),
        ),
        expect: () => [isA<PlanLoading>(), isA<PlanLoaded>()],
      );
    });

    group('LoadAppointments', () {
      final testAppointments = [
        AppointmentModel(
          id: 'appt_1',
          userId: 'user_1',
          title: 'Regular checkup',
          doctorName: 'Dr. Smith',
          appointmentType: 'Obstetrician',
          appointmentDate: DateTime.now().add(const Duration(days: 7)),
          location: 'City Hospital',
          notes: 'Regular checkup',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      ];

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, AppointmentsLoaded] when appointments are loaded successfully',
        build: () => planBloc,
        act: (bloc) => bloc.add(const LoadAppointments(userId: 'user_1')),
        expect: () => [
          isA<PlanLoading>(),
          isA<AppointmentsLoaded>().having(
            (state) => state is AppointmentsLoaded,
            'is AppointmentsLoaded',
            true,
          ),
        ],
      );
    });

    group('AddAppointmentEvent', () {
      final testAppointment = AppointmentModel(
        id: 'new_appt',
        userId: 'user_1',
        title: '20-week scan',
        doctorName: 'Dr. Johnson',
        appointmentType: 'Ultrasound',
        appointmentDate: DateTime.now().add(const Duration(days: 14)),
        location: 'Medical Center',
        notes: '20-week scan',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, PlanLoaded] when appointment is added successfully',
        build: () => planBloc,
        act: (bloc) =>
            bloc.add(AddAppointmentEvent(appointment: testAppointment)),
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>().having(
            (state) => state is PlanLoaded,
            'is PlanLoaded',
            true,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'handles appointment in the past',
        build: () => planBloc,
        act: (bloc) => bloc.add(
          AddAppointmentEvent(
            appointment: testAppointment.copyWith(
              appointmentDate: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ),
        ),
        expect: () => [isA<PlanLoading>(), isA<PlanLoaded>()],
      );
    });

    group('LoadPlanData', () {
      final testDate = DateTime.now();

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, PlanLoaded] when plan data is loaded successfully',
        build: () => planBloc,
        act: (bloc) => bloc.add(LoadPlanData(userId: 'user_1', date: testDate)),
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>().having(
            (state) => state is PlanLoaded,
            'is PlanLoaded',
            true,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'loads plan data for different dates',
        build: () => planBloc,
        act: (bloc) {
          bloc.add(LoadPlanData(userId: 'user_1', date: testDate));
          bloc.add(
            LoadPlanData(
              userId: 'user_1',
              date: testDate.add(const Duration(days: 1)),
            ),
          );
        },
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>(),
          isA<PlanLoading>(),
          isA<PlanLoaded>(),
        ],
      );
    });

    group('RefreshPlanData', () {
      final testDate = DateTime.now();

      blocTest<PlanBloc, PlanState>(
        'emits [PlanLoading, PlanLoaded] when plan data is refreshed',
        build: () => planBloc,
        act: (bloc) =>
            bloc.add(RefreshPlanData(userId: 'user_1', date: testDate)),
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>().having(
            (state) => state is PlanLoaded,
            'is PlanLoaded',
            true,
          ),
        ],
      );
    });

    group('Complex Scenarios', () {
      blocTest<PlanBloc, PlanState>(
        'handles multiple rapid events',
        build: () => planBloc,
        act: (bloc) {
          bloc.add(const LoadMedicines(userId: 'user_1'));
          bloc.add(const LoadAppointments(userId: 'user_1'));
          bloc.add(LoadPlanData(userId: 'user_1', date: DateTime.now()));
        },
        expect: () => [
          isA<PlanLoading>(),
          isA<MedicinesLoaded>(),
          isA<PlanLoading>(),
          isA<AppointmentsLoaded>(),
          isA<PlanLoading>(),
          isA<PlanLoaded>(),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'handles add and load sequence',
        build: () => planBloc,
        act: (bloc) {
          final medicine = MedicineModel(
            id: 'test',
            userId: 'user_1',
            medicineName: 'Test Medicine',
            dosage: '1 tablet',
            frequencyType: 'Daily',
            scheduledTimes: ['09:00'],
            startDate: DateTime.now(),
            isActive: true,
            createdAt: DateTime.now(),
          );
          bloc.add(AddMedicineEvent(medicine: medicine));
          bloc.add(const LoadMedicines(userId: 'user_1'));
        },
        expect: () => [
          isA<PlanLoading>(),
          isA<PlanLoaded>(),
          isA<PlanLoading>(),
          isA<MedicinesLoaded>(),
        ],
      );
    });
  });
}
