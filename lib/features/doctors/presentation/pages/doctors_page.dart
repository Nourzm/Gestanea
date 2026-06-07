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
import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_bloc.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_event.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_state.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctor_detail_bloc.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DoctorsBloc>().add(LoadDoctors());
    _searchController.addListener(_onSearchChanged);
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

  void _showLocationPicker(String currentLocation) {
    final l10n = AppLocalizations.of(context)!;
    final doctorsBloc = context.read<DoctorsBloc>();
    final locations = [
      l10n.useCurrentLocation,
      l10n.algiers,
      l10n.oran,
      l10n.constantine,
      l10n.annaba,
      l10n.blida,
      l10n.bouira,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg_1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ...locations.asMap().entries.map((entry) {
              final location = entry.value;
              final isCurrentLocation = entry.key == 0;
              return ListTile(
                leading: Icon(
                  isCurrentLocation
                      ? Icons.my_location
                      : Icons.location_on_outlined,
                  color: AppColors.main500,
                ),
                title: Text(location),
                onTap: () {
                  doctorsBloc.add(SelectLocation(location));
                  Navigator.pop(modalContext);
                },
              );
            }),
          ],
        ),
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
            Header(title: l10n.doctors, showBackButton: true),
            Expanded(
              child: BlocBuilder<DoctorsBloc, DoctorsState>(
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorsError) {
                    return Center(child: Text(state.message));
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
                            child: AppSearchBar(
                              controller: _searchController,
                              hintText: l10n.findDoctors,
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
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty ? l10n.noDoctorsFound : l10n.noResults,
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
                  : l10n.tryAdjustingFilters,
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
