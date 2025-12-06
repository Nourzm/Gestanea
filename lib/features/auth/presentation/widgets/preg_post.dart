import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';

class CustomColors {
  // A primary purple for gradients/icons
  static const Color primaryPurple = Color(0xFFB077E5);
  // A secondary, lighter purple for the background and light parts of the gradient
  static const Color secondaryPurple = Color(0xFFE5D9F3);
  // The very light, near-white background color
  static const Color backgroundWhite = Color(0xFFF7F7F7);
}

class PregnancySelectionScreen extends StatelessWidget {
  const PregnancySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        const Text(
          'What best describes you',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 32),

        _SelectionCard(
          color: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffF5D4FB), Color(0xffFBECFF)],
          ),
          title: "I'm Pregnant",
          subtitle:
              'Track your pregnancy journey, get weekly insights, and prepare for your baby',
          icon: "assets/icons/babyy.svg",
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          },
        ),
        const SizedBox(height: 20),

        _SelectionCard(
          color: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFBECFF), Color(0xffFDF5FF)],
          ),
          title: "I have a baby",
          subtitle:
              'Postpartum care, baby development tracking, and parenting support',
          icon: "assets/icons/health.svg",
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          },
        ),

        const SizedBox(height: 20),

        // Bottom note
        const Center(
          child: Text(
            "Don't worry, you can change this anytime in settings",
            style: TextStyle(color: Colors.black54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient color;
  final String icon;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(-5, -5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(5, 5),
            ),
          ],
          gradient: color,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.main500.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  // --- Arrow Icon on the right ---
                  const Positioned(
                    right: 0,
                    top: 10,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.main600,
                      size: 20,
                    ),
                  ),

                  // --- Content Layout (Icon and Text) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: AppColors.onboarding,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            icon,
                            width: 40,
                            height: 40,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.main600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
