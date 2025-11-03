// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'pregnancy_dashboard_page.dart';
import 'postpartum_dashboard_page.dart';
import '../../../pregnancy/presentation/pages/week_tracker_page.dart';
import 'postpartum_track_page.dart';
import '../../../health/presentation/pages/health_log_screen.dart'; // ✅ Add this
import '../../../marketplace/presentation/pages/marketplace_page.dart'; // ✅ Add this

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool isPregnant = true;
  String babyGender = 'girl';

  @override
  Widget build(BuildContext context) {
    final pages = [
      isPregnant
          ? const PregnancyDashboardPage()
          : PostpartumDashboardPage(babyGender: babyGender),
      isPregnant
          ? const WeekTrackerPage()
          : PostpartumTrackPage(babyGender: babyGender),
      const HealthLogScreen(), // ✅ Replace placeholder with actual Health page
      _buildPlaceholderPage('Plan', Icons.calendar_today),
      const MarketplacePage(), // ✅ Replace placeholder with actual Market page
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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
            onTap: (index) => setState(() => _currentIndex = index),
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
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _showModeDialog();
              },
              backgroundColor: const Color(0xFF9B7FDB),
              child: const Icon(Icons.settings),
            )
          : null,
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'To be implemented',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Pregnancy Mode'),
              onTap: () {
                setState(() => isPregnant = true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Postpartum Mode (Girl)'),
              onTap: () {
                setState(() {
                  isPregnant = false;
                  babyGender = 'girl';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Postpartum Mode (Boy)'),
              onTap: () {
                setState(() {
                  isPregnant = false;
                  babyGender = 'boy';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}