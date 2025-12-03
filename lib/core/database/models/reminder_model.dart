class ReminderModel {
  final String id;
  final String userId;
  final String reminderType;
  final String?  referenceId;
  final String title;
  final String?  description;
  final DateTime reminderTime;
  final String? repeatPattern;
  final bool isCompleted;
  final DateTime?  completedAt;
  final DateTime createdAt;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.reminderType,
    this.referenceId,
    required this.title,
    this.description,
    required this.reminderTime,
    this.repeatPattern,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'reminder_type': reminderType,
      'reference_id': referenceId,
      'title': title,
      'description': description,
      'reminder_time': reminderTime.toIso8601String(),
      'repeat_pattern': repeatPattern,
      'is_completed': isCompleted ? 1 : 0,
      'completed_at': completedAt?. toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      reminderType: map['reminder_type'] as String,
      referenceId: map['reference_id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      reminderTime: DateTime.parse(map['reminder_time'] as String),
      repeatPattern: map['repeat_pattern'] as String?,
      isCompleted: (map['is_completed'] as int) == 1,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ReminderModel copyWith({
    String? id,
    String? userId,
    String? reminderType,
    String? referenceId,
    String? title,
    String? description,
    DateTime? reminderTime,
    String? repeatPattern,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reminderType: reminderType ?? this.reminderType,
      referenceId: referenceId ?? this.referenceId,
      title: title ?? this. title,
      description: description ??  this.description,
      reminderTime: reminderTime ?? this. reminderTime,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}