import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class NeumorphicSection extends StatelessWidget {
  final Widget child;

  const NeumorphicSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.homeCards,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(5, 3),
          ),
          const BoxShadow(
            color: Color(0xFFffffff),
            blurRadius: 10,
            offset: Offset(-5, -5),
          ),
        ],
      ),
      child: child,
    );
  }
}
