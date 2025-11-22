class DoctorFilter {
  final double? maxDistance;
  final double? minRating;
  final String? gender;
  final int? minReviews;
  final List<String>? specialties;

  DoctorFilter({
    this.maxDistance,
    this.minRating,
    this.gender,
    this.minReviews,
    this.specialties,
  });

  DoctorFilter copyWith({
    double? maxDistance,
    double? minRating,
    String? gender,
    int? minReviews,
    List<String>? specialties,
  }) {
    return DoctorFilter(
      maxDistance: maxDistance ?? this.maxDistance,
      minRating: minRating ?? this.minRating,
      gender: gender ?? this.gender,
      minReviews: minReviews ?? this.minReviews,
      specialties: specialties ?? this.specialties,
    );
  }

  bool get hasActiveFilters =>
      maxDistance != null ||
      minRating != null ||
      gender != null ||
      minReviews != null ||
      (specialties != null && specialties!.isNotEmpty);

  void clear() {
    // Helper method - actual clearing done via copyWith in state
  }
}
