class SymptomModel {
  final String id;
  final String userId;
  final String symptomName;
  final String? severity;
  final String? notes;
  final DateTime recordedAt;
  final DateTime createdAt;

  SymptomModel({
    required this.id,
    required this.userId,
    required this.symptomName,
    this.severity,
    this.notes,
    required this.recordedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'symptom_name': symptomName,
      'severity': severity,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SymptomModel.fromMap(Map<String, dynamic> map) {
    return SymptomModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      symptomName: map['symptom_name'] as String,
      severity: map['severity'] as String?,
      notes: map['notes'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  SymptomModel copyWith({
    String? id,
    String? userId,
    String? symptomName,
    String? severity,
    String? notes,
    DateTime? recordedAt,
    DateTime? createdAt,
  }) {
    return SymptomModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symptomName: symptomName ?? this.symptomName,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
