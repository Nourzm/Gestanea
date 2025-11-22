import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final dynamic suffixIcon; // IconData or SVG asset path
  final bool filled; // true = filled, false = outlined
  final double? maxWidth;
  final double? minHeight;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.filled = true,
    this.maxWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    Widget? iconWidget;
    if (suffixIcon != null) {
      if (suffixIcon is IconData) {
        iconWidget = Icon(
          suffixIcon,
          color: filled ? AppColors.white : AppColors.main700,
          size: 22,
        );
      } else if (suffixIcon is String) {
        iconWidget = SvgPicture.asset(
          suffixIcon,
          width: 18,
          colorFilter: ColorFilter.mode(
              filled ? AppColors.white : AppColors.main700, BlendMode.srcIn),
        );
      }
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? screenHeight * 0.06,
      ),
      decoration: BoxDecoration(
        color: filled ? AppColors.main600 : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: filled ? Colors.transparent : AppColors.main600,
          width: 2,
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.018,
          ),
        ),
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
              style: TextStyle(
                color: filled ? AppColors.white : AppColors.main700,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Visible suffix icon (right side)
            if (iconWidget != null)
              Padding(
                padding:EdgeInsets.only(right:10),
                child: iconWidget,
              )
            else
              const SizedBox(width: 22, height: 22),
          ],
        ),
      ),
    );
  }
}
