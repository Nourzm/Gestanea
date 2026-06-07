import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class searchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchTapped;
  final String hintText;

  const searchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSearchTapped,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.white, width: 0.5),
        boxShadow: [
          const BoxShadow(
            color: AppColors.white,
            offset: Offset(-2.5, -2.5),
            blurRadius: 5,
            spreadRadius: -5,
            inset: true,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.25),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
            inset: true,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: const TextStyle(
                  color: AppColors.main500,
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: const Color(0x99B077E4),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: onSearchTapped,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.search,
                  color: AppColors.main500,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
