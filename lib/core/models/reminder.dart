class Reminder {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime time;
  final String type; // 'appointment', 'medicine', 'kick_count', 'custom'
  final bool isCompleted;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    required this.type,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      type: map['type'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'type': type,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
