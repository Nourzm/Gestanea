import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class NotificationIcon extends StatelessWidget {
  final Widget icon; // SVG or normal icon
  final Color backgroundColor;
  final Color borderColor;
  final double size;
  final double borderRadius;
  final double elevation;

  const NotificationIcon({
    super.key,
    required this.icon,
    this.backgroundColor = AppColors.homeCards,
    this.borderColor = AppColors.main400,
    this.size = 45,
    this.borderRadius = 11.0,
    this.elevation = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.shadow1,
      ),
      child: Center(child: SvgPicture.asset("assets/icons/notifications.svg")),
    );
  }
}
