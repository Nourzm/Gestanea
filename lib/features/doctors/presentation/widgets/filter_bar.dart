import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class DoctorsFilterBar extends StatelessWidget {
  final int doctorCount;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const DoctorsFilterBar({
    Key? key,
    required this.doctorCount,
    this.onFilterTap,
    this.hasActiveFilters = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayText = doctorCount == 1
        ? l10n.doctorsFoundSingle
        : l10n.doctorsFoundPlural(doctorCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayText,
            style: AppTextStyles.headline2.copyWith(
              fontFamily: 'Lato',
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: hasActiveFilters
                    ? AppColors.main500
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    offset: const Offset(-3, -3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.main400.withOpacity(0.3),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: hasActiveFilters
                        ? AppColors.white
                        : AppColors.main500,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.filter,
                    style: AppTextStyles.body1.copyWith(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: hasActiveFilters
                          ? AppColors.white
                          : AppColors.main500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
