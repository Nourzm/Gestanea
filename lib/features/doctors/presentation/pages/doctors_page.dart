import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/features/doctors/presentation/widgets/search_field.dart';
import 'package:gestanea/features/doctors/presentation/widgets/location_selector.dart';
import 'package:gestanea/features/doctors/presentation/widgets/filter_bar.dart';
import 'package:gestanea/features/doctors/presentation/widgets/filter_bottom_sheet.dart';
import 'package:gestanea/features/doctors/presentation/widgets/doctor_card.dart';
import 'package:gestanea/features/doctors/data/models/doctor_model.dart';
import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';
import 'package:gestanea/features/doctors/domain/usecases/get_doctors_usecase.dart';
import 'package:gestanea/features/doctors/domain/usecases/search_doctors_usecase.dart';
import 'package:gestanea/features/doctors/domain/usecases/filter_doctors_usecase.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'Algiers';
  DoctorFilter _currentFilter = DoctorFilter();
  String _searchQuery = '';

  // Use cases
  final _getDoctorsUseCase = GetDoctorsUseCase();
  final _searchDoctorsUseCase = SearchDoctorsUseCase();
  final _filterDoctorsUseCase = FilterDoctorsUseCase();

  // Doctors data
  late final List<Doctor> _allDoctors;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadDoctors() {
    // Get doctors from use case and convert entities to models
    final doctorEntities = _getDoctorsUseCase.execute();

    _allDoctors = doctorEntities.map((entity) {
      return Doctor(
        name: entity.name,
        specialty: entity.specialty,
        distance: '${entity.distanceKm.toStringAsFixed(1)} km away',
        rating: entity.rating,
        reviews: entity.totalReviews,
        gender: entity.gender,
        address: entity.address,
        phoneNumber: entity.phoneNumber,
        latitude: entity.latitude,
        longitude: entity.longitude,
        distanceKm: entity.distanceKm,
        openingHours: entity.openingHours,
      );
    }).toList();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Doctor> get _filteredDoctors {
    // Convert Doctor models to entities for filtering
    final doctorEntities = _allDoctors.map((doctor) {
      return _getDoctorsUseCase.execute().firstWhere(
        (entity) => entity.name == doctor.name,
      );
    }).toList();

    // Apply search
    var filtered = _searchDoctorsUseCase.execute(doctorEntities, _searchQuery);

    // Apply filters
    filtered = _filterDoctorsUseCase.execute(filtered, _currentFilter);

    // Convert back to models
    return filtered.map((entity) {
      return Doctor(
        name: entity.name,
        specialty: entity.specialty,
        distance: '${entity.distanceKm.toStringAsFixed(1)} km away',
        rating: entity.rating,
        reviews: entity.totalReviews,
        gender: entity.gender,
        address: entity.address,
        phoneNumber: entity.phoneNumber,
        latitude: entity.latitude,
        longitude: entity.longitude,
        distanceKm: entity.distanceKm,
        openingHours: entity.openingHours,
      );
    }).toList();
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg_1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildLocationBottomSheet(),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(
          currentFilter: _currentFilter,
          onApplyFilter: (filter) {
            setState(() {
              _currentFilter = filter;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayDoctors = _filteredDoctors;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            Header(title: 'Doctors', showBackButton: true),
            const SizedBox(height: 20),
            SearchField(
              controller: _searchController,
              hintText: 'Search doctors by name or specialty...',
              icon: Icons.search,
            ),
            const SizedBox(height: 16),
            LocationSelector(
              selectedLocation: _selectedLocation,
              onTap: _showLocationPicker,
            ),
            const SizedBox(height: 20),
            DoctorsFilterBar(
              doctorCount: displayDoctors.length,
              onFilterTap: _showFilterBottomSheet,
              hasActiveFilters: _currentFilter.hasActiveFilters,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: displayDoctors.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: displayDoctors.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: displayDoctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBottomSheet() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ...[
            'Use current location',
            'Algiers',
            'Oran',
            'Constantine',
            'Annaba',
            'Blida',
          ].map((location) {
            return ListTile(
              leading: Icon(
                location == 'Use current location'
                    ? Icons.my_location
                    : Icons.location_on_outlined,
                color: AppColors.main500,
              ),
              title: Text(location),
              onTap: () {
                setState(() {
                  _selectedLocation = location;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty
                  ? Icons.search_off
                  : Icons.medical_services_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'No doctors found' : 'No results',
              style: AppTextStyles.headline2.copyWith(
                fontFamily: 'Lato',
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No doctors match "$_searchQuery"'
                  : 'Try adjusting your filters',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
