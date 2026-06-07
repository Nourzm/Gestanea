import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class MedicineProgressCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final double progress;
  final String takenText;

  const MedicineProgressCard({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.progress,
    required this.takenText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(4, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 10,
            offset: Offset(-6, -6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.todaysMedicine,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: AppColors.main600,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            takenText,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.purpleGrey.withValues(alpha: 0.3),
              color: AppColors.main600,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
