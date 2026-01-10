import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_state.dart';
import '../../logic/bloc/measurements_event.dart';
import '../pages/measurements_list_page.dart';
import 'vitals_card.dart';
import 'bmi_card.dart';
import 'weight_progress_chart.dart';
import 'add_measurement_card.dart';
import 'health_tip_card.dart';
import 'dialogs/add_measurment_dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/database/models/measurement_model.dart';

enum TimeRange { week, month, threeMonths, all }

class VitalsTabContent extends StatefulWidget {
  const VitalsTabContent({super.key});

  @override
  State<VitalsTabContent> createState() => _VitalsTabContentState();
}

class _VitalsTabContentState extends State<VitalsTabContent> {
  TimeRange _selectedRange = TimeRange.month;

  String _getRangeLabel(TimeRange range) {
    switch (range) {
      case TimeRange.week:
        return '1W';
      case TimeRange.month:
        return '1M';
      case TimeRange.threeMonths:
        return '3M';
      case TimeRange.all:
        return 'All';
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return const Color(0xFFB8E6B8);
    if (status.toLowerCase().contains('normal')) return const Color(0xFFB8E6B8);
    if (status.toLowerCase().contains('elevated') || status.toLowerCase().contains('high')) {
      return const Color(0xFFFFE4B8);
    }
    if (status.toLowerCase().contains('low')) return const Color(0xFFFFCDD2);
    return const Color(0xFFB8E6B8);
  }

  Color _getStatusTextColor(String? status) {
    if (status == null) return const Color(0xFF2D5F2D);
    if (status.toLowerCase().contains('normal')) return const Color(0xFF2D5F2D);
    if (status.toLowerCase().contains('elevated') || status.toLowerCase().contains('high')) {
      return const Color(0xFF8B5A00);
    }
    if (status.toLowerCase().contains('low')) return const Color(0xFFB71C1C);
    return const Color(0xFF2D5F2D);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
      builder: (context, state) {
        final measurements = state is MeasurementsLoaded ? state.measurements : <MeasurementModel>[];
        final latest = state is MeasurementsLoaded ? state.latest : null;
        
        // Calculate stats
        final latestWeight = latest?.weight?.toStringAsFixed(1) ?? '--';
        final latestHeartRate = latest?.heartRate?.toString() ?? '--';
        final latestBP = latest?.bloodPressure ?? '--';
        
        // Calculate trends (comparing to previous measurement if available)
        String? weightTrend;
        String? heartRateTrend;
        String? bpTrend;
        
        if (measurements.length >= 2) {
          final current = measurements[0];
          final previous = measurements[1];
          
          if (current.weight != null && previous.weight != null) {
            final diff = current.weight! - previous.weight!;
            weightTrend = diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1);
          }
          
          if (current.heartRate != null && previous.heartRate != null) {
            final diff = current.heartRate! - previous.heartRate!;
            heartRateTrend = diff > 0 ? '+$diff' : '$diff';
          }
          
          if (current.systolic != null && previous.systolic != null) {
            final diff = current.systolic! - previous.systolic!;
            bpTrend = diff > 0 ? '↑' : diff < 0 ? '↓' : '→';
          }
        }

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFAF0FF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<MeasurementsBloc>().add(LoadMeasurements());
                  // Wait a bit for the refresh to complete
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Time Range Selector
                      Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: TimeRange.values.map((range) {
                          final isSelected = _selectedRange == range;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRange = range;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? themeData.primaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _getRangeLabel(range),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Top Row: Weight & Heart Rate
                    Row(
                      children: [
                        Expanded(
                          child: VitalsCard(
                            iconPath: 'assets/icons/health.svg',
                            title: localizations.weight,
                            value: '$latestWeight Kg',
                            status: latest?.weightStatus ?? localizations.normal,
                            statusColor: const Color(0xFFB8E6B8),
                            textColor: const Color(0xFF2D5F2D),
                            trend: weightTrend,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: VitalsCard(
                            iconPath: 'assets/icons/heartplus.svg',
                            title: localizations.heartRate,
                            value: '$latestHeartRate bpm',
                            status: latest?.heartRateStatus ?? localizations.normal,
                            statusColor: _getStatusColor(latest?.heartRateStatus),
                            textColor: _getStatusTextColor(latest?.heartRateStatus),
                            trend: heartRateTrend,
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
                            value: latestBP,
                            status: latest?.bloodPressureStatus ?? localizations.normal,
                            statusColor: _getStatusColor(latest?.bloodPressureStatus),
                            textColor: _getStatusTextColor(latest?.bloodPressureStatus),
                            trend: bpTrend,
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
                    BMICard(measurements: measurements),

                    const SizedBox(height: 16),

                    // Weight Progress Chart
                    WeightProgressChart(
                      measurements: measurements,
                      timeRange: _selectedRange,
                    ),

                    const SizedBox(height: 16),

                    // Heart Rate Chart
                    if (measurements.any((m) => m.heartRate != null))
                      _buildHeartRateChart(context, measurements, themeData),

                    if (measurements.any((m) => m.heartRate != null))
                      const SizedBox(height: 16),

                    // Blood Pressure Chart
                    if (measurements.any((m) => m.systolic != null))
                      _buildBloodPressureChart(context, measurements, themeData),

                    if (measurements.any((m) => m.systolic != null))
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
      },
    );
  }

  Widget _buildHeartRateChart(BuildContext context, List measurements, themeData) {
    final l10n = AppLocalizations.of(context)!;
    
    // Filter measurements based on time range
    final filteredData = _filterByTimeRange(measurements);
    final heartRateData = filteredData
        .where((m) => m.heartRate != null)
        .toList()
        .reversed
        .toList(); // Reverse so oldest is first (left to right)
    
    if (heartRateData.isEmpty) return const SizedBox.shrink();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Heart Rate Progress',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusColor(heartRateData.first.heartRateStatus),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  heartRateData.first.heartRateStatus,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: _getStatusTextColor(heartRateData.first.heartRateStatus),
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
                      reservedSize: 35,
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
                        if (index >= 0 && index < heartRateData.length) {
                          return Text(
                            '${heartRateData[index].recordedAt.day}/${heartRateData[index].recordedAt.month}',
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 8,
                              color: AppColors.textDark,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      heartRateData.length,
                      (index) => FlSpot(index.toDouble(), heartRateData[index].heartRate!.toDouble()),
                    ),
                    isCurved: true,
                    color: const Color(0xFFE91E63),
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: const Color(0xFFE91E63),
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

  Widget _buildBloodPressureChart(BuildContext context, List measurements, themeData) {
    final l10n = AppLocalizations.of(context)!;
    
    // Filter measurements based on time range
    final filteredData = _filterByTimeRange(measurements);
    final bpData = filteredData
        .where((m) => m.systolic != null && m.diastolic != null)
        .toList()
        .reversed
        .toList(); // Reverse so oldest is first (left to right)
    
    if (bpData.isEmpty) return const SizedBox.shrink();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Blood Pressure Trend',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusColor(bpData.first.bloodPressureStatus),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  bpData.first.bloodPressureStatus,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: _getStatusTextColor(bpData.first.bloodPressureStatus),
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
                      reservedSize: 35,
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
                        if (index >= 0 && index < bpData.length) {
                          return Text(
                            '${bpData[index].recordedAt.day}/${bpData[index].recordedAt.month}',
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 8,
                              color: AppColors.textDark,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Systolic line
                  LineChartBarData(
                    spots: List.generate(
                      bpData.length,
                      (index) => FlSpot(index.toDouble(), bpData[index].systolic!.toDouble()),
                    ),
                    isCurved: true,
                    color: const Color(0xFFFF5722),
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: const Color(0xFFFF5722),
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  // Diastolic line
                  LineChartBarData(
                    spots: List.generate(
                      bpData.length,
                      (index) => FlSpot(index.toDouble(), bpData[index].diastolic!.toDouble()),
                    ),
                    isCurved: true,
                    color: const Color(0xFF2196F3),
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: const Color(0xFF2196F3),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Systolic', const Color(0xFFFF5722)),
              const SizedBox(width: 16),
              _buildLegendItem('Diastolic', const Color(0xFF2196F3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.smallLabel.copyWith(
            fontSize: 10,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  List _filterByTimeRange(List measurements) {
    final now = DateTime.now();
    switch (_selectedRange) {
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
