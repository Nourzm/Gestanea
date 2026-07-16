import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

/// Empty state widget for tips
class TipsEmptyState extends StatelessWidget {
  final String? category;

  const TipsEmptyState({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.main300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 64,
                color: AppColors.main600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No tips available',
              style: AppTextStyles.headline2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category != null && category!.toLowerCase() != 'all'
                ? 'We don\'t have any $category tips for your current stage yet.'
                : 'Check back later for new tips!',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
