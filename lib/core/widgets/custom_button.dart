import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final dynamic suffixIcon; // IconData or SVG asset path

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget;
    if (suffixIcon != null) {
      if (suffixIcon is IconData) {
        iconWidget = Icon(suffixIcon, color: AppColors.white, size: 22);
      } else if (suffixIcon is String) {
        iconWidget = SvgPicture.asset(
          suffixIcon,
          width: 18,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        );
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.main600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Invisible placeholder to keep text centered
              Opacity(
                opacity: 0,
                child: iconWidget ?? const SizedBox(width: 22, height: 22),
              ),

              // Centered text
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Visible suffix icon (right side)
              if (iconWidget != null)
                iconWidget
              else
                const SizedBox(width: 22, height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
