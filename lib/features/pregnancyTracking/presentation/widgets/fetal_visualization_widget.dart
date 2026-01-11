// lib/features/pregnancy/presentation/widgets/fetal_visualization_widget.dart
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class FetalVisualizationWidget extends StatelessWidget {
  final int week;

  const FetalVisualizationWidget({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.main600.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.main300.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.main300,
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.main600.withOpacity(0.15),
                      offset: const Offset(0, 8),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/baby_not_born.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.main600,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.main600.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Week $week',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Your Baby is Growing',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.main700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.main300.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Size of a Peach', // This shouldIdeally come from data
              style: TextStyle(
                fontSize: 14,
                color: AppColors.main600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}