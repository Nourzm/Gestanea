import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/core/database/models/doctor_filter_model.dart';

abstract class DoctorsState {}

class DoctorsInitial extends DoctorsState {}

class DoctorsLoading extends DoctorsState {}

class DoctorsLoaded extends DoctorsState {
  final List<DoctorModel> doctors;
  final List<DoctorModel> allDoctors;
  final bool hasActiveFilters;
  final DoctorFilter currentFilter;
  final String searchQuery;
  final String selectedLocation;
  final double? userLatitude;
  final double? userLongitude;

  DoctorsLoaded({
    required this.doctors,
    required this.allDoctors,
    required this.hasActiveFilters,
    required this.currentFilter,
    required this.searchQuery,
    required this.selectedLocation,
    this.userLatitude,
    this.userLongitude,
  });
}

class DoctorsError extends DoctorsState {
  final String message;

  DoctorsError(this.message);
}
