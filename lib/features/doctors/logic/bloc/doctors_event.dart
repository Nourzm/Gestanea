import 'package:gestanea/core/database/models/doctor_filter_model.dart';

class RefreshLocation extends DoctorsEvent {}

abstract class DoctorsEvent {}

class LoadDoctors extends DoctorsEvent {
  final double? userLat;
  final double? userLon;

  LoadDoctors({this.userLat, this.userLon});
}

class SearchDoctors extends DoctorsEvent {
  final String query;

  SearchDoctors(this.query);
}

class FilterDoctors extends DoctorsEvent {
  final DoctorFilter filter;

  FilterDoctors(this.filter);
}

class SortDoctors extends DoctorsEvent {
  final String sortBy; // 'distance', 'rating', 'reviews'

  SortDoctors(this.sortBy);
}

class ClearFilters extends DoctorsEvent {}

class SelectLocation extends DoctorsEvent {
  final String location;

  SelectLocation(this.location);
}
