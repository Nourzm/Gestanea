class UserActivityLogModel {
  final String id;
  final String userId;
  final String activityType;
  final String? activityDetails;
  final String? pageVisited;
  final String? sessionId;
  final DateTime createdAt;

  UserActivityLogModel({
    required this.id,
    required this.userId,
    required this.activityType,
    this.activityDetails,
    this.pageVisited,
    this.sessionId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'activity_type': activityType,
      'activity_details': activityDetails,
      'page_visited': pageVisited,
      'session_id': sessionId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserActivityLogModel.fromMap(Map<String, dynamic> map) {
    return UserActivityLogModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      activityType: map['activity_type'] as String,
      activityDetails: map['activity_details'] as String?,
      pageVisited: map['page_visited'] as String?,
      sessionId: map['session_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  UserActivityLogModel copyWith({
    String? id,
    String? userId,
    String? activityType,
    String? activityDetails,
    String? pageVisited,
    String? sessionId,
    DateTime? createdAt,
  }) {
    return UserActivityLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      activityType: activityType ?? this.activityType,
      activityDetails: activityDetails ?? this.activityDetails,
      pageVisited: pageVisited ?? this.pageVisited,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
