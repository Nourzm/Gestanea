import 'package:flutter/material.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import 'category_item.dart';

class CategorySidebar extends StatelessWidget {
  final List<ProductCategoryModel> categories;
  final Function(int)? onCategoryTapped;
  final int? selectedIndex;

  const CategorySidebar({
    super.key,
    required this.categories,
    this.onCategoryTapped,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Get current locale
    final locale = Localizations.localeOf(context);

    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedIndex == index;
          return CategoryItem(
            label: category.getTranslatedName(locale.languageCode),
            imageAsset: category.imageUrl ?? '',
            isSelected: isSelected,
            onTap: () => onCategoryTapped?.call(index),
          );
        },
      ),
    );
  }
}
