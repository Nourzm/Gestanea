import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class UpcomingAppointmentsCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final int scheduledCount;

  const UpcomingAppointmentsCard({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.scheduledCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(4, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 10,
            offset: Offset(-6, -6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.upcomingAppointments,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),
                Text(
                  '$scheduledCount ${localization.scheduled}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg_1,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(3, 3),
                ),
                BoxShadow(
                  color: const Color(0xFFFFFFFF),
                  blurRadius: 8,
                  offset: const Offset(-3, -3),
                ),
              ],
            ),
            child: Icon(Icons.access_time, color: AppColors.main600, size: 28),
          ),
        ],
      ),
    );
  }
}
