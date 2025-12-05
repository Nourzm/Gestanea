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
        padding: const EdgeInsets. all(10), // ✅ Reduced from 12 to 10
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: AppColors.white, size: 18), // ✅ Reduced from 20 to 18
                const SizedBox(width: 4), // ✅ Reduced from 6 to 4
                Expanded(
                  child: Text(
                    '${localizations.add}\n${localizations.measurement}',
                    style: AppTextStyles.subtitle1.copyWith(
                      fontSize: 12, // ✅ Reduced from 13 to 12
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // ✅ Reduced from 8 to 6
            const SizedBox(height: 16), // ✅ Reduced from 20 to 16
          ],
        ),
      ),
    );
  }
}