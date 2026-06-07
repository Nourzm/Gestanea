import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/product_details_bloc.dart';
import '../../logic/order_bloc.dart';
import '../widgets/neumorphic_section.dart';
import '../widgets/review_card.dart';
import '../widgets/quantity_button.dart';
import 'order.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.main500),
              );
            }

            if (state is ProductDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.body1.copyWith(color: Colors.red),
                ),
              );
            }

            if (state is! ProductDetailsLoaded) {
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
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
                              state.product.imageUrls[state.currentImageIndex],
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
                            state.product.imageUrls.length,
                            (index) => GestureDetector(
                              onTap: () {
                                context.read<ProductDetailsBloc>().add(
                                  ChangeImage(index),
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: state.currentImageIndex == index
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
                                    state.product.imageUrls[index],
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
                  if (state.product.discountPercentage != null)
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
                          '-${state.product.discountPercentage}%',
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
                          state.product.productName,
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
                              '${state.product.rating} (${AppLocalizations.of(context)!.reviewsCount(state.product.reviewsCount)})',
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
                          '${state.product.price.toStringAsFixed(0)} DA',
                          style: AppTextStyles.headline1.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.main500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (state.product.originalPrice != null)
                          Text(
                            '${state.product.originalPrice!.toStringAsFixed(0)} DA',
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
                  if (state.colorVariants.isNotEmpty &&
                      state.product.categoryId != 'cat_3')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NeumorphicSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selectColor,
                              style: AppTextStyles.headline2.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(
                                state.colorVariants.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    context.read<ProductDetailsBloc>().add(
                                      SelectColor(index),
                                    );
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          state.colorVariants[index].colorHex !=
                                              null
                                          ? Color(
                                              int.parse(
                                                state
                                                    .colorVariants[index]
                                                    .colorHex!
                                                    .replaceFirst('#', '0xFF'),
                                              ),
                                            )
                                          : AppColors.main300,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: state.selectedColorIndex == index
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
                  if (state.sizeVariants.isNotEmpty &&
                      state.product.categoryId != 'cat_3')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NeumorphicSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selectSize,
                              style: AppTextStyles.headline2.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(
                                state.sizeVariants.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    context.read<ProductDetailsBloc>().add(
                                      SelectSize(index),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 10,
                                    ),
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: state.selectedSizeIndex == index
                                          ? AppColors.main500
                                          : AppColors.bg_1,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF000000,
                                          ).withValues(alpha: 0.15),
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
                                      state.sizeVariants[index].value,
                                      style: AppTextStyles.body1.copyWith(
                                        color: state.selectedSizeIndex == index
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
                        Row(
                          children: [
                            QuantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                context.read<ProductDetailsBloc>().add(
                                  const DecrementQuantity(),
                                );
                              },
                              color: AppColors.main500,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${state.quantity}',
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
                                context.read<ProductDetailsBloc>().add(
                                  const IncrementQuantity(),
                                );
                              },
                              color: AppColors.main500,
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Add to Cart button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.read<ProductDetailsBloc>().add(
                                const AddToCart(),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.main500,
                                    AppColors.main600,
                                  ],
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
                                    AppLocalizations.of(context)!.addToCart,
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
                    child: NeumorphicButton(
                      onPressed: () {
                        final selectedColorVariant =
                            state.colorVariants.isNotEmpty
                            ? state.colorVariants[state.selectedColorIndex]
                            : null;
                        final selectedColor = selectedColorVariant?.value ?? '';
                        final selectedColorHex = selectedColorVariant?.colorHex;

                        final selectedSize = state.sizeVariants.isNotEmpty
                            ? state.sizeVariants[state.selectedSizeIndex].value
                            : '';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => OrderBloc()
                                ..add(
                                  InitializeOrder(
                                    productName: product.productName,
                                    productImage: product.imageUrls.isNotEmpty
                                        ? product.imageUrls[0]
                                        : '',
                                    selectedColor: selectedColor,
                                    selectedColorHex: selectedColorHex,
                                    selectedSize: selectedSize,
                                    quantity: state.quantity,
                                    productPrice: product.price,
                                  ),
                                ),
                              child: const CompleteOrderScreen(),
                            ),
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.buyNow,
                      prefixIcon: Icons.shopping_bag_outlined,
                      color: AppColors.main600,
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
                            AppLocalizations.of(context)!.description,
                            style: AppTextStyles.headline2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.product.description ??
                                AppLocalizations.of(
                                  context,
                                )!.noDescriptionAvailable,
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
                  if (state.specs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NeumorphicSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.specifications,
                              style: AppTextStyles.headline2.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...state.specs.map(
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
                  if (state.reviews.isNotEmpty)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.customerReviews,
                                style: AppTextStyles.headline2.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.seeAll,
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
                            children: state.reviews
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
                      ],
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
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
