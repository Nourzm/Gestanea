import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class DoctorsFilterBar extends StatelessWidget {
  final int doctorCount;
  final VoidCallback? onFilterTap;

  const DoctorsFilterBar({
    Key? key,
    required this.doctorCount,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$doctorCount Doctors Found',
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
                color: AppColors.background,
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
                  const Icon(Icons.tune, color: AppColors.main500, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: AppTextStyles.body1.copyWith(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: AppColors.main500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
