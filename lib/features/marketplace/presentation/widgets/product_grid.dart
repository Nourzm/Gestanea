import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'product_card.dart';

class ProductModel {
  final String imageAsset;
  final String title;
  final double price;
  final double? oldPrice;
  final String? discount;
  final Color discountBgColor;

  const ProductModel({
    required this.imageAsset,
    required this.title,
    required this.price,
    this.oldPrice,
    this.discount,
    this.discountBgColor = AppColors.main500,
  });
}

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Function(int)? onProductTapped;

  const ProductGrid({super.key, required this.products, this.onProductTapped});

  @override
  Widget build(BuildContext context) {
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
          return ProductCard(
            imageAsset: product.imageAsset,
            title: product.title,
            price: product.price,
            oldPrice: product.oldPrice,
            discount: product.discount,
            discountBgColor: product.discountBgColor,
          );
        },
      ),
    );
  }
}
