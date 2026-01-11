import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/services/onboarding_service.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// User Status Selection Page (Phase 2)
/// Shows "I'm Pregnant" and "I have a baby" selection cards
class OnboardingUserStatusPage extends StatefulWidget {
  const OnboardingUserStatusPage({super.key});

  @override
  State<OnboardingUserStatusPage> createState() =>
      _OnboardingUserStatusPageState();
}

class _OnboardingUserStatusPageState extends State<OnboardingUserStatusPage> {
  bool _isLoading = false;

  Future<void> _selectStatus(String userStatus) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authenticated user'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final onboardingService = OnboardingService();
      await onboardingService.saveUserStatus(
        userId: user.id,
        userStatus: userStatus,
      );

      if (!mounted) return;

      // Navigate based on selection
      if (userStatus == 'pregnant') {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingPregnancy);
      } else if (userStatus == 'postpartum' || userStatus == 'baby') {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingBaby);
      } else {
        // 'none' - skip to health
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingHealth);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const HeroSection(
                    title: "What describes you best?",
                    subtitle: "We'll customize your experience",
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SelectionCard(
                          color: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffF5D4FB), Color(0xffFBECFF)],
                          ),
                          title: "I'm Pregnant",
                          subtitle:
                              'Track your pregnancy journey, get weekly insights, and prepare for your baby',
                          icon: "assets/icons/babyy.svg",
                          onTap: _isLoading ? null : () => _selectStatus('pregnant'),
                        ),
                        const SizedBox(height: 20),
                        _SelectionCard(
                          color: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffFBECFF), Color(0xffFDF5FF)],
                          ),
                          title: "I have a baby",
                          subtitle:
                              'Postpartum care, baby development tracking, and parenting support',
                          icon: "assets/icons/health.svg",
                          onTap: _isLoading ? null : () => _selectStatus('postpartum'),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            "Don't worry, you can change this anytime in settings",
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient color;
  final String icon;
  final VoidCallback? onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
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
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(-5, -5),
            ),
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(5, 5),
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
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  const Positioned(
                    right: 0,
                    top: 10,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.main600,
                      size: 20,
                    ),
                  ),
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
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            icon,
                            width: 40,
                            height: 40,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
