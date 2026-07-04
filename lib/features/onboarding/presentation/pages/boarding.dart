import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> _onboardingData(AppLocalizations t) => [
    {
      'title': t.obTrack,
      'subtitle': t.obYourJourney,
      'description': t.obDesc1,
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': t.obBabyGrowth,
      'subtitle': t.obMonitor,
      'description': t.obDesc2,
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': t.obNeverMiss,
      'subtitle': t.obMoment,
      'description': t.obDesc3,
      'image': 'assets/images/onboarding3.png',
    },
    {
      'title': t.obMomBaby,
      'subtitle': t.obMarketplace,
      'description': t.obDesc4,
      'image': 'assets/images/onboarding4.png',
    },
  ];

  // ignore: unused_element
  Future<void> _completeOnboarding() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('onboardingCompleted', true);
    // if (mounted) {
    Navigator.pushReplacementNamed(context, AppRoutes.auth);
    // }
  }

  Widget _buildPage(Map<String, String> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(data['image']!, height: 150),
        const SizedBox(height: 30),
        Text(
          data['title']!,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          data['subtitle']!,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.main600,
          ),
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
    final t = AppLocalizations.of(context)!;
    final onboardingData = _onboardingData(t);
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) =>
                      _buildPage(onboardingData[index]),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: _currentPage == index ? 60 : 20,
                          height: 20,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(4, 4),
                              ),
                              BoxShadow(
                                color: Color.fromARGB(70, 255, 255, 255),
                                blurRadius: 6,
                                offset: Offset(-2, -2),
                              ),
                            ],
                            color: _currentPage == index
                                ? AppColors.main600
                                : AppColors.purpleGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Button
                    _currentPage == onboardingData.length - 1
                        ? AppButton(
                            onPressed: _completeOnboarding,
                            text: t.getStarted,
                          )
                        : AppButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            text: t.next,
                            suffixIcon: "assets/icons/next-arrow.svg",
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
