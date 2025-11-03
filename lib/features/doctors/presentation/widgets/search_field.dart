import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const SearchField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg_1,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.main400.withOpacity(0.3),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          style: AppTextStyles.body1.copyWith(
            fontFamily: 'Lato',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body1.copyWith(
              fontFamily: 'Lato',
              fontSize: 13,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(icon, color: AppColors.main500, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
