import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

/// Category tab for horizontal category selector
class TipsCategoryTab extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const TipsCategoryTab({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'sport':
        return Icons.fitness_center;
      case 'sleep':
        return Icons.bedtime;
      case 'mental':
        return Icons.psychology;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return AppColors.pink500;
      case 'sport':
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(category);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected 
            ? categoryColor.withOpacity(0.15)
            : AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected 
              ? categoryColor 
              : AppColors.purpleGrey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
            ? [
                BoxShadow(
                  color: categoryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : AppColors.shadow1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 18,
              color: isSelected ? categoryColor : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? categoryColor : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
