import 'package:flutter/material.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import 'category_item.dart';

class CategorySidebar extends StatelessWidget {
  final List<ProductCategoryModel> categories;
  final Function(int)? onCategoryTapped;

  const CategorySidebar({
    super.key,
    required this.categories,
    this.onCategoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryItem(
            label: category.name ?? '',
            imageAsset: category.imageUrl ?? '',
            onTap: () => onCategoryTapped?.call(index),
          );
        },
      ),
    );
  }
}
