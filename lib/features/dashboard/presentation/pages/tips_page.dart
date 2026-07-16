import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/category_card.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tipFinal_card.dart';
import 'package:gestanea/core/widgets/search_bar.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, String>> tipCategories = [
      {'name': 'All', 'asset': 'assets/icons/global.svg'},
      {'name': 'Nutrition', 'asset': 'assets/icons/food.svg'},
      {'name': 'Exercise', 'asset': 'assets/icons/sports.svg'},
      {'name': 'Sleep', 'asset': 'assets/icons/sleep.svg'},
      {'name': 'Baby Care', 'asset': 'assets/icons/baby.svg'},
      {'name': 'Wellness', 'asset': 'assets/icons/health.svg'},
    ];
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
      body: SingleChildScrollView(
        child: Container(
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tipCategories.map((category) {
                      // Wrap the CategoryCard and add a SizedBox for spacing
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ), // Space between cards
                        child: CategoryCard(
                          categoryName: category['name']!,
                          svgAssetPath: category['asset']!,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),

                ProductCardToggle(
                  initialExpanded: true,
                  title: "Healthy Nutrition",
                  description:
                      "Include a variety of fruits, vegetables, lean proteins, and whole grains to support both mother and baby.",
                  readTime: "4 min read",
                  imagePath: "assets/images/onboarding5.png",
                ),
                ProductCardToggle(
                  title: "Safe Exercise",
                  description:
                      "Light activities like walking, swimming, or prenatal yoga can improve circulation and reduce stress.",
                  readTime: "3 min read",
                  imagePath: "assets/images/onboarding5.png",
                ),
                ProductCardToggle(
                  title: "Adequate Sleep",
                  description:
                      "Aim for 7–9 hours per night. Use pillows to support your back and abdomen for comfort.",
                  readTime: "2 min read",
                  imagePath: "assets/images/onboarding5.png",
                ),
                ProductCardToggle(
                  title: "Hydration Matters",
                  description:
                      "Drink at least 8–10 glasses of water daily to help maintain amniotic fluid levels and prevent fatigue.",
                  readTime: "2 min read",
                  imagePath: "assets/images/onboarding5.png",
                ),

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
      ),
    );
  }
}
