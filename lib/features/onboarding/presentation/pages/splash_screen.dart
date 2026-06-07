import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController for the loading dots
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController for dot animation
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // Cycle duration
    )..repeat(); // Keep the animation running

    _navigateNext();
  }

  @override
  void dispose() {
    _dotController.dispose(); // Important: dispose the controller
    super.dispose();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    //onboarding logic to be uncommented don't touch :)
    // final prefs = await SharedPreferences.getInstance();

    // final bool onboardingDone = prefs.getBool('onboardingCompleted') ?? false;
    // final bool loggedIn = prefs.getBool('loggedIn') ?? false;

    // // Determine next screen
    // String nextRoute;
    // if (!onboardingDone) {
    //   nextRoute = AppRoutes.onboarding;
    // } else if (!loggedIn) {
    //   nextRoute = AppRoutes.login;
    // } else {
    //   nextRoute = AppRoutes.dashboard;
    // }

    final authState = context.read<AuthBloc>().state;
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboardingCompleted') ?? false;
    if (!mounted) return;

    final String nextRoute;
    if (authState is AuthAuthenticated) {
      nextRoute = AppRoutes.dashboard;
    } else if (!onboardingDone) {
      nextRoute = AppRoutes.onboarding;
    } else {
      nextRoute = AppRoutes.login;
    }
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  // --- Widget for the Animated Loading Dots (Pulsing Effect) ---
  Widget _buildLoadingDots() {
    // Use a ListView.builder for a simple, non-animated version
    // Use an AnimatedBuilder with an OpacityTween for an animated effect
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Calculate the delay for each dot to pulse sequentially
            final delay = index * 0.2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AnimatedBuilder(
                animation: _dotController,
                builder: (context, child) {
                  // A simple wave/pulse effect by calculating a value based on the controller time
                  // The curve ensures it fades in and out smoothly
                  final value = (_dotController.value * 1.0) - delay;
                  // Ensure the value is between 0 and 1, and apply a sine wave to it
                  final opacity =
                      (0.5 +
                      0.5 *
                          Curves.easeInOut.transform(
                            (value % 1.0).abs(), // Cycle the value and take abs
                          ));

                  return Opacity(
                    opacity: opacity.clamp(0.2, 1.0), // Clamp for visibility
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: const BoxDecoration(
                        color: Colors.white, // Dots are white in the image
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        const Text(
          'Loading your experience...',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  // --- The main build method for the UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body uses a simple purple color as a base,
      // replace with AppColors.splashGradient if that's the desired purple look
      body: Container(
        decoration: const BoxDecoration(
          // Purple gradient matching the Figma splash design.
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB077E5), Color(0xFF9A77BE)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/fetus.png',
                      height: 100, // Adjust size to fit the circle
                      // If your icon is a single color, you can use color and colorBlendMode here
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ), // Increased space to center the content
              // App Name
              const Text(
                'Gestanéa',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Color(0x4d000000),
                      blurRadius: 10,
                      offset: Offset(3, 3),
                    ),
                  ],
                  fontSize: 46,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Your Journey, Our Care',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Color(0x4d000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 100),

              // Animated Loading Dots
              _buildLoadingDots(),
            ],
          ),
        ),
      ),
    );
  }
}
