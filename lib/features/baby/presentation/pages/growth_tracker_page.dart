// lib/features/baby/presentation/pages/growth_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class GrowthTrackerPage extends StatefulWidget {
  const GrowthTrackerPage({super.key});

  @override
  State<GrowthTrackerPage> createState() => _GrowthTrackerPageState();
}

class _GrowthTrackerPageState extends State<GrowthTrackerPage> {
  bool showWeight = true;

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
                        'Growth Tracker',
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
                      // Toggle between Weight and Height
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => showWeight = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: showWeight ? AppColors.main500 : AppColors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: AppColors.shadow1,
                                ),
                                child: Center(
                                  child: Text(
                                    'Weight',
                                    style: AppTextStyles.subtitle1.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: showWeight ? AppColors.white : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => showWeight = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !showWeight ? AppColors.main500 : AppColors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: AppColors.shadow1,
                                ),
                                child: Center(
                                  child: Text(
                                    'Height',
                                    style: AppTextStyles.subtitle1.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: !showWeight ? AppColors.white : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Current Stats
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
                        child: Column(
                          children: [
                            Text(
                              showWeight ? 'Current Weight' : 'Current Height',
                              style: AppTextStyles.body1.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              showWeight ? '5.2 kg' : '58 cm',
                              style: AppTextStyles.numberHighlight.copyWith(fontSize: 36),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Last updated: Oct 25, 2024',
                              style: AppTextStyles.smallLabel.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Chart Placeholder
                      Container(
                        height: 250,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppColors.shadow1,
                        ),
                        child: Column(
                          children: [
                            Text(
                              showWeight ? 'Weight Progress Chart' : 'Height Progress Chart',
                              style: AppTextStyles.subtitle1.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Center(
                                child: Icon(Icons.show_chart, size: 80, color: AppColors.textSecondary),
                              ),
                            ),
                            Text(
                              'Chart visualization would go here',
                              style: AppTextStyles.smallLabel,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Recent Logs
                      Text(
                        'Recent Logs',
                        style: AppTextStyles.headline2,
                      ),
                      const SizedBox(height: 12),
                      _buildLogItem('5.2 kg', 'Oct 25, 2024', true),
                      _buildLogItem('5.0 kg', 'Oct 18, 2024', false),
                      _buildLogItem('4.8 kg', 'Oct 11, 2024', false),
                      const SizedBox(height: 24),

                      // Add Log Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddLogDialog(context),
                          icon: const Icon(Icons.add),
                          label: Text(showWeight ? 'Add Weight Log' : 'Add Height Log'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.main500,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
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

  Widget _buildLogItem(String value, String date, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLatest ? AppColors.pink300.withValues(alpha: 0.3) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest ? AppColors.pink500 : Colors.transparent,
          width: 2,
        ),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isLatest ? AppColors.pink500 : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                value,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isLatest ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(date, style: AppTextStyles.body1),
        ],
      ),
    );
  }

  void _showAddLogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.bg_1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            showWeight ? 'Add Weight Log' : 'Add Height Log',
            style: AppTextStyles.headline2,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: showWeight ? 'Weight (kg)' : 'Height (cm)',
                  labelStyle: AppTextStyles.body1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.main500, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: AppTextStyles.body1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: const Icon(Icons.calendar_today, color: AppColors.main500),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main500,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}