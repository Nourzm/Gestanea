import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/database/models/measurement_model.dart';

class BMICard extends StatelessWidget {
  final List<MeasurementModel> measurements;
  final double? height; // in cm

  const BMICard({
    super.key,
    required this.measurements,
    this.height = 165, // Default height
  });

  double? _calculateBMI() {
    if (measurements.isEmpty || height == null || height! <= 0) return null;
    
    final latestWeight = measurements.first.weight;
    if (latestWeight == null) return null;
    
    // BMI = weight(kg) / (height(m))^2
    final heightInMeters = height! / 100;
    return latestWeight / (heightInMeters * heightInMeters);
  }

  String _getBMICategory(double bmi, AppLocalizations l10n) {
    if (bmi < 18.5) return l10n.underweight;
    if (bmi < 25) return l10n.normalBMI;
    if (bmi < 30) return l10n.overweight;
    return l10n.obese;
  }

  double _getWeightGain() {
    if (measurements.length < 2) return 0.0;
    
    final currentWeight = measurements.first.weight;
    final initialWeight = measurements.last.weight;
    
    if (currentWeight == null || initialWeight == null) return 0.0;
    
    return currentWeight - initialWeight;
  }

  double _getTargetMinGain(double bmi) {
    if (bmi < 18.5) return 12.5; // Underweight
    if (bmi < 25) return 11.5;   // Normal
    if (bmi < 30) return 7.0;    // Overweight
    return 5.0;                   // Obese
  }

  double _getTargetMaxGain(double bmi) {
    if (bmi < 18.5) return 18.0; // Underweight
    if (bmi < 25) return 16.0;   // Normal
    if (bmi < 30) return 11.5;   // Overweight
    return 9.0;                   // Obese
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;

    final bmi = _calculateBMI();
    final bmiText = bmi != null ? bmi.toStringAsFixed(1) : '--';
    final bmiCategory = bmi != null ? _getBMICategory(bmi, l10n) : '--';
    
    final weightGain = _getWeightGain();
    final targetMin = bmi != null ? _getTargetMinGain(bmi) : 11.5;
    final targetMax = bmi != null ? _getTargetMaxGain(bmi) : 16.0;
    final progressFactor = targetMax > 0 ? (weightGain / targetMax).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeData.primaryColor,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            l10n.prePregnancyBMI,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$bmiText ($bmiCategory)',
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.currentGain}: ${weightGain.toStringAsFixed(1)} kg',
                      style: AppTextStyles.smallLabel.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progressFactor,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.targetRange,
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '${targetMin.toStringAsFixed(1)} - ${targetMax.toStringAsFixed(0)} kg',
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${l10n.expected}: ${((targetMin + targetMax) / 2).toStringAsFixed(1)} kg',
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

