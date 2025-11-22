import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class LocationSelector extends StatelessWidget {
  final String selectedLocation;
  final VoidCallback onTap;

  const LocationSelector({
    Key? key,
    required this.selectedLocation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.bg_1,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                offset: const Offset(-4, -4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.main400.withOpacity(0.3),
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.main500, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedLocation == 'Use current location'
                      ? 'Use current location'
                      : selectedLocation,
                  style: AppTextStyles.body1.copyWith(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.main500,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
