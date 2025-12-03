class RiskAlertModel {
  final String id;
  final String userId;
  final String alertType;
  final String severity;
  final String message;
  final String? recommendation;
  final bool isResolved;
  final DateTime detectedAt;
  final DateTime?  resolvedAt;
  final DateTime createdAt;

  RiskAlertModel({
    required this.id,
    required this. userId,
    required this.alertType,
    required this.severity,
    required this.message,
    this.recommendation,
    this.isResolved = false,
    required this.detectedAt,
    this.resolvedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'alert_type': alertType,
      'severity': severity,
      'message': message,
      'recommendation': recommendation,
      'is_resolved': isResolved ? 1 : 0,
      'detected_at': detectedAt. toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RiskAlertModel.fromMap(Map<String, dynamic> map) {
    return RiskAlertModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      alertType: map['alert_type'] as String,
      severity: map['severity'] as String,
      message: map['message'] as String,
      recommendation: map['recommendation'] as String?,
      isResolved: (map['is_resolved'] as int) == 1,
      detectedAt: DateTime.parse(map['detected_at'] as String),
      resolvedAt: map['resolved_at'] != null
          ? DateTime.parse(map['resolved_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  RiskAlertModel copyWith({
    String? id,
    String? userId,
    String? alertType,
    String? severity,
    String? message,
    String? recommendation,
    bool?  isResolved,
    DateTime?  detectedAt,
    DateTime?  resolvedAt,
    DateTime?  createdAt,
  }) {
    return RiskAlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      alertType: alertType ?? this.alertType,
      severity: severity ??  this.severity,
      message: message ?? this.message,
      recommendation: recommendation ?? this.recommendation,
      isResolved: isResolved ?? this.isResolved,
      detectedAt: detectedAt ?? this.detectedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}