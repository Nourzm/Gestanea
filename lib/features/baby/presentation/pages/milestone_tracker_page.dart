// =============================================================================
// FILE: presentation/pages/milestone_tracker_page.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class MilestoneTrackerPage extends StatefulWidget {
  const MilestoneTrackerPage({super.key});

  @override
  State<MilestoneTrackerPage> createState() => _MilestoneTrackerPageState();
}

class _MilestoneTrackerPageState extends State<MilestoneTrackerPage> {
  // TODO: Load from database
  final List<Map<String, dynamic>> milestones = [
    {
      'title': 'First Smile',
      'age': '6 weeks',
      'completed': true,
      'date': 'Aug 26, 2024'
    },
    {
      'title': 'Holds Head Up',
      'age': '2 months',
      'completed': true,
      'date': 'Sep 15, 2024'
    },
    {
      'title': 'Rolls Over',
      'age': '4 months',
      'completed': false,
      'date': null
    },
    {
      'title': 'Sits Without Support',
      'age': '6 months',
      'completed': false,
      'date': null
    },
    {
      'title': 'Crawls',
      'age': '8 months',
      'completed': false,
      'date': null
    },
    {
      'title': 'First Words',
      'age': '12 months',
      'completed': false,
      'date': null
    },
  ];

  @override
  Widget build(BuildContext context) {
    int completedCount = milestones.where((m) => m['completed'] == true).length;
    int totalCount = milestones.length;
    double percentage = (completedCount / totalCount * 100);

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Milestones',
                        style: AppTextStyles.headline1.copyWith(color: AppColors.main500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.main500, AppColors.main300],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppColors.shadow1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '$completedCount/$totalCount',
                                  style: AppTextStyles.numberHighlight.copyWith(fontSize: 32),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Completed',
                                  style: AppTextStyles.body1.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${percentage.toInt()}%',
                                  style: AppTextStyles.numberHighlight.copyWith(fontSize: 24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Milestones List
                      Text(
                        'Developmental Milestones',
                        style: AppTextStyles.headline2,
                      ),
                      const SizedBox(height: 12),
                      ...milestones.map((milestone) => _buildMilestoneItem(
                            milestone['title'],
                            milestone['age'],
                            milestone['completed'],
                            milestone['date'],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneItem(
    String title,
    String age,
    bool completed,
    String? date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed ? AppColors.main500 : Colors.transparent,
          width: 2,
        ),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed ? AppColors.main500 : AppColors.purpleGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed ? Icons.check : Icons.emoji_events_outlined,
              color: completed ? AppColors.white : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completed && date != null
                      ? 'Completed: $date'
                      : 'Expected at $age',
                  style: AppTextStyles.smallLabel,
                ),
              ],
            ),
          ),
          if (!completed)
            IconButton(
              onPressed: () {
                setState(() {
                  // TODO: Mark milestone as completed and save to database
                  debugPrint('Mark $title as completed');
                });
              },
              icon: const Icon(Icons.check_circle_outline),
              color: AppColors.main500,
            ),
        ],
      ),
    );
  }
}

