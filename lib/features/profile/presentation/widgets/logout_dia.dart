import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/profile/presentation/pages/about_app.dart';
// Import your NeumorphicContainer class here if it's in a separate file

// Assuming NeumorphicContainer is available as defined previously

// Helper widget for the dialog buttons (Neumorphic style)
Widget buildDialogButton({
  required String text,
  required Color color,
  required VoidCallback onPressed,
  required bool isPrimary,
}) {


  return GestureDetector(
    onTap: onPressed,
    child: NeumorphicContainer(
      // The button itself uses the NeumorphicContainer
      borderRadius: 10.0,
      padding: EdgeInsets.zero,
      baseColor: isPrimary ? color : AppColors.background,
      shadows: AppColors.shadow1,
      child: Container(
        alignment: Alignment.center,
        height: 48,
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? AppColors.textLight : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );
}

// Custom Neumorphic Dialog Structure
Widget NeumorphicAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Widget actionsRow,
}) {
  return Dialog(
    // Remove default dialog padding/shape
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: NeumorphicContainer(
      // The main dialog body
      borderRadius: 20.0,
      shadows: [],
      padding: const EdgeInsets.all(25.0),
      baseColor: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              color: AppColors.main600,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),

          // Content
          Text(
            content,
            style: TextStyle(
              color: AppColors.main700.withOpacity(0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),

          // Actions
          actionsRow,
        ],
      ),
    ),
  );
}