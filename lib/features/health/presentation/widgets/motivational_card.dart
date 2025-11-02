import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';

class MotivationalCard extends StatelessWidget {
  const MotivationalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.main300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Great job! You\'re maintaining a healthy weight gain pace. Keep up with your balanced diet and gentle exercise routine.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.main600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.main500,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite,
              color: AppColors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}