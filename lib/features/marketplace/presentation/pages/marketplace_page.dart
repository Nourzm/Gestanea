import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/core/constants/app_text_styles.dart';
import '../widgets/header.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_sidebar.dart';
import '../widgets/product_grid.dart';

void main() {
  runApp(Market());
}

class Market extends StatelessWidget {
  const Market({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: AppColors.bg_1),
      home: const MarketplacePage(),
    );
  }
}

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _searchController = TextEditingController();

  // Sample data
  final List<CategoryModel> _categories = [
    CategoryModel(
      label: 'Maternity\nWear',
      imageAsset: 'assets/images/Maternity_wear.webp',
    ),
    CategoryModel(label: 'Pain Relief', imageAsset: 'assets/images/pain.webp'),
    CategoryModel(
      label: 'Skin Care',
      imageAsset: 'assets/images/skin_care.webp',
    ),
  ];

  final List<ProductModel> _products = [
    ProductModel(
      imageAsset: 'assets/images/product.png',
      title: 'Pregnancy Pillow',
      price: 22.40,

      discountBgColor: AppColors.main500,
    ),
    ProductModel(
      imageAsset: 'assets/images/Back_pain_belt.webp',
      title: 'Back Support Belt',
      price: 22.40,
      oldPrice: 32.00,
      discount: '30%',
      discountBgColor: AppColors.main500,
    ),
    ProductModel(
      imageAsset: 'assets/images/Back_pain_belt.webp',
      title: 'Back Support Belt',
      price: 22.40,
      oldPrice: 32.00,
      discount: '30%',
      discountBgColor: AppColors.main500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            MarketplaceHeader(title: 'Market'),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MarketplaceSearchBar(
                controller: _searchController,
                onSearchTapped: () {
                  // Handle search tap
                },
              ),
            ),

            const SizedBox(height: 20),

            // Promotional Banner - Inline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.pink500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.27),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 10,
                      offset: Offset(4, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.white,
                      blurRadius: 5,
                      offset: Offset(-4, -4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 21,
                      top: 17,
                      child: Text(
                        'Don\'t Miss out',
                        style: AppTextStyles.headline2.copyWith(
                          color: AppColors.white,
                          fontSize: 22,
                          fontFamily: 'Lato',
                          letterSpacing: -0.22,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 21,
                      top: 52,
                      child: Text(
                        'Discount up to 50%',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.white.withValues(alpha: 0.70),
                          fontFamily: 'Lato',
                          letterSpacing: -0.14,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 90,
                      child: Container(
                        transform: Matrix4.identity()
                          ..translate(0.0, 0.0)
                          ..rotateZ(0.18),
                        width: 43.42,
                        height: 49.75,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/image109.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 5,
                      bottom: 5,
                      child: Container(
                        width: 141.52,
                        height: 149.46,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/image84.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 21,
                      top: 86,
                      child: GestureDetector(
                        child: Container(
                          width: 110,
                          height: 22,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.39),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(1, 1),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Color(0xFFFFB7D6),
                                blurRadius: 5,
                                offset: Offset(-2, -2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Upgrade now',
                              style: AppTextStyles.smallLabel.copyWith(
                                color: const Color(0xFFFF6FAC),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
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

            // Main content area with categories and products
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category sidebar
                  CategorySidebar(categories: _categories),
                  // Product grid
                  Expanded(child: ProductGrid(products: _products)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
