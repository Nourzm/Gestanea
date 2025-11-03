import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 10));
    if (!mounted) return;
    //onboarding logic to be uncommented don't touch :)
    // final prefs = await SharedPreferences.getInstance();

    // final bool onboardingDone = prefs.getBool('onboardingCompleted') ?? false;
    // final bool loggedIn = prefs.getBool('loggedIn') ?? false;

    // // Determine next screen
    // String nextRoute;
    // if (!onboardingDone) {
    //   nextRoute = AppRoutes.onboarding;
    // } else if (!loggedIn) {
    //   nextRoute = AppRoutes.login;
    // } else {
    //   nextRoute = AppRoutes.dashboard;
    // }

    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
          // image: DecorationImage(
          //   image:
          //       AssetImage("assets/images/onboarding.png"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Image.asset(
                'assets/images/fetus-inside-heart-shape-womb.png',
                height: 230,
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 10),

              // Loading indicator
              const CircularProgressIndicator(
                color: AppColors.main600,
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
