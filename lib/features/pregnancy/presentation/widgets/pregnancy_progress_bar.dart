import 'package:flutter/material.dart';

class PregnancyProgressBar extends StatelessWidget {
  final int currentWeek;
  final int currentDay;
  final String trimester;
  final int daysLeft; // total days remaining
  final String dueDate;

  const PregnancyProgressBar({
    super.key,
    required this.currentWeek,
    required this.currentDay,
    required this.trimester,
    required this.daysLeft,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    // Pregnancy lasts about 280 days (40 weeks)
    const totalPregnancyDays = 280;
    final currentDaysPassed = (currentWeek * 7) + currentDay;
    final progress = currentDaysPassed / totalPregnancyDays;

    // Convert remaining days back to weeks + days
    final weeksLeft = daysLeft ~/ 7;
    final extraDaysLeft = daysLeft % 7;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFB07CDE), // solid purple background like your image
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: current duration + trimester
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentWeek weeks and $currentDay days',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                trimester,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8A4DC3),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bottom row: due date + remaining weeks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date of labor $dueDate',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$weeksLeft weeks and $extraDaysLeft days left',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
