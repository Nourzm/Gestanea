import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class VitalsCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final String status;
  final Color statusColor;
  final Color textColor;

  const VitalsCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    required this.status,
    required this.statusColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.cardColor,
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
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  themeData.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 16,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: textColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
