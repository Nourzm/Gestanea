import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class DirectionsSection extends StatelessWidget {
  const DirectionsSection({super.key});

  Widget _buildDirectionStep({
    required String stepNumber,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(2, 2),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.white,
                blurRadius: 6,
                offset: Offset(-3, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.smallLabel),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.main300,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How to Get There', style: AppTextStyles.headline2),
          const SizedBox(height: 20),
          _buildDirectionStep(
            stepNumber: '1',
            title: 'Start from your location',
            subtitle: 'Current location',
            color: AppColors.main600,
          ),
          const SizedBox(height: 16),
          _buildDirectionStep(
            stepNumber: '2',
            title: 'Head North on Main St',
            subtitle: 'Continue for 2.5 km',
            color: AppColors.main600,
          ),
          const SizedBox(height: 16),
          _buildDirectionStep(
            stepNumber: '3',
            title: 'Turn right onto Park Ave',
            subtitle: 'Go straight for 1.2 km',
            color: AppColors.main600,
          ),
          const SizedBox(height: 16),
          _buildDirectionStep(
            stepNumber: '✓',
            title: 'You\'ve arrived!',
            subtitle: 'Destination on the right',
            color: const Color(0xFF059669),
          ),
        ],
      ),
    );
  }
}
