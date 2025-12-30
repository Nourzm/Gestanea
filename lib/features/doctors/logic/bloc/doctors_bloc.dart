import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/core/database/models/doctor_filter_model.dart';
import 'package:gestanea/core/services/doctor_api_service.dart';
import 'doctors_event.dart';
import 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  // Remove the repository dependency since we're using static methods
  DoctorsBloc() : super(DoctorsInitial()) {
    on<LoadDoctors>(_onLoadDoctors);
    on<SearchDoctors>(_onSearchDoctors);
    on<FilterDoctors>(_onFilterDoctors);
    on<SortDoctors>(_onSortDoctors);
    on<ClearFilters>(_onClearFilters);
    on<SelectLocation>(_onSelectLocation);
  }

  // State variables
  String _currentQuery = '';
  DoctorFilter _currentFilter = DoctorFilter();
  String _currentSort = 'distance';
  String _selectedLocation = 'Use current location';
  double? _userLat;
  double? _userLon;
  List<DoctorModel> _allDoctors = [];

  Future<void> _onLoadDoctors(
    LoadDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    emit(DoctorsLoading());
    try {
      // Update user location
      _userLat = event.userLat;
      _userLon = event.userLon;

      // Fetch doctors from API
      await _fetchAndEmit(emit);
    } catch (e) {
      emit(DoctorsError(e.toString()));
    }
  }

  Future<void> _onSearchDoctors(
    SearchDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    _currentQuery = event.query;
    await _fetchAndEmit(emit);
  }

  Future<void> _onFilterDoctors(
    FilterDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    _currentFilter = event.filter;
    await _fetchAndEmit(emit);
  }

  Future<void> _onSortDoctors(
    SortDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    _currentSort = event.sortBy;
    await _fetchAndEmit(emit);
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<DoctorsState> emit,
  ) async {
    _currentQuery = '';
    _currentFilter = DoctorFilter();
    _currentSort = 'distance';
    await _fetchAndEmit(emit);
  }

  Future<void> _onSelectLocation(
    SelectLocation event,
    Emitter<DoctorsState> emit,
  ) async {
    _selectedLocation = event.location;
    await _fetchAndEmit(emit);
  }

  Future<void> _fetchAndEmit(Emitter<DoctorsState> emit) async {
    try {
      // Prepare specialty filter
      String? singleSpecialty;
      if (_currentFilter.specialties != null &&
          _currentFilter.specialties!.isNotEmpty) {
        singleSpecialty = _currentFilter.specialties!.first;
      }

      // Fetch doctors from API with filters - call static method directly
      final doctors = await DoctorApiService.getDoctors(
        search: _currentQuery.isEmpty ? null : _currentQuery,
        wilaya: _selectedLocation,
        specialty: singleSpecialty,
        gender: _currentFilter.gender,
        minRating: _currentFilter.minRating,
        minReviews: _currentFilter.minReviews,
        maxDistance: _currentFilter.maxDistance,
        userLat: _userLat,
        userLon: _userLon,
        sortBy: _currentSort,
      );

      // Store all doctors for reference
      _allDoctors = doctors;

      // Apply additional client-side filtering if multiple specialties selected
      List<DoctorModel> filtered = doctors;
      if (_currentFilter.specialties != null &&
          _currentFilter.specialties!.length > 1) {
        filtered = filtered
            .where(
              (doctor) =>
                  _currentFilter.specialties!.contains(doctor.specialty),
            )
            .toList();
      }

      // Emit loaded state
      emit(
        DoctorsLoaded(
          doctors: filtered,
          allDoctors: _allDoctors,
          hasActiveFilters:
              _currentFilter.hasActiveFilters || _currentQuery.isNotEmpty,
          currentFilter: _currentFilter,
          searchQuery: _currentQuery,
          selectedLocation: _selectedLocation,
        ),
      );
    } catch (e) {
      emit(DoctorsError('Failed to load doctors: ${e.toString()}'));
    }
  }
}
