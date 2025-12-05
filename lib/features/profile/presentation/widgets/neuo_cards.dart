import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

Widget buildNeumorphicTile({
  required String primaryText,
  required String secondaryText,
  bool isSelected = false,
  required VoidCallback onTap, // ADDED: Required for tap functionality
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
    child: GestureDetector(
      // WRAPPED with GestureDetector
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.main300,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust for the purple theme
                  ),
                ),
                Text(
                  secondaryText,
                  style: TextStyle(fontSize: 14, color: AppColors.main500),
                ),
              ],
            ),
            // Placeholder for the checkmark
            if (isSelected) Icon(Icons.check_circle, color: AppColors.main600),
          ],
        ),
      ),
    ),
  );
}
