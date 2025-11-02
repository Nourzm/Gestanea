import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/features/health/presentation/widgets/health_metric_card.dart';
import 'package:pregnancy_baby_app/features/health/presentation/widgets/bmi_card.dart';
import 'package:pregnancy_baby_app/features/health/presentation/widgets/weight_progress_chart.dart';
import 'package:pregnancy_baby_app/features/health/presentation/widgets/motivational_card.dart';

class VitalsTabContent extends StatelessWidget {
  const VitalsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row - Weight and Heart Rate
          Row(
            children: [
              Expanded(
                child: HealthMetricCard(
                  icon: Icons.monitor_weight_outlined,
                  iconColor: AppColors.main600,
                  title: 'Weight',
                  value: '69 Kg',
                  status: 'Normal',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HealthMetricCard(
                  icon: Icons.favorite,
                  iconColor: AppColors.main600,
                  title: 'Heart Rate',
                  value: '69 Kg',
                  status: 'Normal',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Heart Rate Card with Add Measurement Button
          Row(
            children: [
              Expanded(
                child: HealthMetricCard(
                  icon: Icons.favorite,
                  iconColor: AppColors.main600,
                  title: 'Heart Rate',
                  value: '69 Kg',
                  status: 'Normal',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Add measurement action
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.pink600, AppColors.pink500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Measurment',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // BMI Card
          BMICard(),
          
          const SizedBox(height: 16),
          
          // Weight Progress Chart
          WeightProgressChart(),
          
          const SizedBox(height: 16),
          
          // Motivational Message
          MotivationalCard(),
        ],
      ),
    );
  }
}