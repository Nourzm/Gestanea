import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'vitals_card.dart';
import 'bmi_card.dart';
import 'weight_progress_chart.dart';
import 'add_measurement_card.dart';
import 'health_tip_card.dart';
import 'dialogs/add_measurment_dialog.dart';

class VitalsTabContent extends StatelessWidget {
  const VitalsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.main300,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: SingleChildScrollView(
            
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Row: Weight & Heart Rate
                Row(
                  children: [
                    Expanded(
                      child: VitalsCard(
                        icon: Icons.monitor_weight_outlined,
                        title: localizations.weight,
                        value: '69 Kg',
                        status: localizations.normal,
                        statusColor: const Color(0xFFB8E6B8),
                        textColor: const Color(0xFF2D5F2D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: VitalsCard(
                        icon: Icons.favorite,
                        title: localizations.heartRate,
                        value: '72 bpm',
                        status: localizations.normal,
                        statusColor: const Color(0xFFB8E6B8),
                        textColor: const Color(0xFF2D5F2D),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Second Row: Blood Pressure & Add Measurement
                Row(
                  children: [
                    Expanded(
                      child: VitalsCard(
                        icon: Icons.favorite,
                        title: localizations.bloodPressure,
                        value: '120/80',
                        status: localizations.normal,
                        statusColor: const Color(0xFFB8E6B8),
                        textColor: const Color(0xFF2D5F2D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
  child: AddMeasurementCard(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddMeasurementDialog(),
      );
    },
  ),
),
                  ],
                ),

                const SizedBox(height: 16),

                // BMI Card
                const BMICard(),

                const SizedBox(height: 16),

                // Weight Progress Chart
                WeightProgressChart(),

                const SizedBox(height: 16),

                // Health Tip
                HealthTipCard(
                  message: localizations.healthTipMessage,
                ),
              ],
            ),
          ),
        ),
        
        // TOP inset shadow overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // LEFT inset shadow overlay
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}