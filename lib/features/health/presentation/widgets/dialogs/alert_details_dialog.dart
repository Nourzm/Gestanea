import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';

class AlertDetailsDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final String severity;
  final String description;
  final List<String> recommendedActions;

  const AlertDetailsDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.severity,
    required this.description,
    required this.recommendedActions,
  });

  Color _getSeverityColor() {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFFFC4C4);
      case 'medium':
        return const Color(0xFFFFE0B2);
      case 'low':
        return const Color(0xFFB8E6B8);
      default:
        return const Color(0xFFFFF3CD);
    }
  }

  Color _getSeverityTextColor() {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFD32F2F);
      case 'medium':
        return const Color(0xFFE65100);
      case 'low':
        return const Color(0xFF2D5F2D);
      default:
        return const Color(0xFF856404);
    }
  }

  void _contactDoctor(BuildContext context) {
    // TODO: Implement contact doctor functionality
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF0FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Icon and Title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.white,
                    blurRadius: 6,
                    offset: Offset(-3, -3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.main300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 48,
                      color: AppColors.main500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headline2.copyWith(
                      fontSize: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$severity Risk',
                      style: AppTextStyles.subtitle1.copyWith(
                        fontSize: 14,
                        color: _getSeverityTextColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.white,
                    blurRadius: 6,
                    offset: Offset(-3, -3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: AppTextStyles.subtitle1.copyWith(
                      fontSize: 14,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.white,
                    blurRadius: 6,
                    offset: Offset(-3, -3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.main500, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Recommended Actions',
                        style: AppTextStyles.subtitle1.copyWith(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...recommendedActions.map((action) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.main500,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            action,
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 13,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Dismiss',
                    filled: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: () => _contactDoctor(context),
                    text: 'Contact Doctor',
                    filled: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showAlertDetailsDialog(
  BuildContext context, {
  required String title,
  required IconData icon,
  required String severity,
  required String description,
  required List<String> recommendedActions,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AlertDetailsDialog(
      title: title,
      icon: icon,
      severity: severity,
      description: description,
      recommendedActions: recommendedActions,
    ),
  );
}
