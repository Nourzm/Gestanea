import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/core/constants/app_text_styles.dart';

enum ButtonType { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = isFullWidth ? double.infinity : width;
    final effectiveHeight = height ?? 50.0;

    if (isLoading) {
      return SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: _buildButton(
          context,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    Widget buttonChild = Text(
      text,
      style: _getTextStyle(),
    );

    if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: _getTextStyle()),
        ],
      );
    }

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: _buildButton(context, child: buttonChild),
    );
  }

  Widget _buildButton(BuildContext context, {required Widget child}) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.main600,
            foregroundColor: textColor ?? AppColors.white,
            disabledBackgroundColor: AppColors.purpleGrey,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 2,
          ),
          child: child,
        );

      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.pink500,
            foregroundColor: textColor ?? AppColors.white,
            disabledBackgroundColor: AppColors.purpleGrey,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 2,
          ),
          child: child,
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.main600,
            side: BorderSide(
              color: backgroundColor ?? AppColors.main600,
              width: 1.5,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: child,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? AppColors.main600,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: child,
        );
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = type == ButtonType.text
        ? AppTextStyles.buttonTextSmall
        : AppTextStyles.buttonText;

    if (textColor != null) {
      return baseStyle.copyWith(color: textColor);
    }

    return baseStyle;
  }
}
