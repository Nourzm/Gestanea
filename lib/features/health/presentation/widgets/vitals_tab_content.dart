import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/measurement_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_state.dart';
import '../pages/measurements_list_page.dart';
import 'vitals_card.dart';
import 'bmi_card.dart';
import 'weight_progress_chart.dart';
import 'add_measurement_card.dart';
import 'health_tip_card.dart';
import 'dialogs/add_measurment_dialog.dart';

/// A resolved status chip: localized label + its background/text colors.
class _Status {
  final String label;
  final Color bg;
  final Color fg;
  const _Status(this.label, this.bg, this.fg);
}

class VitalsTabContent extends StatelessWidget {
  const VitalsTabContent({super.key});

  /// Maps the model's English status keyword to a localized, colored chip.
  _Status _statusFor(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Normal':
        return _Status(
          l10n.normal,
          const Color(0xFFB8E6B8),
          const Color(0xFF2D5F2D),
        );
      case 'Low':
        return _Status(
          l10n.low,
          const Color(0xFFBBDEFB),
          const Color(0xFF0D47A1),
        );
      case 'Elevated':
        return _Status(
          l10n.elevated,
          const Color(0xFFFFE0B2),
          const Color(0xFF8A5A00),
        );
      case 'High':
        return _Status(
          l10n.high,
          const Color(0xFFFFCDD2),
          const Color(0xFFB71C1C),
        );
      default:
        return const _Status('—', Color(0xFFE0E0E0), Color(0xFF616161));
    }
  }

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
          child: BlocBuilder<MeasurementsBloc, MeasurementsState>(
            builder: (context, state) {
              final List<MeasurementModel> measurements =
                  state is MeasurementsLoaded ? state.measurements : const [];
              final MeasurementModel? latest = state is MeasurementsLoaded
                  ? state.latest
                  : null;

              final neutral = _statusFor('', localizations);
              final hrStatus = latest?.heartRate != null
                  ? _statusFor(latest!.heartRateStatus, localizations)
                  : neutral;
              final bpStatus = latest?.systolic != null
                  ? _statusFor(latest!.bloodPressureStatus, localizations)
                  : neutral;

              final weightValue = latest?.weight != null
                  ? '${_trim(latest!.weight!)} ${localizations.kg}'
                  : '--';
              final weightStatus = latest?.weight != null
                  ? DateFormat(
                      'd/M',
                      Localizations.localeOf(context).languageCode,
                    ).format(latest!.recordedAt)
                  : '—';

              return SingleChildScrollView(
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
                            value: weightValue,
                            status: weightStatus,
                            statusColor: const Color(0xFFE0E0E0),
                            textColor: const Color(0xFF616161),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: VitalsCard(
                            icon: Icons.favorite,
                            title: localizations.heartRate,
                            value: latest?.heartRate != null
                                ? '${latest!.heartRate} ${localizations.bpm}'
                                : '--',
                            status: hrStatus.label,
                            statusColor: hrStatus.bg,
                            textColor: hrStatus.fg,
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
                            value: latest?.systolic != null
                                ? latest!.bloodPressure
                                : '--',
                            status: bpStatus.label,
                            statusColor: bpStatus.bg,
                            textColor: bpStatus.fg,
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
                    WeightProgressChart(measurements: measurements),

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
                            label: Text(localizations.viewAllMeasurements),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.main500,
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
              );
            },
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

  /// Drops a trailing ".0" so 69.0 reads as "69" but 69.5 stays "69.5".
  String _trim(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
