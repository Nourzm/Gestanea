import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/category_card.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tipFinal_card.dart';
import 'package:gestanea/core/widgets/search_bar.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/features/education/logic/education_cubit.dart';
import 'package:gestanea/features/education/logic/education_state.dart';

class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.main500,
            size: 24, // change size
          ),
          onPressed: () {
            Navigator.pop(context); // back action
          },
        ),
        title: Text(
          'Tips',
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.bg_1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              searchBar(
                controller: searchController,
                hintText: l10n.searchHint,
                onSearchTapped: () {
                  // Handle search tap
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryCard(
                    categoryName: 'Wellness',
                    svgAssetPath: "assets/icons/health.svg",
                  ),
                  CategoryCard(
                    categoryName: 'Wellness',
                    svgAssetPath: "assets/icons/health.svg",
                  ),
                  CategoryCard(
                    categoryName: 'Wellness',
                    svgAssetPath: "assets/icons/health.svg",
                  ),
                  CategoryCard(
                    categoryName: 'Wellness',
                    svgAssetPath: "assets/icons/health.svg",
                  ),
                ],
              ),
              SizedBox(height: 10),

              ProductCardToggle(initialExpanded: true),
              ProductCardToggle(),
              ProductCardToggle(),

              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFFAECFF),
              //     borderRadius: BorderRadius.circular(16),
              //     boxShadow: AppColors.shadow1,
              //   ),
              //   child: Column(
              //     children: [
              //       Container(
              //         width: 321,
              //         height: 100,
              //         clipBehavior: Clip.antiAlias,
              //         decoration: ShapeDecoration(
              //           color: const Color(0xFFE8E9EA),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: 321,
              //         height: 23,
              //         child: Stack(
              //           children: [
              //             Container(
              //               width: 185,
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 spacing: 4,
              //                 children: [
              //                   Container(
              //                     width: double.infinity,
              //                     height: 44,
              //                     child: Column(
              //                       mainAxisSize: MainAxisSize.min,
              //                       mainAxisAlignment: MainAxisAlignment.start,
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         SizedBox(
              //                           width: 185,
              //                           height: 44,
              //                           child: Text(
              //                             'Pregnancy Pillow',
              //                             style: TextStyle(
              //                               color: const Color(0xFF1C2229),
              //                               fontSize: 16,
              //                               fontFamily: 'Lato',
              //                               fontWeight: FontWeight.w700,
              //                               height: 1.38,
              //                               letterSpacing: -0.18,
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Container(width: double.infinity, height: 17),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         width: 268,
              //         child: Text(
              //           'Essential nutrients and meal planning for \na healthy pregnancy',
              //           style: TextStyle(
              //             color: const Color(0xFF4C4C4C),
              //             fontSize: 12,
              //             fontFamily: 'Lato',
              //             fontWeight: FontWeight.w500,
              //             height: 1.67,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         transform: Matrix4.identity()
              //           ..translate(0.0, 0.0)
              //           ..rotateZ(-3.14),
              //         width: 27,
              //         height: 27,
              //         clipBehavior: Clip.antiAlias,
              //         decoration: BoxDecoration(),
              //         child: Stack(),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
