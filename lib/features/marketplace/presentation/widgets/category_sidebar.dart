import 'package:flutter/material.dart';
import 'category_item.dart';

class CategoryModel {
  final String label;
  final String imageAsset;

  const CategoryModel({required this.label, required this.imageAsset});
}

class CategorySidebar extends StatelessWidget {
  final List<CategoryModel> categories;
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
            label: category.label,
            imageAsset: category.imageAsset,

            onTap: () => onCategoryTapped?.call(index),
          );
        },
      ),
    );
  }
}
