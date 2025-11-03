import 'package:flutter/material.dart';
import 'package:gestanea/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gestanea/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:gestanea/features/onboarding/presentation/pages/splash_screen.dart';

import 'core/constants/app_routes.dart'; // your AppRoutes class

Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  // AppRoutes.login: (context) => const LoginScreen(),
  // AppRoutes.signup: (context) => const SignupScreen(),
  AppRoutes.dashboard: (context) => const DashboardScreen(),
  // AppRoutes.pregnancy: (context) => const PregnancyScreen(),
  // AppRoutes.baby: (context) => const BabyScreen(),
  // AppRoutes.healthLog: (context) => const HealthLogScreen(),
  // AppRoutes.plan: (context) => const PlanScreen(),
  // AppRoutes.education: (context) => const EducationScreen(),
  // AppRoutes.doctors: (context) => const DoctorsScreen(),
  // AppRoutes.marketplace: (context) => const MarketplaceScreen(),
  // AppRoutes.profile: (context) => const ProfileScreen(),
};
