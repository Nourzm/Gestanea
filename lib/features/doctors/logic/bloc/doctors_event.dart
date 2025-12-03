import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';

abstract class DoctorsEvent {}

class LoadDoctors extends DoctorsEvent {}

class SearchDoctors extends DoctorsEvent {
  final String query;

  SearchDoctors(this.query);
}

class FilterDoctors extends DoctorsEvent {
  final DoctorFilter filter;

  FilterDoctors(this.filter);
}

class SortDoctors extends DoctorsEvent {
  final String sortBy; // 'distance', 'rating', 'reviews', 'none'

  SortDoctors(this.sortBy);
}

class ClearFilters extends DoctorsEvent {}
