class UserSavedTipModel {
  final String id;
  final String userId;
  final String tipId;
  final DateTime savedAt;

  UserSavedTipModel({
    required this.id,
    required this.userId,
    required this.tipId,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'tip_id': tipId,
      'saved_at': savedAt.toIso8601String(),
    };
  }

  factory UserSavedTipModel.fromMap(Map<String, dynamic> map) {
    return UserSavedTipModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      tipId: map['tip_id'] as String,
      savedAt: DateTime.parse(map['saved_at'] as String),
    );
  }

  UserSavedTipModel copyWith({
    String? id,
    String? userId,
    String? tipId,
    DateTime? savedAt,
  }) {
    return UserSavedTipModel(
      id: id ?? this. id,
      userId: userId ??  this.userId,
      tipId: tipId ?? this.tipId,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}