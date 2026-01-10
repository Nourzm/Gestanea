import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_variant_model.dart';
import 'package:gestanea/core/database/models/product_spec_model.dart';
import 'package:gestanea/core/database/models/product_review_model.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/marketplace/data/datasources/mock_marketplace_data.dart';
import '../widgets/neumorphic_section.dart';
import '../widgets/review_card.dart';
import '../widgets/quantity_button.dart';
import '../../logic/product_quantity_bloc.dart';
import 'order.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;
  int _currentImageIndex = 0;

  late List<ProductVariantModel> _colorVariants;
  late List<ProductVariantModel> _sizeVariants;
  late List<ProductSpecModel> _specs;
  late List<ProductReviewModel> _reviews;

  @override
  void initState() {
    super.initState();
    final allVariants = MockMarketplaceData.getProductVariants(
      widget.product.id,
    );
    _colorVariants = allVariants.where((v) => v.type == 'color').toList();
    _sizeVariants = allVariants.where((v) => v.type == 'size').toList();
    _specs = MockMarketplaceData.getProductSpecs(widget.product.id);
    _reviews = MockMarketplaceData.getProductReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ProductQuantityBloc(),
      child: Scaffold(
        backgroundColor: AppColors.bg_1,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and favorite
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNeumorphicIconButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Main product image with thumbnail gallery
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Main image
                      Container(
                        width: double.infinity,
                        height: screenHeight * 0.35,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 10,
                              offset: Offset(4, 4),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: AppColors.white,
                              blurRadius: 10,
                              offset: Offset(-4, -4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.product.imageUrls[_currentImageIndex],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: AppColors.main300,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Thumbnail gallery
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.imageUrls.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _currentImageIndex == index
                                      ? AppColors.main500
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  widget.product.imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Discount badge
                if (widget.product.discountPercentage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.main500,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.product.discountPercentage}% OFF',
                        style: AppTextStyles.smallLabel.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Product title and rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productName,
                        style: AppTextStyles.headline2.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: Color(0xFFFFB800),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.product.rating} (${widget.product.reviewsCount} reviews)',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.main500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.headline1.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.main500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (widget.product.originalPrice != null)
                        Text(
                          '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.main400,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Select Color
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Color',
                          style: AppTextStyles.headline2.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(
                            _colorVariants.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColorIndex = index;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: _colorVariants[index].colorHex != null
                                      ? Color(
                                          int.parse(
                                            _colorVariants[index].colorHex!
                                                .replaceFirst('#', '0xFF'),
                                          ),
                                        )
                                      : AppColors.main300,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selectedColorIndex == index
                                        ? AppColors.main700
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x26000000),
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Select Size
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Size',
                          style: AppTextStyles.headline2.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(
                            _sizeVariants.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSizeIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: _selectedSizeIndex == index
                                      ? AppColors.main500
                                      : AppColors.bg_1,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF000000,
                                      ).withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                    const BoxShadow(
                                      color: AppColors.white,
                                      blurRadius: 4,
                                      offset: Offset(-2, -2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _sizeVariants[index].value,
                                  style: AppTextStyles.body1.copyWith(
                                    color: _selectedSizeIndex == index
                                        ? AppColors.white
                                        : AppColors.main500,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Quantity and Add to Cart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Quantity selector
                      BlocBuilder<ProductQuantityBloc, int>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              QuantityButton(
                                icon: Icons.remove,
                                onTap: () {
                                  context.read<ProductQuantityBloc>().add(
                                    QuantityEvent.decrement,
                                  );
                                },
                                color: AppColors.main500,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '$state',
                                style: AppTextStyles.headline2.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              QuantityButton(
                                icon: Icons.add,
                                onTap: () {
                                  context.read<ProductQuantityBloc>().add(
                                    QuantityEvent.increment,
                                  );
                                },
                                color: AppColors.main500,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 16),

                      // Add to Cart button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Handle add to cart
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.main500, AppColors.main600],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                                BoxShadow(
                                  color: AppColors.white,
                                  blurRadius: 8,
                                  offset: Offset(-2, -2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Add to Cart',
                                  style: AppTextStyles.headline2.copyWith(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Buy Now button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompleteOrderScreen(),
                        ),
                      );
                    },
                    child: NeumorphicButton(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CompleteOrderScreen(),
                          ),
                        );
                      },
                      text: 'Buy Now',
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.white,
                        size: 20,
                      ),
                      color: AppColors.main600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Description section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: AppTextStyles.headline2.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.product.description ??
                              'No description available',
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Specifications section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Specifications',
                          style: AppTextStyles.headline2.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._specs.map(
                          (spec) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildSpecRow(spec.name, spec.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Customer Reviews section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Reviews',
                        style: AppTextStyles.headline2.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'see all',
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 13,
                          color: AppColors.main500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Review cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _reviews
                        .take(3)
                        .map(
                          (review) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ReviewCard(
                              name: review.reviewerName,
                              rating: review.rating,
                              review: review.reviewText ?? '',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // You May Also Like section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'You May Also Like',
                    style: AppTextStyles.headline2.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Related products placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.main300.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Related products grid',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.main500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.bg_1,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 6,
              offset: Offset(3, 3),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.white,
              blurRadius: 6,
              offset: Offset(-3, -3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.main500, size: 20),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontSize: 13,
            color: AppColors.main500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            fontSize: 13,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
