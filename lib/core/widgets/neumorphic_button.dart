import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class NeumorphicButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onPressed;

  final String text;
  final Icon icon;
  final Color color;

  const NeumorphicButton({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color = AppColors.main500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(4, 4),
            ),
            BoxShadow(
              color: Color(0x7FFFFFFF),
              blurRadius: 10,
              offset: Offset(-6, -6),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xFFDFE2E8), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  text,
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
