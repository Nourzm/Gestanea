import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class VaccineTrackerPage extends StatelessWidget {
  final bool isGirl; // true for girl (pink), false for boy (blue)
  const VaccineTrackerPage({super.key, required this.isGirl});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final Color primaryColor = isGirl ? AppColors.pink500 : AppColors.blue500;
    final Color secondaryColor = isGirl ? AppColors.pink300 : AppColors.main300;
    final Color backgroundColor = AppColors.bg_1;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        t.vaccineTrackerTitle,
                        style: AppTextStyles.headline2.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Month Selector
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chevron_left, color: AppColors.white),
                        const SizedBox(width: 16),
                        Text(
                          'March 2024',
                          style: AppTextStyles.subtitle1.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.chevron_right, color: AppColors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Vaccine List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    _buildVaccineCard(
                      title: 'BCG + HRV',
                      subtitle: '${t.completedLabel}: Birth (Jan 15)',
                      completed: true,
                      primaryColor: primaryColor,
                    ),
                    _buildVaccineCard(
                      title: 'Rotavirus',
                      subtitle: '${t.completedLabel}: 2 months (Feb 20)',
                      completed: true,
                      primaryColor: primaryColor,
                    ),
                    _buildVaccineCard(
                      title: 'PCV13',
                      subtitle: '${t.upcomingLabel}: 2 months (April 10)',
                      completed: false,
                      primaryColor: primaryColor,
                    ),
                    _buildVaccineCard(
                      title: 'DTcaVPI-Hib-HBV',
                      subtitle: '${t.upcomingLabel}: 3 months (May 10)',
                      completed: false,
                      primaryColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),

            // See Full Schedule
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  t.seeFullSchedule,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineCard({
    required String title,
    required String subtitle,
    required bool completed,
    required Color primaryColor,
  }) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green.withValues(alpha: 0.1)
                  : primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              completed ? Icons.check_circle : Icons.access_time,
              color: completed ? Colors.green : primaryColor,
              size: 24,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body1.copyWith(
                    color: completed ? Colors.green : AppColors.textSecondary,
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
