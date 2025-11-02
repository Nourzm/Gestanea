import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Track',
      'subtitle': 'Your Journey',
      'description':
          'Monitor your pregnancy week by week with personalized tips and insights',
      'image': 'assets/images/onboarding1.png'
    },
    {
      'title': 'Baby Grouth',
      'subtitle': 'Monitor',
      'description': 'Follow your baby\'s ......',
      'image': 'assets/images/onboarding2.png'
    },
    {
      'title': 'Never Miss a',
      'subtitle': 'Moment',
      'description':
          'Set reminders for appointments, vaccines, and important checkups',
      'image': 'assets/images/onboarding3.png'
    },
    {
      'title': 'Mom & Baby',
      'subtitle': 'Marketplace',
      'description': '...............',
      'image': 'assets/images/onboarding3.png'
    },
  ];

  // ignore: unused_element
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  Widget _buildPage(Map<String, String> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(data['image']!, height: 300),
        const SizedBox(height: 30),
        Text(
          data['title']!,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.white),
          textAlign: TextAlign.center,
        ),
        Text(
          data['subtitle']!,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.main600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            data['description']!,
            style: const TextStyle(fontSize: 16, color: AppColors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => _buildPage(onboardingData[index]),
          ),

          // Dots indicator
          Positioned(
            bottom: 150,
            child: Row(
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 60 : 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.main600
                        : AppColors.purpleGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // Button
          Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: _currentPage == onboardingData.length - 1
                  ? ElevatedButton(
                      onPressed: _completeOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main600,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Get Started',
                          style: TextStyle(fontSize: 18, color: AppColors.white)),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.main600,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20),
                        ),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}
