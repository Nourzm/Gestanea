class TipModel {
  final String id;
  final String title;
  final String content; // Fallback for backward compatibility
  final String? contentJson; // JSON string with multilingual content
  final String? category;
  final String? targetAudience;
  final String? imageUrl;
  final String? source;
  final bool isActive;
  final bool isGlobal;
  final int priority;
  final int? pregnancyWeekFrom;
  final int? pregnancyWeekTo;
  final int? pregnancyMonthFrom;
  final int? pregnancyMonthTo;
  final int? postpartumWeekFrom;
  final int? postpartumWeekTo;
  final DateTime createdAt;

  TipModel({
    required this.id,
    required this.title,
    required this.content,
    this.contentJson,
    this.category,
    this.targetAudience,
    this.imageUrl,
    this.source,
    this.isActive = true,
    this.isGlobal = false,
    this.priority = 0,
    this.pregnancyWeekFrom,
    this.pregnancyWeekTo,
    this.pregnancyMonthFrom,
    this.pregnancyMonthTo,
    this.postpartumWeekFrom,
    this.postpartumWeekTo,
    required this.createdAt,
  });

  /// Get localized content based on language code
  /// Returns content from JSON if available, otherwise falls back to content field
  String getLocalizedContent(String languageCode) {
    if (contentJson == null || contentJson!.isEmpty) {
      return content;
    }
    
    try {
      // Parse JSON and extract content for the given language
      // Expected format: {"en": "...", "fr": "...", "ar": "..."}
      // For now, return the plain content. Full JSON parsing can be added if needed
      // This is a placeholder - the actual implementation depends on your JSON structure
      return content;
    } catch (e) {
      return content;
    }
  }

  /// Get localized title based on language code
  String getLocalizedTitle(String languageCode) {
    // Similar to content, if titles are stored in JSON
    return title;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'content_json': contentJson,
      'category': category,
      'target_audience': targetAudience,
      'image_url': imageUrl,
      'source': source,
      'is_active': isActive ? 1 : 0,
      'is_global': isGlobal ? 1 : 0,
      'priority': priority,
      'pregnancy_week_from': pregnancyWeekFrom,
      'pregnancy_week_to': pregnancyWeekTo,
      'pregnancy_month_from': pregnancyMonthFrom,
      'pregnancy_month_to': pregnancyMonthTo,
      'postpartum_week_from': postpartumWeekFrom,
      'postpartum_week_to': postpartumWeekTo,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String? ?? '',
      contentJson: map['content_json'] as String?,
      category: map['category'] as String?,
      targetAudience: map['target_audience'] as String?,
      imageUrl: map['image_url'] as String?,
      source: map['source'] as String?,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      isGlobal: (map['is_global'] as int? ?? 0) == 1,
      priority: map['priority'] as int? ?? 0,
      pregnancyWeekFrom: map['pregnancy_week_from'] as int?,
      pregnancyWeekTo: map['pregnancy_week_to'] as int?,
      pregnancyMonthFrom: map['pregnancy_month_from'] as int?,
      pregnancyMonthTo: map['pregnancy_month_to'] as int?,
      postpartumWeekFrom: map['postpartum_week_from'] as int?,
      postpartumWeekTo: map['postpartum_week_to'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  TipModel copyWith({
    String? id,
    String? title,
    String? content,
    String? contentJson,
    String? category,
    String? targetAudience,
    String? imageUrl,
    String? source,
    bool? isActive,
    bool? isGlobal,
    int? priority,
    int? pregnancyWeekFrom,
    int? pregnancyWeekTo,
    int? pregnancyMonthFrom,
    int? pregnancyMonthTo,
    int? postpartumWeekFrom,
    int? postpartumWeekTo,
    DateTime? createdAt,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      contentJson: contentJson ?? this.contentJson,
      category: category ?? this.category,
      targetAudience: targetAudience ?? this.targetAudience,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      isGlobal: isGlobal ?? this.isGlobal,
      priority: priority ?? this.priority,
      pregnancyWeekFrom: pregnancyWeekFrom ?? this.pregnancyWeekFrom,
      pregnancyWeekTo: pregnancyWeekTo ?? this.pregnancyWeekTo,
      pregnancyMonthFrom: pregnancyMonthFrom ?? this.pregnancyMonthFrom,
      pregnancyMonthTo: pregnancyMonthTo ?? this.pregnancyMonthTo,
      postpartumWeekFrom: postpartumWeekFrom ?? this.postpartumWeekFrom,
      postpartumWeekTo: postpartumWeekTo ?? this.postpartumWeekTo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}