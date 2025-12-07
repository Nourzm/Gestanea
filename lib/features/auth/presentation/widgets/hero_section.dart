import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final heroHeight = MediaQuery.of(context).size.height * 0.35;

    return Container(
      width: screenWidth,
      height: heroHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboarding5.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: [
          // Semi-transparent overlay with gradient that matches the image's purple hue
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(176, 119, 229, 0.3),
                  Color.fromRGBO(156, 119, 190, 0.5),
                  AppColors.bg_1,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30,
                bottom: 40,
              ), // Adjusted padding to match image position
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
