import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class AddMeasurementCard extends StatelessWidget {
  final VoidCallback?  onTap;

  const AddMeasurementCard({super. key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations. of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets. all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.pink600, AppColors.pink500],
          ),
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
          mainAxisAlignment: MainAxisAlignment.center, // ✅ Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ Center horizontally
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ Center the row content
              children: [
                Icon(Icons.add_circle_outline, color: AppColors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  '${localizations.add}\n${localizations. measurement}',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center, // ✅ Center text alignment
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}