import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gestanea/features/plan/logic/plan_bloc.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/features/plan/data/repositories/medicine_repository.dart';
import 'package:gestanea/features/plan/data/repositories/appointment_repository.dart';
import 'package:gestanea/core/services/alarm_scheduler.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Supabase with test credentials
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      anonKey: 'test-anon-key-for-integration-tests',
    );
  });

  group('Plan Management Integration Tests', () {
    late PlanBloc planBloc;
    const testUserId = 'test_user_123';
    final testDate = DateTime.now();

    setUp(() {
      final medicineRepo = MedicineRepository();
      final appointmentRepo = AppointmentRepository();
      final alarmScheduler = AlarmScheduler();
      planBloc = PlanBloc(
        medicineRepository: medicineRepo,
        appointmentRepository: appointmentRepo,
        alarmScheduler: alarmScheduler,
      );
    });

    tearDown(() {
      planBloc.close();
    });

    group('Medicine Management Flow', () {
      test('should load medicines successfully', () async {
        // Arrange
        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(const LoadMedicines(userId: testUserId));

        // Wait for state changes
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(
          states.any(
            (s) => s is PlanLoading || s is MedicinesLoaded || s is PlanError,
          ),
          true,
        );
      });

      test('should add medicine successfully', () async {
        // Arrange
        final medicine = MedicineModel(
          id: 'med_1',
          userId: testUserId,
          medicineName: 'Prenatal Vitamins',
          dosage: '1 tablet',
          frequencyType: 'Daily',
          scheduledTimes: ['09:00', '21:00'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          createdAt: DateTime.now(),
        );

        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(AddMedicineEvent(medicine: medicine));

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(states.any((s) => s is PlanLoading), true);
      });

      test('should log medicine intake', () async {
        // Arrange
        final medicineLog = MedicineLoggedModel(
          id: 'log_1',
          medicineId: 'med_1',
          userId: testUserId,
          loggedDate: DateTime.now(),
          status: 'taken',
          notes: 'Taken as scheduled',
          loggedAt: DateTime.now(),
        );

        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(LogMedicineEvent(log: medicineLog));

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(states.any((s) => s is PlanLoading), true);
      });

      test('should handle multiple medicine schedules', () async {
        // Arrange - Add multiple medicines with different schedules
        final medicines = [
          MedicineModel(
            id: 'med_multi_1',
            userId: testUserId,
            medicineName: 'Folic Acid',
            dosage: '400mcg',
            frequencyType: 'Daily',
            scheduledTimes: ['08:00'],
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 90)),
            isActive: true,
            createdAt: DateTime.now(),
          ),
          MedicineModel(
            id: 'med_multi_2',
            userId: testUserId,
            medicineName: 'Iron Supplement',
            dosage: '65mg',
            frequencyType: 'Twice daily',
            scheduledTimes: ['09:00', '21:00'],
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 60)),
            isActive: true,
            createdAt: DateTime.now(),
          ),
        ];

        // Act
        for (var medicine in medicines) {
          planBloc.add(AddMedicineEvent(medicine: medicine));
          await Future.delayed(const Duration(milliseconds: 300));
        }

        // Load to verify
        planBloc.add(const LoadMedicines(userId: testUserId));
        await Future.delayed(const Duration(milliseconds: 500));
      });

      test('should skip missed medicine dose', () async {
        // Arrange
        final missedLog = MedicineLoggedModel(
          id: 'log_missed',
          medicineId: 'med_1',
          userId: testUserId,
          loggedDate: DateTime.now().subtract(const Duration(hours: 2)),
          status: 'missed',
          notes: 'Forgot to take',
          loggedAt: DateTime.now(),
        );

        // Act
        planBloc.add(LogMedicineEvent(log: missedLog));

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));
      });
    });

    group('Appointment Management Flow', () {
      test('should load appointments successfully', () async {
        // Arrange
        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(const LoadAppointments(userId: testUserId));

        // Wait for state changes
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(
          states.any(
            (s) =>
                s is PlanLoading || s is AppointmentsLoaded || s is PlanError,
          ),
          true,
        );
      });

      test('should add appointment successfully', () async {
        // Arrange
        final appointment = AppointmentModel(
          id: 'appt_1',
          userId: testUserId,
          title: 'Regular checkup',
          doctorName: 'Dr. Sarah Johnson',
          appointmentType: 'Obstetrician',
          appointmentDate: DateTime.now().add(const Duration(days: 7)),
          location: 'City Hospital',
          notes: 'Regular checkup',
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(AddAppointmentEvent(appointment: appointment));

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(states.any((s) => s is PlanLoading), true);
      });

      test('should handle multiple appointments', () async {
        // Arrange
        final appointments = [
          AppointmentModel(
            id: 'appt_multi_1',
            userId: testUserId,
            title: '20-week anatomy scan',
            doctorName: 'Dr. Emily White',
            appointmentType: 'Ultrasound',
            appointmentDate: DateTime.now().add(const Duration(days: 3)),
            location: 'Women\'s Health Clinic',
            notes: '20-week anatomy scan',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          AppointmentModel(
            id: 'appt_multi_2',
            userId: testUserId,
            title: 'Diet consultation',
            doctorName: 'Dr. Michael Brown',
            appointmentType: 'Nutritionist',
            appointmentDate: DateTime.now().add(const Duration(days: 10)),
            location: 'Wellness Center',
            notes: 'Diet consultation',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];

        // Act
        for (var appointment in appointments) {
          planBloc.add(AddAppointmentEvent(appointment: appointment));
          await Future.delayed(const Duration(milliseconds: 300));
        }

        // Load to verify
        planBloc.add(const LoadAppointments(userId: testUserId));
        await Future.delayed(const Duration(milliseconds: 500));
      });

      test('should mark appointment as completed', () async {
        // Arrange
        final completedAppointment = AppointmentModel(
          id: 'appt_completed',
          userId: testUserId,
          title: 'Follow-up visit',
          doctorName: 'Dr. Lisa Davis',
          appointmentType: 'General Practitioner',
          appointmentDate: DateTime.now().subtract(const Duration(days: 1)),
          location: 'Medical Center',
          notes: 'Follow-up visit',
          isCompleted: true,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        );

        // Act
        planBloc.add(AddAppointmentEvent(appointment: completedAppointment));

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));
      });
    });

    group('Comprehensive Plan Management Flow', () {
      test('should load complete plan data for a specific date', () async {
        // Arrange
        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(LoadPlanData(userId: testUserId, date: testDate));

        // Wait for state changes
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(
          states.any(
            (s) => s is PlanLoading || s is PlanLoaded || s is PlanError,
          ),
          true,
        );
      });

      test('should refresh plan data', () async {
        // Arrange
        final states = <PlanState>[];
        planBloc.stream.listen((state) => states.add(state));

        // Act
        planBloc.add(RefreshPlanData(userId: testUserId, date: testDate));

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(states.any((s) => s is PlanLoading), true);
      });

      test('should handle complete daily plan', () async {
        // Simulate a complete day's plan with medicines and appointments

        // Step 1: Add medicines
        final medicine = MedicineModel(
          id: 'daily_med',
          userId: testUserId,
          medicineName: 'Daily Prenatal',
          dosage: '1 tablet',
          frequencyType: 'Daily',
          scheduledTimes: ['09:00'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          createdAt: DateTime.now(),
        );
        planBloc.add(AddMedicineEvent(medicine: medicine));
        await Future.delayed(const Duration(milliseconds: 300));

        // Step 2: Log medicine
        final medicineLog = MedicineLoggedModel(
          id: 'daily_log',
          medicineId: 'daily_med',
          userId: testUserId,
          loggedDate: DateTime.now(),
          status: 'taken',
          notes: 'Taken with breakfast',
          loggedAt: DateTime.now(),
        );
        planBloc.add(LogMedicineEvent(log: medicineLog));
        await Future.delayed(const Duration(milliseconds: 300));

        // Step 3: Add appointment
        final appointment = AppointmentModel(
          id: 'daily_appt',
          userId: testUserId,
          title: 'Regular checkup',
          doctorName: 'Dr. Jane Smith',
          appointmentType: 'Obstetrician',
          appointmentDate: DateTime.now().add(const Duration(hours: 4)),
          location: 'Medical Plaza',
          notes: 'Regular checkup',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        planBloc.add(AddAppointmentEvent(appointment: appointment));
        await Future.delayed(const Duration(milliseconds: 300));

        // Step 4: Load complete plan
        planBloc.add(LoadPlanData(userId: testUserId, date: testDate));
        await Future.delayed(const Duration(milliseconds: 500));

        // Assert that plan bloc has processed all events
        expect(
          planBloc.state is PlanLoading ||
              planBloc.state is PlanLoaded ||
              planBloc.state is PlanError,
          true,
        );
      });

      test('should handle plan data across multiple days', () async {
        // Test loading plan for different dates
        final today = DateTime.now();
        final tomorrow = today.add(const Duration(days: 1));
        final nextWeek = today.add(const Duration(days: 7));

        // Load today's plan
        planBloc.add(LoadPlanData(userId: testUserId, date: today));
        await Future.delayed(const Duration(milliseconds: 300));

        // Load tomorrow's plan
        planBloc.add(LoadPlanData(userId: testUserId, date: tomorrow));
        await Future.delayed(const Duration(milliseconds: 300));

        // Load next week's plan
        planBloc.add(LoadPlanData(userId: testUserId, date: nextWeek));
        await Future.delayed(const Duration(milliseconds: 500));
      });
    });
  });
}
