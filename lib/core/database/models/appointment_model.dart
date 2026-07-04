class AppointmentModel {
  final String id;
  final String userId;
  final String? babyId;
  final String title;
  final String? doctorName;
  final String? appointmentType;
  final DateTime appointmentDate;
  final String? location;
  final String? notes;
  final DateTime? reminderTime;
  final bool isCompleted;
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    this.babyId,
    required this.title,
    this.doctorName,
    this.appointmentType,
    required this.appointmentDate,
    this.location,
    this.notes,
    this.reminderTime,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'baby_id': babyId,
      'title': title,
      'doctor_name': doctorName,
      'appointment_type': appointmentType,
      'appointment_date': appointmentDate.toIso8601String(),
      'location': location,
      'notes': notes,
      'reminder_time': reminderTime?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      babyId: map['baby_id'] as String?,
      title: map['title'] as String,
      doctorName: map['doctor_name'] as String?,
      appointmentType: map['appointment_type'] as String?,
      appointmentDate: DateTime.parse(map['appointment_date'] as String),
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      reminderTime: map['reminder_time'] != null
          ? DateTime.parse(map['reminder_time'] as String)
          : null,
      isCompleted: (map['is_completed'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? babyId,
    String? title,
    String? doctorName,
    String? appointmentType,
    DateTime? appointmentDate,
    String? location,
    String? notes,
    DateTime? reminderTime,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      babyId: babyId ?? this.babyId,
      title: title ?? this.title,
      doctorName: doctorName ?? this.doctorName,
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
