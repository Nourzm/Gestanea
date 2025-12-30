import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/core/widgets/search_bar.dart';
import 'package:gestanea/features/doctors/presentation/widgets/location_selector.dart';
import 'package:gestanea/features/doctors/presentation/widgets/filter_bar.dart';
import 'package:gestanea/features/doctors/presentation/widgets/filter_bottom_sheet.dart';
import 'package:gestanea/features/doctors/presentation/widgets/doctor_card.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctor_details.dart';
import 'package:gestanea/core/database/models/doctor_filter_model.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_bloc.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_event.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_state.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctor_detail_bloc.dart';
import 'package:gestanea/core/services/location_service.dart';
import 'package:gestanea/core/services/openstreet_service.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

// Wrapper widget that provides the BlocProvider
class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorsBloc(),
      child: const DoctorsScreenContent(),
    );
  }
}

// Main content widget
class DoctorsScreenContent extends StatefulWidget {
  const DoctorsScreenContent({Key? key}) : super(key: key);

  @override
  State<DoctorsScreenContent> createState() => _DoctorsScreenContentState();
}

class _DoctorsScreenContentState extends State<DoctorsScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService(
    client: http.Client(),
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeLocation() async {
    final hasPermission = await _locationService.checkAndRequestPermissions();

    if (hasPermission) {
      final position = await _locationService.getCurrentLocation();
      if (position != null && mounted) {
        context.read<DoctorsBloc>().add(
          LoadDoctors(userLat: position.latitude, userLon: position.longitude),
        );
      } else {
        context.read<DoctorsBloc>().add(LoadDoctors());
      }
    } else {
      context.read<DoctorsBloc>().add(LoadDoctors());
      if (mounted) {
        _showLocationPermissionDialog();
      }
    }
  }

  void _showLocationPermissionDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.locationPermissionRequired ?? 'Location Permission Required',
        ),
        content: Text(
          l10n.locationPermissionMessage ??
              'We need access to your location to show nearby doctors.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _locationService.openAppSettings();
            },
            child: Text(l10n.settings ?? 'Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshLocation() async {
    final l10n = AppLocalizations.of(context)!;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(l10n.gettingLocation ?? 'Getting your location...'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    final hasPermission = await _locationService.checkAndRequestPermissions();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.locationPermissionDenied ?? 'Location permission denied',
            ),
            action: SnackBarAction(
              label: l10n.settings ?? 'Settings',
              onPressed: () => _locationService.openAppSettings(),
            ),
          ),
        );
      }
      return;
    }

    if (mounted) {
      context.read<DoctorsBloc>().add(RefreshLocation());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.locationUpdated ?? 'Location updated'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onSearchChanged() {
    context.read<DoctorsBloc>().add(SearchDoctors(_searchController.text));
  }

  void _navigateToDoctorDetail(dynamic doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DoctorDetailBloc(),
          child: DoctorDetailScreen(doctor: doctor),
        ),
      ),
    );
  }

  Future<void> _showLocationPicker(String currentLocation) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg_1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => LocationPickerBottomSheet(
        currentLocation: currentLocation,
        locationService: _locationService,
        openStreetMapService: _openStreetMapService,
        onLocationSelected: (location) {
          context.read<DoctorsBloc>().add(SelectLocation(location));
        },
      ),
    );
  }

  void _showFilterBottomSheet(DoctorFilter currentFilter) {
    final doctorsBloc = context.read<DoctorsBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(
          currentFilter: currentFilter,
          onApplyFilter: (filter) {
            doctorsBloc.add(FilterDoctors(filter));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            Header(title: l10n.doctors ?? 'Doctors', showBackButton: true),
            Expanded(
              child: BlocConsumer<DoctorsBloc, DoctorsState>(
                listener: (context, state) {
                  if (state is DoctorsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: l10n.retry ?? 'Retry',
                          textColor: Colors.white,
                          onPressed: () {
                            context.read<DoctorsBloc>().add(LoadDoctors());
                          },
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading doctors...'),
                        ],
                      ),
                    );
                  }

                  if (state is DoctorsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body1,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<DoctorsBloc>().add(LoadDoctors());
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry ?? 'Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DoctorsLoaded) {
                    final displayDoctors = state.doctors;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: searchBar(
                              controller: _searchController,
                              hintText: l10n.findDoctors ?? 'Find doctors',
                            ),
                          ),
                          const SizedBox(height: 16),

                          LocationSelector(
                            selectedLocation: state.selectedLocation,
                            onTap: () =>
                                _showLocationPicker(state.selectedLocation),
                          ),
                          const SizedBox(height: 20),
                          DoctorsFilterBar(
                            doctorCount: displayDoctors.length,
                            onFilterTap: () =>
                                _showFilterBottomSheet(state.currentFilter),
                            hasActiveFilters: state.hasActiveFilters,
                          ),
                          const SizedBox(height: 16),
                          displayDoctors.isEmpty
                              ? _buildEmptyState(state.searchQuery)
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  itemCount: displayDoctors.length,
                                  itemBuilder: (context, index) {
                                    final doctor = displayDoctors[index];
                                    return DoctorCard(
                                      doctor: doctor,
                                      onTap: () =>
                                          _navigateToDoctorDetail(doctor),
                                    );
                                  },
                                ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty
                  ? Icons.search_off
                  : Icons.medical_services_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty
                  ? l10n.noDoctorsFound ?? 'No doctors found'
                  : l10n.noResults ?? 'No results',
              style: AppTextStyles.headline2.copyWith(
                fontFamily: 'Lato',
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? l10n.noMatchingDoctors(searchQuery)
                  : l10n.tryAdjustingFilters ?? 'Try adjusting filters',
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

// Location Picker Bottom Sheet Widget
class LocationPickerBottomSheet extends StatefulWidget {
  final String currentLocation;
  final LocationService locationService;
  final OpenStreetMapService openStreetMapService;
  final Function(String) onLocationSelected;

  const LocationPickerBottomSheet({
    Key? key,
    required this.currentLocation,
    required this.locationService,
    required this.openStreetMapService,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationResult> _searchResults = [];
  bool _isSearching = false;
  bool _showSearch = false;

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await widget.openStreetMapService.searchLocation(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final defaultLocations = [
      l10n.useCurrentLocation ?? 'Use current location',
      l10n.algiers ?? 'Algiers',
      l10n.oran ?? 'Oran',
      l10n.constantine ?? 'Constantine',
      l10n.annaba ?? 'Annaba',
      l10n.blida ?? 'Blida',
      l10n.bouira ?? 'Bouira',
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title and search toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.selectLocation ?? 'Select Location',
                style: AppTextStyles.headline2,
              ),
              IconButton(
                icon: Icon(
                  _showSearch ? Icons.close : Icons.search,
                  color: AppColors.main500,
                ),
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchController.clear();
                      _searchResults = [];
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search bar (if enabled)
          if (_showSearch) ...[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchWilaya ?? 'Search for a wilaya...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _searchLocation(value);
                  }
                });
              },
            ),
            const SizedBox(height: 16),
          ],

          // Results
          Expanded(
            child: _showSearch && _searchResults.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: AppColors.main500,
                        ),
                        title: Text(result.displayName),
                        subtitle: Text(result.wilaya ?? ''),
                        onTap: () {
                          widget.onLocationSelected(
                            result.wilaya ?? result.displayName,
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: defaultLocations.length,
                    itemBuilder: (context, index) {
                      final location = defaultLocations[index];
                      final isCurrentLocation = index == 0;
                      final isSelected = location == widget.currentLocation;

                      return ListTile(
                        leading: Icon(
                          isCurrentLocation
                              ? Icons.my_location
                              : Icons.location_on_outlined,
                          color: isSelected
                              ? AppColors.main500
                              : AppColors.textSecondary,
                        ),
                        title: Text(
                          location,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.main500
                                : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColors.main500)
                            : null,
                        onTap: () {
                          widget.onLocationSelected(location);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
