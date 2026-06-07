import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeroSection(),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Main Description Text
                  const Text(
                    'Everything you need for pregnancy, baby care, and beyond — all in one place',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Feature Cards
                  const _FeatureCard(
                    icon: Icons.access_time_filled,
                    title: 'Track Your Pregnancy',
                    subtitle: 'Week-by-week insights',
                    iconColor: AppColors.main600,
                  ),
                  const SizedBox(height: 16),
                  const _FeatureCard(
                    icon: Icons.calendar_today,
                    title: 'Health & Appointments',
                    subtitle: 'Never miss a checkup',
                    iconColor: AppColors.main600,
                  ),
                  const SizedBox(height: 16),
                  const _FeatureCard(
                    icon: Icons.people,
                    title: 'Community Support',
                    subtitle: 'Connect with others',
                    iconColor: AppColors.main600,
                  ),
                  const SizedBox(height: 40),

                  const _PrimaryButton(),
                  const SizedBox(height: 12),

                  const Text(
                    'Takes less than a minute',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final heroHeight = MediaQuery.of(context).size.height * 0.4;

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
              padding: const EdgeInsets.only(left: 24, bottom: 24),
              child: Text(
                'Your Journey,\nOur Support',
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.main300,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff000000).withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  spreadRadius: 0,
                ),
              ],
              gradient: AppColors.onboarding,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: AppColors.white, size: 24),
          ),
          const SizedBox(width: 16),
          // Text Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The main CTA button with a gradient.
class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton();

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  Future<void> _completeOnboarding() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('onboardingCompleted', true);
    // if (mounted) {
    Navigator.pushReplacementNamed(context, AppRoutes.signup);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: AppColors.onboarding,
        boxShadow: const [
          BoxShadow(
            color: Color(0x00000040),
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _completeOnboarding,
          borderRadius: BorderRadius.circular(30),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Let's Get Started",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: AppColors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
