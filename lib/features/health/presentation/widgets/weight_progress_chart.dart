import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'vitals_tab_content.dart';

class WeightProgressChart extends StatelessWidget {
  final List measurements;
  final TimeRange timeRange;
  
  const WeightProgressChart({
    super.key,
    required this.measurements,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;

    // Filter measurements based on time range
    final filteredMeasurements = _filterByTimeRange(measurements);
    final weightData = filteredMeasurements
        .where((m) => m.weight != null)
        .toList()
        .reversed
        .toList(); // Reverse so oldest is first (left to right)

    if (weightData.isEmpty) {
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
            ),
            BoxShadow(
              color: AppColors.white,
              blurRadius: 6,
              offset: Offset(-3, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              l10n.weightProgress,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.noWeightDataAvailable),
          ],
        ),
      );
    }

    // Calculate status based on weight trend
    String status = l10n.onTrack;
    Color statusColor = const Color(0xFFB8E6B8);
    Color statusTextColor = const Color(0xFF2D5F2D);
    
    if (weightData.length >= 2) {
      final latestWeight = weightData.first.weight!;
      final previousWeight = weightData[1].weight!;
      final diff = latestWeight - previousWeight;
      
      // Pregnancy typically involves weight gain, so adjust logic if needed
      if (diff.abs() > 2) {  // More than 2kg change
        status = l10n.monitor;
        statusColor = const Color(0xFFFFE4B8);
        statusTextColor = const Color(0xFF8B5A00);
      }
    }

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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: statusTextColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                        final index = value.toInt();
                        if (index >= 0 && index < weightData.length) {
                          return Text(
                            '${weightData[index].recordedAt.day}/${weightData[index].recordedAt.month}',
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 9,
                              color: AppColors.textDark,
                            ),
                          );
                        }
                        return const Text('');
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
                    spots: List.generate(
                      weightData.length,
                      (index) => FlSpot(index.toDouble(), weightData[index].weight!),
                    ),
                    isCurved: true,
                    color: themeData.primaryColor,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: themeData.primaryColor,
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

  List _filterByTimeRange(List measurements) {
    final now = DateTime.now();
    switch (timeRange) {
      case TimeRange.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        return measurements.where((m) => m.recordedAt.isAfter(weekAgo)).toList();
      case TimeRange.month:
        final monthAgo = now.subtract(const Duration(days: 30));
        return measurements.where((m) => m.recordedAt.isAfter(monthAgo)).toList();
      case TimeRange.threeMonths:
        final threeMonthsAgo = now.subtract(const Duration(days: 90));
        return measurements.where((m) => m.recordedAt.isAfter(threeMonthsAgo)).toList();
      case TimeRange.all:
        return measurements;
    }
  }
}
