// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/dashboard/presentation/pages/home_screen.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/navbar.dart';
import 'postpartum_dashboard_page.dart';
import 'package:gestanea/features/pregnancy/presentation/pages/week_tracker_page.dart';
import 'postpartum_track_page.dart';
import 'package:gestanea/features/health/presentation/pages/health_log_screen.dart';
import 'package:gestanea/features/plan/presentation/pages/plan_page.dart';
import 'package:gestanea/features/marketplace/presentation/pages/marketplace_page.dart';
import 'package:gestanea/features/marketplace/logic/marketplace_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool isPregnant = true;
  String babyGender = 'girl';

  void _setPageIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      isPregnant
          ? HomeScreen(onNavigate: _setPageIndex)
          : PostpartumDashboardPage(babyGender: babyGender),
      isPregnant
          ? const WeekTrackerPage()
          : PostpartumTrackPage(babyGender: babyGender),
      const HealthLogScreen(),
      const PlanMainPage(),
      BlocProvider(
        create: (context) =>
            MarketplaceBloc()..add(const LoadMarketplaceData()),
        child: const MarketplacePage(),
      ),
    ];
    final double h = MediaQuery.of(context).size.height * 0.09;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: h),
            child: IndexedStack(index: _currentIndex, children: pages),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FancyNavBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: [
                NavBarItem(icon: "assets/icons/home.svg", label: "Home"),
                NavBarItem(icon: "assets/icons/track.svg", label: "Track"),
                NavBarItem(icon: "assets/icons/health.svg", label: "Health"),
                NavBarItem(icon: "assets/icons/plan.svg", label: "Plan"),
                NavBarItem(icon: "assets/icons/market.svg", label: "Market"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

  // void _showModeDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Change Mode'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             title: const Text('Pregnancy Mode'),
  //             onTap: () {
  //               setState(() => isPregnant = true);
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             title: const Text('Postpartum Mode (Girl)'),
  //             onTap: () {
  //               setState(() {
  //                 isPregnant = false;
  //                 babyGender = 'girl';
  //               });
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             title: const Text('Postpartum Mode (Boy)'),
  //             onTap: () {
  //               setState(() {
  //                 isPregnant = false;
  //                 babyGender = 'boy';
  //               });
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

