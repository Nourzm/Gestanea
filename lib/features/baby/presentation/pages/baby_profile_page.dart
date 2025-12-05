// lib/features/baby/presentation/pages/baby_profile_page.dart
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'growth_tracker_page.dart';
import 'milestone_tracker_page.dart';

class BabyProfilePage extends StatelessWidget {
  const BabyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get data from BabyProvider
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header with edit action
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
                        'Baby Profile',
                        style: AppTextStyles.headline1.copyWith(color: AppColors.main500),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.main500),
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Baby Avatar
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.pink500,
                          shape: BoxShape.circle,
                          boxShadow: AppColors.shadow1,
                        ),
                        child: const Icon(Icons.child_care, size: 60, color: AppColors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Emma',
                        style: AppTextStyles.headline1.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: 32),

                      // Info Cards
                      _buildInfoCard('Gender', 'Female', Icons.female, AppColors.pink500),
                      const SizedBox(height: 12),
                      _buildInfoCard('Date of Birth', 'July 15, 2024', Icons.cake, AppColors.main500),
                      const SizedBox(height: 12),
                      _buildInfoCard('Age', '3 months', Icons.access_time, AppColors.blue500),
                      const SizedBox(height: 12),
                      _buildInfoCard('Current Weight', '5.2 kg', Icons.monitor_weight, AppColors.pink500),
                      const SizedBox(height: 12),
                      _buildInfoCard('Current Height', '58 cm', Icons.height, AppColors.main500),
                      const SizedBox(height: 32),

                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GrowthTrackerPage()),
                            );
                          },
                          icon: const Icon(Icons.trending_up),
                          label: const Text('View Growth Chart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.main500,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MilestoneTrackerPage()),
                            );
                          },
                          icon: const Icon(Icons.emoji_events),
                          label: const Text('Track Milestones'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.main500,
                            side: const BorderSide(color: AppColors.main500, width: 2),
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

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
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
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.smallLabel,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}