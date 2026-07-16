import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class ProductCard extends StatefulWidget {
  final String imageAsset;
  final String title;
  final double price;
  final double? oldPrice;
  final String? discount;
  final Color discountBgColor;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.price,
    this.oldPrice,
    this.discount,
    this.discountBgColor = AppColors.main500,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<BoxShadow> get _cardShadow => [
    const BoxShadow(
      offset: Offset(-1, -1),
      color: AppColors.white,
      blurRadius: 3,
    ),
    BoxShadow(
      offset: const Offset(2, 2),
      color: const Color(0xFFAEAEC0).withOpacity(0.4),
      blurRadius: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get current theme colors
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // Use theme card color
          color: themeData.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with discount badge
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.imageAsset.startsWith('http')
                          ? Image.network(
                              widget.imageAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            )
                          : Image.asset(
                              widget.imageAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                    ),
                  ),
                  // Only show discount badge if discount is not null
                  if (widget.discount != null)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          // Use theme primary color for discount badge
                          color: themeData.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.discount!,
                          style: AppTextStyles.smallLabel.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Product title
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF1C2229),
                fontSize: 12,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
                height: 1.38,
                letterSpacing: -0.18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Price and button section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price section
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.price.toStringAsFixed(0)} DA",
                        style: const TextStyle(
                          color: Color(0xFF1C2229),
                          fontSize: 11,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      // Only show old price if it's not null
                      if (widget.oldPrice != null) ...[
                        const SizedBox(width: 3),
                        Text(
                          "${widget.oldPrice!.toStringAsFixed(0)} DA",
                          style: const TextStyle(
                            color: Color(0xFF9C77BE),
                            fontSize: 9,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
