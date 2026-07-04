import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/measurement_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeightProgressChart extends StatelessWidget {
  /// Measurements newest-first (as returned by [MeasurementsBloc]).
  final List<MeasurementModel> measurements;

  const WeightProgressChart({super.key, this.measurements = const []});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    // Oldest-first weight points only (a measurement may omit weight).
    final weighed = measurements
        .where((m) => m.weight != null)
        .toList()
        .reversed
        .toList();
    final hasEnough = weighed.length >= 2;

    final spots = <FlSpot>[
      for (var i = 0; i < weighed.length; i++)
        FlSpot(i.toDouble(), weighed[i].weight!),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.weightProgress,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasEnough)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8E6B8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l10n.onTrack,
                    style: AppTextStyles.smallLabel.copyWith(
                      color: const Color(0xFF2D5F2D),
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasEnough)
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  l10n.noMeasurementsYet,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 9,
                              color: AppColors.textDark,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= weighed.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            DateFormat(
                              'd/M',
                              localeCode,
                            ).format(weighed[i].recordedAt),
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 9,
                              color: AppColors.textDark,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.main500,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: AppColors.main500,
                            strokeWidth: 1.5,
                            strokeColor: Colors.white,
                          );
                        },
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
