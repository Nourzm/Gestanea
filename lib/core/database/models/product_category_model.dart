import 'dart:convert';

class ProductCategoryModel {
  final String id;
  final String? name;
  final String? imageUrl;
  final int? displayOrder;
  final DateTime createdAt;
  final Map<String, dynamic>? translations;

  ProductCategoryModel({
    required this.id,
    this.name,
    this.imageUrl,
    this.displayOrder,
    required this.createdAt,
    this.translations,
  });

  /// Get translated name based on language code
  String getTranslatedName(String languageCode) {
    // If translations exist and contain the language, use it
    if (translations != null && translations!.containsKey(languageCode)) {
      final translation = translations![languageCode];
      if (translation is Map<String, dynamic> &&
          translation.containsKey('name')) {
        return translation['name'] as String;
      }
    }
    // Fallback to default name or ID
    return name ?? id;
  }

  /// Get translated description based on language code
  String? getTranslatedDescription(String languageCode) {
    if (translations != null && translations!.containsKey(languageCode)) {
      final translation = translations![languageCode];
      if (translation is Map<String, dynamic> &&
          translation.containsKey('description')) {
        return translation['description'] as String;
      }
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'translations': translations != null ? jsonEncode(translations) : null,
    };
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? parsedTranslations;
    if (map['translations'] != null) {
      try {
        if (map['translations'] is String) {
          parsedTranslations =
              jsonDecode(map['translations'] as String) as Map<String, dynamic>;
        } else if (map['translations'] is Map) {
          parsedTranslations = Map<String, dynamic>.from(
            map['translations'] as Map,
          );
        }
      } catch (e) {
        // If parsing fails, leave translations as null
        parsedTranslations = null;
      }
    }

    return ProductCategoryModel(
      id: map['id'] as String,
      name: map['name'] as String?,
      imageUrl: map['image_url'] as String?,
      displayOrder: map['display_order'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      translations: parsedTranslations,
    );
  }

  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? displayOrder,
    DateTime? createdAt,
    Map<String, dynamic>? translations,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      translations: translations ?? this.translations,
    );
  }
}
