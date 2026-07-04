import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final dynamic suffixIcon; // IconData or SVG asset path
  final bool filled;
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
    final size = MediaQuery.of(context).size;
    final buttonHeight = minHeight ?? size.height * 0.055;

    // Responsive padding
    final verticalPadding = size.height * 0.012;
    final horizontalPadding = size.width * 0.04;

    // Icon logic
    Widget? iconWidget;
    if (suffixIcon != null) {
      if (suffixIcon is IconData) {
        iconWidget = Icon(
          suffixIcon,
          color: filled ? Colors.white : AppColors.main700,
          size: 20,
        );
      } else if (suffixIcon is String) {
        iconWidget = SvgPicture.asset(
          suffixIcon,
          width: 18,
          colorFilter: ColorFilter.mode(
            filled ? Colors.white : AppColors.main700,
            BlendMode.srcIn,
          ),
        );
      }
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          minHeight: buttonHeight,
        ),
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
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: filled ? AppColors.main600 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: filled ? Colors.transparent : AppColors.main600,
              width: 1.4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(4, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0,
                child: iconWidget ?? const SizedBox(width: 20, height: 20),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: filled ? Colors.white : AppColors.main700,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              iconWidget ?? const SizedBox(width: 20, height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
