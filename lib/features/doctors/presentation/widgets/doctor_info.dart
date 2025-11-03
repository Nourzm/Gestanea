import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/core/constants/app_text_styles.dart';
import 'package:pregnancy_baby_app/features/doctors/data/models/doctors_model.dart';

class DoctorInfo extends StatelessWidget {
  final Doctor doctor;

  const DoctorInfo({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.name,
          style: AppTextStyles.headline2.copyWith(
            fontFamily: 'Lato',
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          doctor.specialty,
          style: AppTextStyles.body1.copyWith(
            fontFamily: 'Lato',
            fontSize: 13,
            color: AppColors.main600,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: AppColors.main500),
            const SizedBox(width: 4),
            Text(
              doctor.distance,
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
            const SizedBox(width: 4),
            Text(
              doctor.rating.toString(),
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${doctor.reviews} reviews)',
              style: AppTextStyles.body1.copyWith(
                fontFamily: 'Lato',
                fontSize: 11,
                color: AppColors.main500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
