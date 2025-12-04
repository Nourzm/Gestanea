class MedicineLog {
  final String id;
  final String medicineId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final String status; // 'taken', 'skipped', 'missed'
  final String? notes;
  final DateTime createdAt;

  MedicineLog({
    required this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory MedicineLog.fromMap(Map<String, dynamic> map) {
    return MedicineLog(
      id: map['id'] as String,
      medicineId: map['medicine_id'] as String,
      scheduledTime: DateTime.parse(map['scheduled_time'] as String),
      takenTime: map['taken_time'] != null ? DateTime.parse(map['taken_time'] as String) : null,
      status: map['status'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'taken_time': takenTime?.toIso8601String(),
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
