import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/product_grid.dart';
import '../widgets/neumorphic_section.dart';
import '../widgets/review_card.dart';
import '../widgets/quantity_button.dart';
import '../bloc/product_quantity_bloc.dart';

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

  final List<Color> _availableColors = [
    const Color(0xFFD4A5E8),
    const Color(0xFFFF91C7),
    const Color(0xFF9E9E9E),
  ];

  final List<String> _availableSizes = ['Standard', 'Large', 'XL'];

  final List<String> _productImages = [
    'assets/images/product.png',
    'assets/images/product.png',
    'assets/images/product.png',
  ];

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
                            _productImages[_currentImageIndex],
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
                          _productImages.length,
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
                                  _productImages[index],
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
                      '30% OFF',
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
                        'Premium Pregnancy Pillow',
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
                            '4.8 (234 reviews)',
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
                        '\$22.40',
                        style: AppTextStyles.headline1.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.main500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$32.00',
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
                            _availableColors.length,
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
                                  color: _availableColors[index],
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
                            _availableSizes.length,
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
                                  _availableSizes[index],
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
                      // Handle buy now
                    },
                    child: NeumorphicButton(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      onPressed: () {
                        // Handle buy now
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
                          'Experience ultimate comfort during pregnancy with our Premium Pregnancy Pillow. Designed with premium memory foam and a full-body C-shape, this pillow provides optimal support for your back, hips, knees, neck, and belly.',
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
                        _buildSpecRow('Material', 'Premium Memory Foam'),
                        const SizedBox(height: 12),
                        _buildSpecRow('Cover', '100% Cotton'),
                        const SizedBox(height: 12),
                        _buildSpecRow('Dimensions', '54" x 31" x 7"'),
                        const SizedBox(height: 12),
                        _buildSpecRow('Weight', '4.5 lbs'),
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
                    children: [
                      ReviewCard(
                        name: 'Sarah Mitchell',
                        rating: 5,
                        review:
                            'This pillow has been a game-changer!  I\'m sleeping so much better now. The quality is excellent and it\'s super comfortable.',
                      ),
                      const SizedBox(height: 12),
                    ],
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
