class RiskAlert {
  final String id;
  final String userId;
  final String? pregnancyId;
  final String alertType;
  final String severity; // 'low', 'medium', 'high', 'critical'
  final String message;
  final String? recommendations;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  RiskAlert({
    required this.id,
    required this.userId,
    this.pregnancyId,
    required this.alertType,
    required this.severity,
    required this.message,
    this.recommendations,
    required this.isResolved,
    required this.createdAt,
    this.resolvedAt,
  });

  factory RiskAlert.fromMap(Map<String, dynamic> map) {
    return RiskAlert(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      alertType: map['alert_type'] as String,
      severity: map['severity'] as String,
      message: map['message'] as String,
      recommendations: map['recommendations'] as String?,
      isResolved: (map['is_resolved'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      resolvedAt: map['resolved_at'] != null ? DateTime.parse(map['resolved_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pregnancy_id': pregnancyId,
      'alert_type': alertType,
      'severity': severity,
      'message': message,
      'recommendations': recommendations,
      'is_resolved': isResolved ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  RiskAlert copyWith({
    String? id,
    String? userId,
    String? pregnancyId,
    String? alertType,
    String? severity,
    String? message,
    String? recommendations,
    bool? isResolved,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return RiskAlert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      message: message ?? this.message,
      recommendations: recommendations ?? this.recommendations,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
