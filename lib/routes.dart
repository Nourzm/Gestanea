import 'package:flutter/material.dart';
import 'package:gestanea/features/auth/presentation/pages/auth_page.dart';
import 'package:gestanea/features/auth/presentation/pages/login_page.dart';
import 'package:gestanea/features/auth/presentation/pages/signup_page.dart';
import 'package:gestanea/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gestanea/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:gestanea/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:gestanea/features/health/presentation/pages/health_log_screen.dart'; 
import 'package:gestanea/features/marketplace/presentation/pages/marketplace_page.dart'; 
import 'package:gestanea/features/doctors/presentation/pages/doctors_page.dart';
import 'package:gestanea/features/pregnancy/presentation/pages/week_tracker_page.dart'; 


import 'core/constants/app_routes.dart';

Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(), // ✅ Changed from OnboardingScreen
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.auth: (context) => const AuthPage(),
  AppRoutes.track: (context) => const WeekTrackerPage(),

  AppRoutes.signup: (context) => const SignupScreen(),
  AppRoutes.dashboard: (context) => const DashboardPage(),
  // AppRoutes.pregnancy: (context) => const PregnancyScreen(),
  // AppRoutes.baby: (context) => const BabyScreen(),
  AppRoutes.healthLog: (context) => const HealthLogScreen(), // ✅ Changed from HealthLogScreen
  // AppRoutes.plan: (context) => const PlanScreen(),
  // AppRoutes.education: (context) => const EducationScreen(),
  AppRoutes.doctors: (context) => const DoctorsScreen(), 
  AppRoutes.marketplace: (context) => const MarketplacePage(), // ✅ Changed from MarketplaceScreen
  // AppRoutes.profile: (context) => const ProfileScreen(),
};