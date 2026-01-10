import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class HealthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onNotificationTapped;

  const HealthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onNotificationTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color.fromARGB(255, 247, 240, 254), // Slightly whiter purple
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  title,
                  style: AppTextStyles.headline1.copyWith(
                    color: AppColors.main500,
                    fontSize: 40,
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
                    color: const Color(0xFFF5EBFF),
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
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.main500, // Changed to purple
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}