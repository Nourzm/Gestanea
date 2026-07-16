/// Notification Model for storing FCM notifications locally
class NotificationModel {
  final String id;
  final String? userId; // Optional - for user-specific notifications
  final String title;
  final String body;
  final String? imageUrl;
  final String? topic; // Topic subscription (e.g., 'reminders', 'news', 'motivational')
  final Map<String, dynamic>? data; // Additional data payload
  final DateTime receivedAt;
  final bool isRead;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    this.userId,
    required this.title,
    required this.body,
    this.imageUrl,
    this.topic,
    this.data,
    required this.receivedAt,
    this.isRead = false,
    this.readAt,
  });

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'topic': topic,
      'data': data != null ? data.toString() : null, // Store as string
      'received_at': receivedAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
      'read_at': readAt?.toIso8601String(),
    };
  }

  /// Create from Map (database result)
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['user_id'] as String?,
      title: map['title'] as String,
      body: map['body'] as String,
      imageUrl: map['image_url'] as String?,
      topic: map['topic'] as String?,
      data: null, // Data stored as string, can be parsed if needed
      receivedAt: DateTime.parse(map['received_at'] as String),
      isRead: (map['is_read'] as int? ?? 0) == 1,
      readAt: map['read_at'] != null
          ? DateTime.parse(map['read_at'] as String)
          : null,
    );
  }

  /// Create a copy with modified fields
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? imageUrl,
    String? topic,
    Map<String, dynamic>? data,
    DateTime? receivedAt,
    bool? isRead,
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      topic: topic ?? this.topic,
      data: data ?? this.data,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }
}
