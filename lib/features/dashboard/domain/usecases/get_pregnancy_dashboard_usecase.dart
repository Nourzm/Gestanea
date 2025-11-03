// lib/features/dashboard/domain/usecases/get_pregnancy_dashboard_usecase.dart
import '../entities/pregnancy_dashboard.dart';

class GetPregnancyDashboardUseCase {
  // TODO: Inject repository when data layer is implemented
  
  Future<PregnancyDashboard> call() async {
    // TODO: Replace with actual data from repository
    // Mock data for now
    return PregnancyDashboard(
      userName: 'Sara',
      currentWeek: 12,
      currentDay: 3,
      trimester: '1st Trimester',
      daysLeft: 228,
      progressPercentage: 18.9,
      upcomingAppointments: [
        AppointmentReminder(
          id: '1',
          title: 'Doctor Checkup',
          dateTime: DateTime.now().add(const Duration(hours: 2)),
          type: 'doctor',
        ),
        AppointmentReminder(
          id: '2',
          title: 'Ultrasound',
          dateTime: DateTime.now().add(const Duration(days: 3)),
          type: 'ultrasound',
        ),
        AppointmentReminder(
          id: '3',
          title: 'Blood Test',
          dateTime: DateTime.now().add(const Duration(days: 7)),
          type: 'test',
        ),
      ],
      medicineReminders: [
        MedicineReminder(
          id: '1',
          medicineName: 'Vitamin D',
          nextDoseTime: DateTime.now().add(const Duration(hours: 2)),
          dosage: '1 tablet',
        ),
        MedicineReminder(
          id: '2',
          medicineName: 'Folic Acid',
          nextDoseTime: DateTime.now().add(const Duration(hours: 8)),
          dosage: '400mcg',
        ),
      ],
      healthAlerts: [
        HealthAlert(
          id: '1',
          message: 'Your blood pressure is slightly elevated',
          severity: 'medium',
          createdAt: DateTime.now(),
        ),
      ],
      tipOfTheDay: 'Stay hydrated! Drink at least 8 glasses of water daily.',
    );
  }
}