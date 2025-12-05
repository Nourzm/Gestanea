// =============================================================================
// FILE: presentation/pages/feeding_log_page.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class FeedingLogPage extends StatefulWidget {
  
  const FeedingLogPage({super.key});

  @override
  State<FeedingLogPage> createState() => _FeedingLogPageState();
}

class _FeedingLogPageState extends State<FeedingLogPage> {
  String selectedType = 'Breastfeed';

  // TODO: Load from database
  final List<Map<String, dynamic>> feedingLogs = [
    {
      'type': 'Breastfeed',
      'time': '2:30 PM',
      'duration': '15 min',
      'side': 'Left'
    },
    {
      'type': 'Bottle',
      'time': '11:00 AM',
      'amount': '120 ml',
      'side': null
    },
    {
      'type': 'Breastfeed',
      'time': '8:30 AM',
      'duration': '20 min',
      'side': 'Right'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                        'Feeding Log',
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
                      // Today's Summary
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.pink500, AppColors.pink300],
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
                                Icon(Icons.restaurant, color: AppColors.white, size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  '8 times', // TODO: Calculate from today's data
                                  style: AppTextStyles.headline2.copyWith(color: AppColors.white),
                                ),
                                Text(
                                  'Today',
                                  style: AppTextStyles.smallLabel.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: AppColors.white.withValues(alpha: 0.3),
                            ),
                            Column(
                              children: [
                                Icon(Icons.timer, color: AppColors.white, size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  '2h 15m', // TODO: Calculate from today's data
                                  style: AppTextStyles.headline2.copyWith(color: AppColors.white),
                                ),
                                Text(
                                  'Total Time',
                                  style: AppTextStyles.smallLabel.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Feeding Type Selector
                      Row(
                        children: [
                          Expanded(
                            child: _buildTypeButton('Breastfeed', Icons.child_care),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTypeButton('Bottle', Icons.baby_changing_station),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Recent Logs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Feedings',
                            style: AppTextStyles.headline2,
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to all feeding logs page
                              debugPrint('Navigate to All Feeding Logs');
                            },
                            child: Text(
                              'View All',
                              style: AppTextStyles.body1.copyWith(color: AppColors.main500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...feedingLogs.map((log) => _buildFeedingLogItem(log)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddFeedingDialog(context);
        },
        backgroundColor: AppColors.main500,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('Add Feeding', style: AppTextStyles.bodyWhite),
      ),
    );
  }

  Widget _buildTypeButton(String type, IconData icon) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main500 : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedingLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.pink500.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              log['type'] == 'Breastfeed'
                  ? Icons.child_care
                  : Icons.baby_changing_station,
              color: AppColors.pink500,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['type'],
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log['side'] != null
                      ? '${log['duration']} - ${log['side']} side'
                      : '${log['amount']}',
                  style: AppTextStyles.body1,
                ),
              ],
            ),
          ),
          Text(
            log['time'],
            style: AppTextStyles.body1,
          ),
        ],
      ),
    );
  }

  void _showAddFeedingDialog(BuildContext context) {
    String feedingType = 'Breastfeed';
    final TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Add Feeding',
                style: AppTextStyles.headline2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: feedingType,
                    decoration: InputDecoration(
                      labelText: 'Feeding Type',
                      labelStyle: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.purpleGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.main500),
                      ),
                    ),
                    items: ['Breastfeed', 'Bottle'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppTextStyles.body1),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        feedingType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.body1,
                    decoration: InputDecoration(
                      labelText: feedingType == 'Breastfeed'
                          ? 'Duration (minutes)'
                          : 'Amount (ml)',
                      labelStyle: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.purpleGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.main500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    style: AppTextStyles.body1,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      labelStyle: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.purpleGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.main500),
                      ),
                      suffixIcon: Icon(Icons.access_time, color: AppColors.main500),
                      hintText: TimeOfDay.now().format(context),
                      hintStyle: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      // TODO: Show time picker
                      debugPrint('Show time picker');
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Save to database
                    debugPrint('Saving feeding: $feedingType - ${durationController.text}');
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main500,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save', style: AppTextStyles.bodyWhite),
                ),
              ],
            );
          },
        );
      },
    );
  }
}