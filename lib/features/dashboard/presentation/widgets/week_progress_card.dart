// lib/features/dashboard/presentation/widgets/week_progress_card.dart
import 'package:flutter/material.dart';

class WeekProgressCard extends StatelessWidget {
  final int currentWeek;
  final int currentDay;
  final String trimester;
  final int daysLeft;
  final double progressPercentage;

  const WeekProgressCard({
    super.key,
    required this.currentWeek,
    required this.currentDay,
    required this.trimester,
    required this.daysLeft,
    required this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4B5E8), Color(0xFFE8C8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4B5E8).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress Percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${progressPercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9B7FDB),
                    ),
                  ),
                  const Text(
                    'DONE',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              // Week Circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF9B7FDB),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'WEEK',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '$currentWeek',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9B7FDB),
                        ),
                      ),
                      Text(
                        '+$currentDay day',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Days Left
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$daysLeft',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9B7FDB),
                    ),
                  ),
                  const Text(
                    'DAYS LEFT',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            trimester,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}