import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/features/doctors/data/datasources/mock_doctor_data.dart';
import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';
import 'doctors_event.dart';
import 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  DoctorsBloc() : super(DoctorsInitial()) {
    on<LoadDoctors>(_onLoadDoctors);
    on<SearchDoctors>(_onSearchDoctors);
    on<FilterDoctors>(_onFilterDoctors);
    on<SortDoctors>(_onSortDoctors);
    on<ClearFilters>(_onClearFilters);
  }

  List<DoctorModel> _allDoctors = [];
  String _currentQuery = '';
  DoctorFilter _currentFilter = DoctorFilter();
  String _currentSort = 'none';

  void _onLoadDoctors(LoadDoctors event, Emitter<DoctorsState> emit) {
    emit(DoctorsLoading());
    try {
      _allDoctors = MockDoctorData.getDoctors();
      _applyFiltersAndEmit(emit);
    } catch (e) {
      emit(DoctorsError(e.toString()));
    }
  }

  void _onSearchDoctors(SearchDoctors event, Emitter<DoctorsState> emit) {
    _currentQuery = event.query;
    _applyFiltersAndEmit(emit);
  }

  void _onFilterDoctors(FilterDoctors event, Emitter<DoctorsState> emit) {
    _currentFilter = event.filter;
    _applyFiltersAndEmit(emit);
  }

  void _onSortDoctors(SortDoctors event, Emitter<DoctorsState> emit) {
    _currentSort = event.sortBy;
    _applyFiltersAndEmit(emit);
  }

  void _onClearFilters(ClearFilters event, Emitter<DoctorsState> emit) {
    _currentQuery = '';
    _currentFilter = DoctorFilter();
    _currentSort = 'none';
    _applyFiltersAndEmit(emit);
  }

  void _applyFiltersAndEmit(Emitter<DoctorsState> emit) {
    List<DoctorModel> filtered = List.from(_allDoctors);

    // Apply search
    if (_currentQuery.isNotEmpty) {
      final query = _currentQuery.toLowerCase().trim();
      filtered = filtered.where((doctor) {
        final matchesName = doctor.name.toLowerCase().contains(query);
        final matchesSpecialty = (doctor.specialty ?? '')
            .toLowerCase()
            .contains(query);
        return matchesName || matchesSpecialty;
      }).toList();
    }

    // Apply filters
    if (_currentFilter.maxDistance != null) {
      filtered = filtered
          .where(
            (doctor) => (doctor.distance ?? 0) <= _currentFilter.maxDistance!,
          )
          .toList();
    }

    if (_currentFilter.minRating != null) {
      filtered = filtered
          .where((doctor) => (doctor.rating ?? 0) >= _currentFilter.minRating!)
          .toList();
    }

    if (_currentFilter.gender != null && _currentFilter.gender!.isNotEmpty) {
      filtered = filtered
          .where((doctor) => doctor.gender == _currentFilter.gender)
          .toList();
    }

    if (_currentFilter.minReviews != null) {
      filtered = filtered
          .where((doctor) => doctor.reviewsCount >= _currentFilter.minReviews!)
          .toList();
    }

    if (_currentFilter.specialties != null &&
        _currentFilter.specialties!.isNotEmpty) {
      filtered = filtered
          .where(
            (doctor) => _currentFilter.specialties!.contains(doctor.specialty),
          )
          .toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case 'distance':
        filtered.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
        break;
      case 'rating':
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'reviews':
        filtered.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
    }

    emit(
      DoctorsLoaded(
        doctors: filtered,
        allDoctors: _allDoctors,
        hasActiveFilters:
            _currentFilter.hasActiveFilters || _currentQuery.isNotEmpty,
        currentFilter: _currentFilter,
        searchQuery: _currentQuery,
      ),
    );
  }

  List<String> getAllSpecialties() {
    return _allDoctors
        .map((doctor) => doctor.specialty ?? '')
        .where((specialty) => specialty.isNotEmpty)
        .toSet()
        .toList();
  }
}
