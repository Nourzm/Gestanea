class Tip {
  final String id;
  final String title;
  final String content;
  final String category; // 'pregnancy', 'baby_care', 'nutrition', 'exercise', 'mental_health'
  final String? stage; // '1st_trimester', '2nd_trimester', '3rd_trimester', '0-3months', '3-6months', '6-12months'
  final String? imageUrl;
  final DateTime createdAt;

  Tip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.stage,
    this.imageUrl,
    required this.createdAt,
  });

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      stage: map['stage'] as String?,
      imageUrl: map['image_url'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'stage': stage,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
