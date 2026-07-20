import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CategoryCard extends StatelessWidget {
  // Required path to the SVG asset, e.g., 'assets/icons/pill.svg'
  final String svgAssetPath;
  // Required name to display below the icon
  final String categoryName;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.svgAssetPath,
    required this.categoryName,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
      mainAxisSize: MainAxisSize.min, // Keep column size minimal
      children: [
        // 1. Icon Container with Neumorphic Styling
        Container(
          width: 70, // Slightly larger for better visual
          height: 70,
          padding: const EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: isSelected
                ? const Color(0xFFE8D4FF)
                : const Color(0xFFFAECFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isSelected
                  ? const BorderSide(color: Color(0xFF8A2BE2), width: 2)
                  : BorderSide.none,
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? const Color(0xFF8A2BE2) : Colors.black54,
          ),
        ),
      ],
      ),
    );
  }
}