class LabResult {
  final String id;
  final String userId;
  final String? pregnancyId;
  final DateTime date;
  final String testName;
  final double value;
  final String unit;
  final String? referenceRange;
  final String status; // 'normal', 'abnormal', 'critical'
  final String? notes;
  final DateTime createdAt;

  LabResult({
    required this.id,
    required this.userId,
    this.pregnancyId,
    required this.date,
    required this.testName,
    required this.value,
    required this.unit,
    this.referenceRange,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory LabResult.fromMap(Map<String, dynamic> map) {
    return LabResult(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      date: DateTime.parse(map['date'] as String),
      testName: map['test_name'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      referenceRange: map['reference_range'] as String?,
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
      'date': date.toIso8601String(),
      'test_name': testName,
      'value': value,
      'unit': unit,
      'reference_range': referenceRange,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
