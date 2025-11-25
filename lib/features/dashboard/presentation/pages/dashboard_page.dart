// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:gestanea/features/dashboard/presentation/pages/home_screen.dart';
import 'postpartum_dashboard_page.dart';
import 'package:gestanea/features/pregnancy/presentation/pages/week_tracker_page.dart';
import 'postpartum_track_page.dart';
import 'package:gestanea/features/health/presentation/pages/health_log_screen.dart';
import 'package:gestanea/features/plan/presentation/pages/plan_page.dart';
import 'package:gestanea/features/marketplace/presentation/pages/marketplace_page.dart';

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
      const MarketplacePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => _setPageIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF9B7FDB),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 26),
                activeIcon: Icon(Icons.home, size: 26),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart, size: 26),
                activeIcon: Icon(Icons.show_chart, size: 26),
                label: 'Track',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline, size: 26),
                activeIcon: Icon(Icons.favorite, size: 26),
                label: 'Health',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined, size: 26),
                activeIcon: Icon(Icons.calendar_today, size: 26),
                label: 'Plan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined, size: 26),
                activeIcon: Icon(Icons.shopping_bag, size: 26),
                label: 'Market',
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: _currentIndex == 0
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           _showModeDialog();
      //         },
      //         backgroundColor: const Color(0xFF9B7FDB),
      //         child: const Icon(Icons.settings),
      //       )
      //     : null,
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

