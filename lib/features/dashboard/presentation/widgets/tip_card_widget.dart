import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/tip_model.dart';

/// Reusable tip card widget displaying tip preview
class TipCardWidget extends StatelessWidget {
  final TipModel tip;
  final bool isHighPriority;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSaveToggle;

  const TipCardWidget({
    super.key,
    required this.tip,
    this.isHighPriority = false,
    this.isSaved = false,
    this.onTap,
    this.onSaveToggle,
  });

  String _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return 'assets/icons/food.svg';
      case 'sport':
      case 'exercise':
        return 'assets/icons/sport.svg';
      case 'sleep':
        return 'assets/icons/sleep.svg';
      case 'mental':
        return 'assets/icons/mental.svg';
      case 'medical':
        return 'assets/icons/medical.svg';
      default:
        return 'assets/icons/health.svg';
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return AppColors.pink500;
      case 'sport':
      case 'exercise':
        return AppColors.blue500;
      case 'sleep':
        return AppColors.main500;
      case 'mental':
        return AppColors.pink400;
      case 'medical':
        return AppColors.error1;
      default:
        return AppColors.main600;
    }
  }

  String _getTimeBadge(int? weekFrom, int? weekTo, int? monthFrom, int? monthTo, bool isGlobal) {
    if (isGlobal) return 'Always';
    if (weekFrom != null && weekTo != null) {
      return 'Week $weekFrom-$weekTo';
    }
    if (weekFrom != null) {
      return 'Week $weekFrom+';
    }
    if (monthFrom != null && monthTo != null) {
      return 'Month $monthFrom-$monthTo';
    }
    if (monthFrom != null) {
      return 'Month $monthFrom+';
    }
    return 'General';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(tip.category);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHighPriority 
            ? [
                BoxShadow(
                  color: categoryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                ...AppColors.shadow1,
              ]
            : AppColors.shadow1,
          border: isHighPriority 
            ? Border.all(color: categoryColor.withOpacity(0.5), width: 2)
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Category chip + Time badge + Save button
            Row(
              children: [
                // Category chip
                if (tip.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: categoryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIconData(tip.category),
                          size: 16,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tip.category!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                // Time badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.main300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getTimeBadge(
                      tip.pregnancyWeekFrom,
                      tip.pregnancyWeekTo,
                      tip.pregnancyMonthFrom,
                      tip.pregnancyMonthTo,
                      tip.isGlobal,
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.main600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Save button
                if (onSaveToggle != null)
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? AppColors.main600 : AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: onSaveToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              tip.title,
              style: AppTextStyles.headline2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Description (short preview)
            Text(
              _truncateContent(tip.content, 120),
              style: AppTextStyles.body1.copyWith(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textDark.withOpacity(0.7),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (isHighPriority) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 14, color: categoryColor),
                    const SizedBox(width: 4),
                    Text(
                      'High Priority',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIconData(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'sport':
      case 'exercise':
        return Icons.fitness_center;
      case 'sleep':
        return Icons.bedtime;
      case 'mental':
        return Icons.psychology;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.health_and_safety;
    }
  }

  String _truncateContent(String content, int maxLength) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }
}
