class ProductReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String reviewerName;
  final int rating;
  final String?  reviewText;
  final DateTime createdAt;

  ProductReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.reviewerName,
    required this.rating,
    this.reviewText,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'reviewer_name': reviewerName,
      'rating': rating,
      'review_text': reviewText,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProductReviewModel. fromMap(Map<String, dynamic> map) {
    return ProductReviewModel(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      userId: map['user_id'] as String,
      reviewerName: map['reviewer_name'] as String,
      rating: map['rating'] as int,
      reviewText: map['review_text'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ProductReviewModel copyWith({
    String?  id,
    String? productId,
    String? userId,
    String? reviewerName,
    int? rating,
    String? reviewText,
    DateTime?  createdAt,
  }) {
    return ProductReviewModel(
      id: id ?? this. id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      reviewerName: reviewerName ?? this.reviewerName,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}