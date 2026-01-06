import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/core/widgets/search_bar.dart';
import '../../logic/marketplace_bloc.dart';
import '../../logic/product_details_bloc.dart';
import '../widgets/category_sidebar.dart';
import '../widgets/product_grid.dart';
import 'product_details.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(const LoadMarketplaceData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get current theme colors
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Header(title: l10n.market),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: searchBar(
                controller: _searchController,
                hintText: l10n.searchHint,
                onSearchTapped: () {
                  context.read<MarketplaceBloc>().add(
                    SearchProducts(_searchController.text),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Promotional Banner - Now uses dynamic theme colors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  // Use theme primary color for banner background
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
                        l10n.dontMissOut,
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
                        l10n.discountUpTo,
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
                              l10n.upgradeNow,
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
              child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
                builder: (context, state) {
                  if (state is MarketplaceLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        // Use theme primary color
                        color: themeData.primaryColor,
                      ),
                    );
                  }

                  if (state is MarketplaceError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.body1.copyWith(color: Colors.red),
                      ),
                    );
                  }

                  if (state is MarketplaceLoaded) {
                    // Find the index of the selected category
                    final selectedIndex = state.selectedCategoryId != null
                        ? state.categories.indexWhere(
                            (cat) => cat.id == state.selectedCategoryId,
                          )
                        : null;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category sidebar
                        CategorySidebar(
                          categories: state.categories,
                          selectedIndex: selectedIndex != -1
                              ? selectedIndex
                              : null,
                          onCategoryTapped: (index) {
                            final categoryId = state.categories[index].id;
                            context.read<MarketplaceBloc>().add(
                              FilterByCategory(categoryId),
                            );
                          },
                        ),
                        // Product grid
                        Expanded(
                          child: ProductGrid(
                            products: state.filteredProducts,
                            onProductTapped: (index) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) =>
                                        ProductDetailsBloc()..add(
                                          LoadProductDetails(
                                            state.filteredProducts[index],
                                          ),
                                        ),
                                    child: ProductDetailPage(
                                      product: state.filteredProducts[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
