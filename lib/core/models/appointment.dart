class Appointment {
  final String id;
  final String userId;
  final String? pregnancyId;
  final String? babyId;
  final String? doctorId;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime time;
  final String? location;
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    this.pregnancyId,
    this.babyId,
    this.doctorId,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    this.location,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      babyId: map['baby_id'] as String?,
      doctorId: map['doctor_id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      location: map['location'] as String?,
      status: map['status'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pregnancy_id': pregnancyId,
      'baby_id': babyId,
      'doctor_id': doctorId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'location': location,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
