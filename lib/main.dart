// lib/main.dart
import 'package:flutter/material.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const PregnancyTrackerApp());
}

class PregnancyTrackerApp extends StatelessWidget {
  const PregnancyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pregnancy Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF9B7FDB),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF9B7FDB),
          secondary: Color(0xFFE8A5C8),
        ),
      ),
      navigatorObservers: [routeObserver], // ✅ Add this
      home: const DashboardPage(),
    );
  }
}
