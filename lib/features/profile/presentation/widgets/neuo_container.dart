import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isDepressed;
  final Color color;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(16.0),
    this.isDepressed = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.shadow1,
      ),
      child: child,
    );
  }
}
