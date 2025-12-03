// lib/features/dashboard/presentation/widgets/upcoming_reminders_widget.dart
import 'package:flutter/material.dart';
import '../../domain/entities/pregnancy_dashboard.dart';

class UpcomingRemindersWidget extends StatelessWidget {
  final List<AppointmentReminder> appointments;
  final List<MedicineReminder> medicines;

  const UpcomingRemindersWidget({
    super.key,
    required this.appointments,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Appointments (next 3)
        ...appointments
            .take(3)
            .map(
              (apt) => _buildReminderItem(
                apt.title,
                _formatTime(apt.dateTime),
                _getIconForType(apt.type),
                const Color(0xFF9B7FDB),
              ),
            ),

        // Medicines (next 2)
        ...medicines
            .take(2)
            .map(
              (med) => _buildReminderItem(
                med.medicineName,
                '${_formatTime(med.nextDoseTime)} - ${med.dosage}',
                Icons.medication,
                const Color(0xFFE8A5C8),
              ),
            ),
      ],
    );
  }

  Widget _buildReminderItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'doctor':
        return Icons.medical_services;
      case 'ultrasound':
        return Icons.monitor_heart;
      case 'test':
        return Icons.bloodtype;
      default:
        return Icons.event;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inHours < 24) {
      if (difference.inHours < 1) {
        return 'In ${difference.inMinutes} minutes';
      }
      return 'In ${difference.inHours} hours';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }
  }
}
