import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/features/doctors/presentation/widgets/search_field.dart';
import 'package:gestanea/features/doctors/presentation/widgets/location_selector.dart';
import 'package:gestanea/features/doctors/presentation/widgets/filter_bar.dart';
import 'package:gestanea/features/doctors/presentation/widgets/filter_bottom_sheet.dart';
import 'package:gestanea/features/doctors/presentation/widgets/doctor_card.dart';
import 'package:gestanea/features/doctors/data/models/doctors_model.dart';
import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';

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

  final List<Doctor> _allDoctors = [
    Doctor(
      name: 'Dr. Sarah Johnson',
      specialty: 'Cardiologist',
      distance: '0.8 km away',
      rating: 4.8,
      reviews: 156,
      gender: 'Female',
    ),
    Doctor(
      name: 'Dr. Michael Chen',
      specialty: 'General Practitioner',
      distance: '1.2 km away',
      rating: 4.6,
      reviews: 203,
      gender: 'Male',
    ),
    Doctor(
      name: 'Dr. Emily Rodriguez',
      specialty: 'Pediatrician',
      distance: '1.5 km away',
      rating: 4.9,
      reviews: 312,
      gender: 'Female',
    ),
    Doctor(
      name: 'Dr. James Williams',
      specialty: 'Dermatologist',
      distance: '2.1 km away',
      rating: 4.7,
      reviews: 189,
      gender: 'Male',
    ),
    Doctor(
      name: 'Dr. Aisha Ahmed',
      specialty: 'Gynecologist',
      distance: '0.5 km away',
      rating: 4.9,
      reviews: 445,
      gender: 'Female',
    ),
    Doctor(
      name: 'Dr. Robert Thompson',
      specialty: 'Orthopedic Surgeon',
      distance: '3.2 km away',
      rating: 4.5,
      reviews: 98,
      gender: 'Male',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Doctor> get _filteredDoctors {
    List<Doctor> filtered = List.from(_allDoctors);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((doctor) {
        final matchesName = doctor.name.toLowerCase().contains(query);
        final matchesSpecialty = doctor.specialty.toLowerCase().contains(query);
        return matchesName || matchesSpecialty;
      }).toList();
    }

    // Apply distance filter
    if (_currentFilter.maxDistance != null) {
      filtered = filtered.where((doctor) {
        return doctor.distanceInKm <= _currentFilter.maxDistance!;
      }).toList();
    }

    // Apply rating filter
    if (_currentFilter.minRating != null) {
      filtered = filtered.where((doctor) {
        return doctor.rating >= _currentFilter.minRating!;
      }).toList();
    }

    // Apply gender filter
    if (_currentFilter.gender != null) {
      filtered = filtered.where((doctor) {
        return doctor.gender == _currentFilter.gender;
      }).toList();
    }

    // Apply reviews filter
    if (_currentFilter.minReviews != null) {
      filtered = filtered.where((doctor) {
        return doctor.reviews >= _currentFilter.minReviews!;
      }).toList();
    }

    return filtered;
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg_1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
      },
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
