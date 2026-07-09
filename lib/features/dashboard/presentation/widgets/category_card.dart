import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryCard extends StatelessWidget {
  // Required path to the SVG asset, e.g., 'assets/icons/pill.svg'
  final String svgAssetPath;
  // Required name to display below the icon
  final String categoryName;

  const CategoryCard({
    super.key,
    required this.svgAssetPath,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Keep column size minimal
      children: [
        // 1. Icon Container with Neumorphic Styling
        Container(
          width: 70, // Slightly larger for better visual
          height: 70,
          padding: const EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFFAECFF), // Light purple background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Corrected and combined BoxShadow list for the Neumorphic effect
            shadows: const [
              // Darker shadow (bottom-right)
              BoxShadow(
                color: Color(0x66AEAEC0), // Semi-transparent grey
                blurRadius: 5,
                offset: Offset(4, 4),
                spreadRadius: 0,
              ),
              // Lighter shadow (top-left)
              BoxShadow(
                color: Color(0xFFFFFFFF), // White/Light
                blurRadius: 5,
                offset: Offset(-2, -2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: SvgPicture.asset(
            // The widget that displays the SVG icon
            svgAssetPath,
            width: 30,
            height: 30,
            colorFilter: const ColorFilter.mode(
              Color(0xFF8A2BE2), // Icon color (Purple)
              BlendMode.srcIn,
            ),
            // Add a placeholder/error builder for robustness
            placeholderBuilder: (BuildContext context) => const Center(
              child: Icon(Icons.category, color: Color(0xFF8A2BE2)),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 2. Category Name Text
        Text(
          categoryName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
