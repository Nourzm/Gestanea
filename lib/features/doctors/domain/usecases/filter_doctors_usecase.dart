import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';
import 'package:gestanea/features/doctors/domain/entities/doctor_entity.dart';

class FilterDoctorsUseCase {
  List<DoctorEntity> execute(List<DoctorEntity> doctors, DoctorFilter filter) {
    List<DoctorEntity> filtered = List.from(doctors);

    // Filter by distance
    if (filter.maxDistance != null) {
      filtered = filtered
          .where((doctor) => doctor.distanceKm <= filter.maxDistance!)
          .toList();
    }

    // Filter by rating
    if (filter.minRating != null) {
      filtered = filtered
          .where((doctor) => doctor.rating >= filter.minRating!)
          .toList();
    }

    // Filter by gender
    if (filter.gender != null && filter.gender!.isNotEmpty) {
      filtered = filtered
          .where((doctor) => doctor.gender == filter.gender)
          .toList();
    }

    // Filter by minimum reviews
    if (filter.minReviews != null) {
      filtered = filtered
          .where((doctor) => doctor.totalReviews >= filter.minReviews!)
          .toList();
    }

    // Filter by specialties
    if (filter.specialties != null && filter.specialties!.isNotEmpty) {
      filtered = filtered
          .where((doctor) => filter.specialties!.contains(doctor.specialty))
          .toList();
    }

    return filtered;
  }

  List<DoctorEntity> sortByDistance(List<DoctorEntity> doctors) {
    final sorted = List<DoctorEntity>.from(doctors);
    sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sorted;
  }

  List<DoctorEntity> sortByRating(List<DoctorEntity> doctors) {
    final sorted = List<DoctorEntity>.from(doctors);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<DoctorEntity> sortByReviews(List<DoctorEntity> doctors) {
    final sorted = List<DoctorEntity>.from(doctors);
    sorted.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
    return sorted;
  }
}
