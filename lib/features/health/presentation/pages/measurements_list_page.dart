import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/models/measurement_model.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_event.dart';
import '../../logic/bloc/measurements_state.dart';

class MeasurementsListPage extends StatelessWidget {
  const MeasurementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Measurements'),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
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
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          }
          
          if (state is MeasurementsLoaded) {
            if (state.measurements.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No measurements yet! ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Tap "Add Measurement" to start. '),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.measurements.length,
              itemBuilder: (context, index) {
                final measurement = state.measurements[index];
                return _buildMeasurementCard(measurement);
              },
            );
          }
          
          return const Center(child: Text('No data'));
        },
      ),
    );
  }

  Widget _buildMeasurementCard(MeasurementModel measurement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.main500),
                const SizedBox(width: 8),
                Text(
                  '${measurement.recordedAt.day}/${measurement.recordedAt.month}/${measurement.recordedAt.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight. bold,
                    color: AppColors.main500,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 16, color: AppColors.main500),
                const SizedBox(width: 8),
                Text(
                  '${measurement.recordedAt.hour}:${measurement.recordedAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (measurement.weight != null)
              _buildDetailRow(
                Icons.monitor_weight_outlined,
                'Weight',
                '${measurement.weight} kg',
                measurement.weightStatus,
              ),
            if (measurement.heartRate != null)
              _buildDetailRow(
                Icons.favorite,
                'Heart Rate',
                '${measurement.heartRate} bpm',
                measurement.heartRateStatus,
              ),
            if (measurement.systolic != null && measurement.diastolic != null)
              _buildDetailRow(
                Icons.favorite_border,
                'Blood Pressure',
                measurement.bloodPressure,
                measurement. bloodPressureStatus,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, String status) {
    Color statusColor;
    Color textColor;
    
    switch (status. toLowerCase()) {
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
        statusColor = Colors.grey. shade300;
        textColor = Colors.grey.shade700;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.main500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
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