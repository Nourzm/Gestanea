import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/doctors/data/models/doctor_filter_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class FilterBottomSheet extends StatefulWidget {
  final DoctorFilter currentFilter;
  final Function(DoctorFilter) onApplyFilter;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _maxDistance;
  late double _minRating;
  String? _selectedGender;
  late double _minReviews;

  @override
  void initState() {
    super.initState();
    _maxDistance = widget.currentFilter.maxDistance ?? 10.0;
    _minRating = widget.currentFilter.minRating ?? 0.0;
    _selectedGender = widget.currentFilter.gender;
    _minReviews = (widget.currentFilter.minReviews ?? 0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDistanceFilter(),
                  const SizedBox(height: 24),
                  _buildRatingFilter(),
                  const SizedBox(height: 24),
                  _buildGenderFilter(),
                  const SizedBox(height: 24),
                  _buildReviewsFilter(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.filterDoctors,
            style: AppTextStyles.headline2.copyWith(
              fontFamily: 'Lato',
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: _clearFilters,
            child: Text(
              l10n.clearAll,
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 14,
                color: AppColors.main500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceFilter() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.maximumDistance,
          style: AppTextStyles.headline2.copyWith(
            fontFamily: 'Lato',
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.upToKm(_maxDistance.toStringAsFixed(1)),
          style: AppTextStyles.body1.copyWith(
            fontFamily: 'Lato',
            fontSize: 14,
            color: AppColors.main500,
            fontWeight: FontWeight.w500,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.main500,
            inactiveTrackColor: AppColors.main400.withValues(alpha: 0.3),
            thumbColor: AppColors.main600,
            overlayColor: AppColors.main500.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: _maxDistance,
            min: 0.5,
            max: 20.0,
            divisions: 39,
            onChanged: (value) {
              setState(() {
                _maxDistance = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.minimumRating,
          style: AppTextStyles.headline2.copyWith(
            fontFamily: 'Lato',
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFFFB800), size: 16),
            const SizedBox(width: 4),
            Text(
              l10n.ratingAndAbove(_minRating.toStringAsFixed(1)),
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 14,
                color: AppColors.main500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.main500,
            inactiveTrackColor: AppColors.main400.withValues(alpha: 0.3),
            thumbColor: AppColors.main600,
            overlayColor: AppColors.main500.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: _minRating,
            min: 0.0,
            max: 5.0,
            divisions: 50,
            onChanged: (value) {
              setState(() {
                _minRating = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenderFilter() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gender,
          style: AppTextStyles.headline2.copyWith(
            fontFamily: 'Lato',
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            _buildGenderChip(l10n.all, null),
            _buildGenderChip(l10n.male, 'Male'),
            _buildGenderChip(l10n.female, 'Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderChip(String label, String? value) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main500 : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.7),
              offset: const Offset(-2, -2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.main400.withValues(alpha: 0.3),
              offset: const Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontFamily: 'Lato',
            fontSize: 14,
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsFilter() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.minimumReviews,
          style: AppTextStyles.headline2.copyWith(
            fontFamily: 'Lato',
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.atLeastReviews(_minReviews.toInt()),
          style: AppTextStyles.body1.copyWith(
            fontFamily: 'Lato',
            fontSize: 14,
            color: AppColors.main500,
            fontWeight: FontWeight.w500,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.main500,
            inactiveTrackColor: AppColors.main400.withValues(alpha: 0.3),
            thumbColor: AppColors.main600,
            overlayColor: AppColors.main500.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: _minReviews,
            min: 0,
            max: 500,
            divisions: 50,
            onChanged: (value) {
              setState(() {
                _minReviews = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.main500,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.applyFilters,
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _maxDistance = 10.0;
      _minRating = 0.0;
      _selectedGender = null;
      _minReviews = 0.0;
    });
  }

  void _applyFilters() {
    final filter = DoctorFilter(
      maxDistance: _maxDistance,
      minRating: _minRating,
      gender: _selectedGender,
      minReviews: _minReviews.toInt(),
    );
    widget.onApplyFilter(filter);
    Navigator.pop(context);
  }
}
