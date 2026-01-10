import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:uuid/uuid.dart';

class PlanMockData {
  static final _uuid = Uuid();

  // Mock user ID for demonstration
  static const String mockUserId = 'user123';

  /// Returns mock medicine data for demonstration purposes
  static List<MedicineModel> getMockMedicines() {
    final now = DateTime.now();

    return [
      MedicineModel(
        id: _uuid.v4(),
        userId: mockUserId,
        medicineName: 'Captopril',
        dosage: '2 Capsules',
        type: 'Capsule',
        frequencyType: 'Daily',
        scheduledTimes: ['20:00'],
        startDate: now,
        isActive: true,
        createdAt: now,
      ),
      MedicineModel(
        id: _uuid.v4(),
        userId: mockUserId,
        medicineName: 'B 12',
        dosage: '1 Injection',
        type: 'Injection',
        frequencyType: 'Daily',
        scheduledTimes: ['22:00'],
        startDate: now,
        isActive: true,
        createdAt: now,
      ),
      MedicineModel(
        id: _uuid.v4(),
        userId: mockUserId,
        medicineName: 'I-DROP MGD',
        dosage: '2 Drops',
        type: 'Drops',
        frequencyType: 'Daily',
        scheduledTimes: ['22:00'],
        startDate: now,
        isActive: true,
        createdAt: now,
      ),
      MedicineModel(
        id: _uuid.v4(),
        userId: mockUserId,
        medicineName: 'Niacin',
        dosage: '0.5 Pill',
        type: 'Pill',
        frequencyType: 'Daily',
        scheduledTimes: ['22:00'],
        startDate: now,
        isActive: true,
        createdAt: now,
      ),
    ];
  }

  /// Returns mock medicine logs (1 taken, 2 missed) for demonstration purposes
  static List<MedicineLoggedModel> getMockMedicineLogs(
    List<MedicineModel> medicines,
  ) {
    final now = DateTime.now();

    if (medicines.length < 4) return [];

    return [
      MedicineLoggedModel(
        id: _uuid.v4(),
        medicineId: medicines[1].id,
        userId: mockUserId,
        loggedDate: now,
        status: 'taken',
        loggedAt: now,
      ),
      MedicineLoggedModel(
        id: _uuid.v4(),
        medicineId: medicines[2].id,
        userId: mockUserId,
        loggedDate: now,
        status: 'missed',
        loggedAt: now,
      ),
      MedicineLoggedModel(
        id: _uuid.v4(),
        medicineId: medicines[3].id,
        userId: mockUserId,
        loggedDate: now,
        status: 'missed',
        loggedAt: now,
      ),
    ];
  }

  /// Returns mock appointment data for demonstration purposes
  static List<AppointmentModel> getMockAppointments() {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    return [
      AppointmentModel(
        id: _uuid.v4(),
        userId: mockUserId,
        title: 'Follow-up Visit',
        doctorName: 'Dr. Sarah Johnson',
        appointmentType: 'Checkup',
        appointmentDate: tomorrow.copyWith(hour: 10, minute: 0),
        location: 'General Hospital',
        isCompleted: false,
        createdAt: now,
      ),
      AppointmentModel(
        id: _uuid.v4(),
        userId: mockUserId,
        title: 'Radiology Appointment',
        doctorName: null,
        appointmentType: 'Imaging',
        appointmentDate: DateTime(2025, 2, 5, 14, 30),
        location: 'Radiology Dept',
        isCompleted: false,
        createdAt: now,
      ),
      AppointmentModel(
        id: _uuid.v4(),
        userId: mockUserId,
        title: 'Blood Test',
        doctorName: null,
        appointmentType: 'Lab Test',
        appointmentDate: DateTime(2025, 2, 10, 9, 0),
        location: 'Lab Services',
        isCompleted: false,
        createdAt: now,
      ),
    ];
  }

  /// Helper to get medicine statistics
  static Map<String, int> getMedicineStats(
    List<MedicineModel> medicines,
    List<MedicineLoggedModel> logs,
  ) {
    return {
      'total': medicines.length,
      'taken': logs.where((l) => l.status == 'taken').length,
      'missed': logs.where((l) => l.status == 'missed').length,
    };
  }
}
