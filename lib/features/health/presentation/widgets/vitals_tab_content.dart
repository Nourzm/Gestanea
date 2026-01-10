import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../pages/measurements_list_page.dart';
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
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
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
                        iconPath: 'assets/icons/health.svg',
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
                        iconPath: 'assets/icons/heartplus.svg',
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
                        iconPath: 'assets/icons/Stethoscope.svg',
                        title: localizations.bloodPressure,
                        value: '120/80',
                        status: localizations.normal,
                        statusColor: const Color(0xFFB8E6B8),
                        textColor: const Color(0xFF2D5F2D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Builder(
                        builder: (ctx) {
                          return AddMeasurementCard(
                            onTap: () {
                              final bloc = ctx.read<MeasurementsBloc>();
                              showModalBottomSheet(
                                context: ctx,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (dialogContext) =>
                                    AddMeasurementDialog(bloc: bloc),
                              );
                            },
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
                const WeightProgressChart(),

                const SizedBox(height: 16),

                // Health Tip
                HealthTipCard(message: localizations.healthTipMessage),

                const SizedBox(height: 16),

                // View All Measurements Button
                Builder(
                  builder: (btnContext) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            btnContext,
                            MaterialPageRoute(
                              builder: (navContext) => BlocProvider.value(
                                value: btnContext.read<MeasurementsBloc>(),
                                child: const MeasurementsListPage(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('View All Measurements'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeData.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
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
