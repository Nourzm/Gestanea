import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class BMICard extends StatelessWidget {
  const BMICard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.main500, Color(0xFFB388CC)],
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
          Text(
            l10n.prePregnancyBMI,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '22. 5 (${l10n.normalBMI})',
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          
          // Progress Bar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.currentGain}: 0 kg',
                      style: AppTextStyles.smallLabel.copyWith(
                        color: Colors.white. withValues(alpha: 0.9),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.0, // 0% progress (no gain yet)
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.targetRange,
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '11.5 - 16 kg',
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${l10n.expected}: 5.5 kg',
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}