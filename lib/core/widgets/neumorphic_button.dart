import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  final dynamic prefixIcon; // IconData or SVG path
  final dynamic suffixIcon; // IconData or SVG path

  final Color? color;
  final double? minHeight;
  final double? maxWidth;

  const NeumorphicButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.minHeight,
    this.maxWidth,
  });

  Widget? _buildIcon(dynamic icon, Color color) {
    if (icon == null) return null;

    if (icon is IconData) {
      return Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 10),
        ],
      );
    } else if (icon is String) {
      return SvgPicture.asset(
        icon,
        width: 18,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonHeight = minHeight ?? size.height * 0.08;

    final verticalPadding = size.height * 0.012;
    final horizontalPadding = size.width * 0.04;

    final prefix = _buildIcon(prefixIcon, Colors.white);
    final suffix = _buildIcon(suffixIcon, Colors.white);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          minHeight: buttonHeight,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: color == null
              ? AppColors.onboarding
              : LinearGradient(colors: [?color, ?color]),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefix ?? const SizedBox(width: 20, height: 20),

                  Text(
                    text,
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              suffix ?? const SizedBox(width: 20, height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
