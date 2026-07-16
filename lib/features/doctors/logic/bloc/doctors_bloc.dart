import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/core/database/models/doctor_filter_model.dart';
import 'package:gestanea/features/doctors/doctor_api_service.dart';
import 'package:gestanea/core/services/location_service.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import 'doctors_event.dart';
import 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final LocationService _locationService;
  final ConnectivityService _connectivityService;

  DoctorsBloc({
    LocationService? locationService,
    ConnectivityService? connectivityService,
  }) : _locationService = locationService ?? LocationService(),
       _connectivityService = connectivityService ?? ConnectivityService(),
       super(DoctorsInitial()) {
    on<LoadDoctors>(_onLoadDoctors);
    on<SearchDoctors>(_onSearchDoctors);
    on<FilterDoctors>(_onFilterDoctors);
    on<SortDoctors>(_onSortDoctors);
    on<ClearFilters>(_onClearFilters);
    on<SelectLocation>(_onSelectLocation);
    on<RefreshLocation>(_onRefreshLocation);
  }

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
      // Check connectivity first
      final isOnline = await _connectivityService.checkConnectivity();
      if (!isOnline) {
        emit(DoctorsOffline());
        return;
      }

      _userLat = event.userLat;
      _userLon = event.userLon;

      await _fetchAndEmit(emit);
    } catch (e) {
      // Check if it's a network error
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socketexception') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection')) {
        emit(DoctorsOffline());
      } else {
        emit(DoctorsError('Failed to load doctors: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshLocation(
    RefreshLocation event,
    Emitter<DoctorsState> emit,
  ) async {
    try {
      emit(DoctorsLoading());

      // Check connectivity first
      final isOnline = await _connectivityService.checkConnectivity();
      if (!isOnline) {
        emit(DoctorsOffline());
        return;
      }

      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _userLat = position.latitude;
        _userLon = position.longitude;
        _selectedLocation = 'Use current location';
      }

      await _fetchAndEmit(emit);
    } catch (e) {
      // Check if it's a network error
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socketexception') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection')) {
        emit(DoctorsOffline());
      } else {
        emit(DoctorsError('Failed to refresh location: ${e.toString()}'));
      }
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

    // If selecting "Use current location", get fresh coordinates
    if (event.location == 'Use current location') {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _userLat = position.latitude;
        _userLon = position.longitude;
      }
    }

    await _fetchAndEmit(emit);
  }

  Future<void> _fetchAndEmit(Emitter<DoctorsState> emit) async {
    try {
      // Get specialty for API call (API accepts single specialty)
      String? specialty;
      if (_currentFilter.specialties != null &&
          _currentFilter.specialties!.isNotEmpty) {
        specialty = _currentFilter.specialties!.first;
      }

      // Determine wilaya parameter
      String? wilayaParam;
      if (_selectedLocation != 'Use current location') {
        wilayaParam = _selectedLocation;
      }

      // Fetch doctors from API
      final doctors = await DoctorApiService.getDoctors(
        search: _currentQuery.isEmpty ? null : _currentQuery,
        wilaya: wilayaParam,
        specialty: specialty,
        gender: _currentFilter.gender,
        minRating: _currentFilter.minRating,
        minReviews: _currentFilter.minReviews,
        maxDistance: _currentFilter.maxDistance,
        userLat: _userLat,
        userLon: _userLon,
        sortBy: _currentSort,
      );

      _allDoctors = doctors;

      // Apply client-side filtering
      List<DoctorModel> filtered = _applyClientSideFilters(doctors);

      // Calculate distances if user location is available
      if (_userLat != null && _userLon != null) {
        filtered = filtered.map((doctor) {
          if (doctor.latitude != null && doctor.longitude != null) {
            final distance = _locationService.calculateDistance(
              _userLat!,
              _userLon!,
              doctor.latitude!,
              doctor.longitude!,
            );
            return doctor.copyWith(distance: distance);
          }
          return doctor;
        }).toList();
      }

      // Apply sorting
      filtered = _sortDoctors(filtered);

      emit(
        DoctorsLoaded(
          doctors: filtered,
          allDoctors: _allDoctors,
          hasActiveFilters:
              _currentFilter.hasActiveFilters || _currentQuery.isNotEmpty,
          currentFilter: _currentFilter,
          searchQuery: _currentQuery,
          selectedLocation: _selectedLocation,
          userLatitude: _userLat,
          userLongitude: _userLon,
        ),
      );
    } catch (e) {
      // Check if it's a network error
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socketexception') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('unreachable')) {
        emit(DoctorsOffline());
      } else {
        emit(DoctorsError('Failed to load doctors: ${e.toString()}'));
      }
    }
  }

  List<DoctorModel> _applyClientSideFilters(List<DoctorModel> doctors) {
    var filtered = doctors;

    // Filter by multiple specialties if selected
    if (_currentFilter.specialties != null &&
        _currentFilter.specialties!.length > 1) {
      filtered = filtered
          .where(
            (doctor) =>
                doctor.specialty != null &&
                _currentFilter.specialties!.contains(doctor.specialty),
          )
          .toList();
    }

    // Filter by max distance if user location is available
    if (_currentFilter.maxDistance != null &&
        _userLat != null &&
        _userLon != null) {
      filtered = filtered.where((doctor) {
        if (doctor.latitude == null || doctor.longitude == null) return false;
        final distance = _locationService.calculateDistance(
          _userLat!,
          _userLon!,
          doctor.latitude!,
          doctor.longitude!,
        );
        return distance <= _currentFilter.maxDistance!;
      }).toList();
    }

    // Filter by rating
    if (_currentFilter.minRating != null) {
      filtered = filtered
          .where(
            (doctor) =>
                doctor.rating != null &&
                doctor.rating! >= _currentFilter.minRating!,
          )
          .toList();
    }

    // Filter by reviews count
    if (_currentFilter.minReviews != null) {
      filtered = filtered
          .where((doctor) => doctor.reviewsCount >= _currentFilter.minReviews!)
          .toList();
    }

    // Filter by gender
    if (_currentFilter.gender != null) {
      filtered = filtered
          .where((doctor) => doctor.gender == _currentFilter.gender)
          .toList();
    }

    return filtered;
  }

  List<DoctorModel> _sortDoctors(List<DoctorModel> doctors) {
    switch (_currentSort) {
      case 'rating':
        doctors.sort((a, b) {
          if (a.rating == null) return 1;
          if (b.rating == null) return -1;
          return b.rating!.compareTo(a.rating!);
        });
        break;
      case 'reviews':
        doctors.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case 'distance':
      default:
        doctors.sort((a, b) {
          if (a.distance == null) return 1;
          if (b.distance == null) return -1;
          return a.distance!.compareTo(b.distance!);
        });
        break;
    }
    return doctors;
  }
}
