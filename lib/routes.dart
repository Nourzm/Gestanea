import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/presentation/pages/auth_page.dart';
import 'package:gestanea/features/auth/presentation/pages/personalize_1.dart';
import 'package:gestanea/features/auth/presentation/pages/login_page.dart';
import 'package:gestanea/features/auth/presentation/pages/signup_page.dart';
import 'package:gestanea/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gestanea/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:gestanea/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:gestanea/features/health/presentation/pages/health_log_screen.dart';
import 'package:gestanea/features/plan/presentation/pages/plan_page.dart';
import 'package:gestanea/features/marketplace/presentation/pages/marketplace_page.dart';
import 'package:gestanea/features/marketplace/logic/marketplace_bloc.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctors_page.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_bloc.dart';
import 'package:gestanea/features/pregnancyTracking/presentation/pages/week_tracker_page.dart';
import 'core/constants/app_routes.dart';

Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.auth: (context) => const AuthPage(),
  AppRoutes.personalize: (context) => const Personalize1(),
  AppRoutes.track: (context) => const WeekTrackerPage(),

  AppRoutes.signup: (context) => const SignupScreen(),
  AppRoutes.dashboard: (context) => const DashboardPage(),
  // AppRoutes.pregnancy: (context) => const PregnancyScreen(),
  // AppRoutes.baby: (context) => const BabyScreen(),
  AppRoutes.healthLog: (context) => const HealthLogScreen(),

  AppRoutes.plan: (context) => const PlanMainPage(),

  AppRoutes.doctors: (context) => BlocProvider(
    create: (context) => DoctorsBloc(),

    child: const DoctorsScreen(),
  ),
  AppRoutes.marketplace: (context) => BlocProvider(
    create: (context) => MarketplaceBloc()..add(const LoadMarketplaceData()),
    child: const MarketplacePage(),
  ),
};
