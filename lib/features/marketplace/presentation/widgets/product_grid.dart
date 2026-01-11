import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Function(int)? onProductTapped;

  const ProductGrid({super.key, required this.products, this.onProductTapped});

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final locale = Localizations.localeOf(context);

    return Container(
      decoration: const ShapeDecoration(
        color: Color(0xFFFAECFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-4, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final discount = product.discountPercentage != null
              ? '-${product.discountPercentage}%'
              : null;
          return ProductCard(
            imageAsset: product.imageUrls.isNotEmpty
                ? product.imageUrls[0]
                : '',
            title: product.getTranslatedName(locale.languageCode),
            price: product.price,
            oldPrice: product.originalPrice,
            discount: discount,
            discountBgColor: themeData.primaryColor,
            onTap: () => onProductTapped?.call(index),
          );
        },
      ),
    );
  }
}
