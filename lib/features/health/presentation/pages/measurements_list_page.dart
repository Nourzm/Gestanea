import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../../../core/database/models/measurement_model.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_event.dart';
import '../../logic/bloc/measurements_state.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class MeasurementsListPage extends StatelessWidget {
  const MeasurementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myMeasurements),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) {
          if (state is MeasurementsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MeasurementsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('${AppLocalizations.of(context)!.error}: ${state.message}'),
                ],
              ),
            );
          }

          if (state is MeasurementsLoaded) {
            if (state.measurements.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No measurements yet! ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.tapAddMeasurementToStart),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.measurements.length,
              itemBuilder: (context, index) {
                final measurement = state.measurements[index];
                return _buildMeasurementCard(context, measurement);
              },
            );
          }

          return Center(child: Text(AppLocalizations.of(context)!.noData));
        },
      ),
    );
  }

  Widget _buildMeasurementCard(
    BuildContext context,
    MeasurementModel measurement,
  ) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: themeData.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${measurement.recordedAt.day}/${measurement.recordedAt.month}/${measurement.recordedAt.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeData.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: themeData.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${measurement.recordedAt.hour}:${measurement.recordedAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24),
            if (measurement.weight != null)
              _buildDetailRow(
                context,
                Icons.monitor_weight_outlined,
                'Weight',
                '${measurement.weight} kg',
                measurement.weightStatus,
              ),
            if (measurement.heartRate != null)
              _buildDetailRow(
                context,
                Icons.favorite,
                'Heart Rate',
                '${measurement.heartRate} bpm',
                measurement.heartRateStatus,
              ),
            if (measurement.systolic != null && measurement.diastolic != null)
              _buildDetailRow(
                context,
                Icons.favorite_border,
                'Blood Pressure',
                measurement.bloodPressure,
                measurement.bloodPressureStatus,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String status,
  ) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    Color statusColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'normal':
        statusColor = const Color(0xFFB8E6B8);
        textColor = const Color(0xFF2D5F2D);
        break;
      case 'elevated':
        statusColor = const Color(0xFFFFE8B2);
        textColor = const Color(0xFF8B6914);
        break;
      case 'high':
        statusColor = const Color(0xFFFFD4D4);
        textColor = const Color(0xFF8B2020);
        break;
      case 'low':
        statusColor = const Color(0xFFFFE8B2);
        textColor = const Color(0xFF8B6914);
        break;
      default:
        statusColor = Colors.grey.shade300;
        textColor = Colors.grey.shade700;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: themeData.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
