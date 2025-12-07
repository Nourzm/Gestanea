import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class CategoryItem extends StatefulWidget {
  final String label;
  final String imageAsset;
  final Color textColor;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.label,
    required this.imageAsset,
    this.textColor = AppColors.textDark,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 6,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: 6,
                  offset: Offset(-2, -2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                widget.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppColors.main300,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.smallLabel.copyWith(
              color: widget.isSelected ? AppColors.main500 : widget.textColor,
              fontSize: 9,
              fontFamily: 'Lato',
              fontWeight: widget.isSelected ? FontWeight.w900 : FontWeight.w500,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
