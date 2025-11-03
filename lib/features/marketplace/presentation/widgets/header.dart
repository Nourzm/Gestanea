import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class MarketplaceHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onNotificationTapped;

  const MarketplaceHeader({
    super.key,
    required this.title,
    this.onNotificationTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: AppTextStyles.headline1.copyWith(
                color: AppColors.main500,
                fontSize: 40,
                fontFamily: 'Lato',
                letterSpacing: -0.40,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 45,
              height: 45,
              decoration: ShapeDecoration(
                color: AppColors.bg_1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.04),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x4C000000),
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
              child: IconButton(
                onPressed: onNotificationTapped,
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.main500,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
