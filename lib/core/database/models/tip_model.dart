class TipModel {
  final String id;
  final String title;
  final String content;
  final String? category;
  final String? targetAudience;
  final String? imageUrl;
  final String? source;
  final bool isActive;
  final DateTime createdAt;

  TipModel({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    this.targetAudience,
    this.imageUrl,
    this.source,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'target_audience': targetAudience,
      'image_url': imageUrl,
      'source': source,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String?,
      targetAudience: map['target_audience'] as String?,
      imageUrl: map['image_url'] as String?,
      source: map['source'] as String?,
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  TipModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? targetAudience,
    String? imageUrl,
    String? source,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      targetAudience: targetAudience ?? this.targetAudience,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
