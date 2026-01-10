import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.main500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
            BoxShadow(
              color: AppColors.white,
              blurRadius: 4,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}
