class MedicineLoggedModel {
  final String id;
  final String medicineId;
  final String userId;
  final DateTime loggedDate;
  final String status;
  final String? notes;
  final DateTime loggedAt;

  MedicineLoggedModel({
    required this.id,
    required this. medicineId,
    required this.userId,
    required this. loggedDate,
    required this.status,
    this.notes,
    required this.loggedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'user_id': userId,
      'logged_date': loggedDate.toIso8601String(). split('T')[0],
      'status': status,
      'notes': notes,
      'logged_at': loggedAt.toIso8601String(),
    };
  }

  factory MedicineLoggedModel.fromMap(Map<String, dynamic> map) {
    return MedicineLoggedModel(
      id: map['id'] as String,
      medicineId: map['medicine_id'] as String,
      userId: map['user_id'] as String,
      loggedDate: DateTime.parse(map['logged_date'] as String),
      status: map['status'] as String,
      notes: map['notes'] as String?,
      loggedAt: DateTime. parse(map['logged_at'] as String),
    );
  }

  MedicineLoggedModel copyWith({
    String?  id,
    String? medicineId,
    String? userId,
    DateTime? loggedDate,
    String? status,
    String? notes,
    DateTime?  loggedAt,
  }) {
    return MedicineLoggedModel(
      id: id ??  this.id,
      medicineId: medicineId ?? this. medicineId,
      userId: userId ?? this.userId,
      loggedDate: loggedDate ??  this.loggedDate,
      status: status ?? this.status,
      notes: notes ?? this. notes,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }
}