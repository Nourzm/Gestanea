import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../widgets/health_header.dart';
import '../widgets/health_tab_sidebar.dart';
import '../widgets/vitals_tab_content.dart';
import '../widgets/symptoms_tab_content.dart';
import '../widgets/lab_results_tab_content.dart';
import '../widgets/risk_alerts_tab_content.dart';
import '../widgets/mood_tab_content.dart';

class HealthLogScreen extends StatefulWidget {
  const HealthLogScreen({super.key});

  @override
  State<HealthLogScreen> createState() => _HealthLogScreenState();
}

class _HealthLogScreenState extends State<HealthLogScreen> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.favorite, 'labelKey': 'vitals'},
    {'icon': Icons.medication, 'labelKey': 'symptoms'},
    {'icon': Icons.science, 'labelKey': 'labResults'},
    {'icon': Icons.warning_amber_rounded, 'labelKey': 'riskAlerts'},
    {'icon': Icons.sentiment_satisfied_alt, 'labelKey': 'mood'},
  ];

  Widget _getTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const VitalsTabContent();
      case 1:
        return const SymptomsTabContent();
      case 2:
        return const LabResultsTabContent();
      case 3:
        return const RiskAlertsTabContent();
      case 4:
        return const MoodTabContent();
      default:
        return const VitalsTabContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HealthHeader(
              title: localizations.healthLog,
              subtitle: localizations.trackYourWellness,
              onNotificationTapped: () {
                // Handle notification tap
              },
            ),

            // Main content with sidebar and tab content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Sidebar Navigation
                  HealthTabSidebar(
                    tabs: _tabs,
                    selectedIndex: _selectedTabIndex,
                    onTabSelected: (index) {
                      setState(() => _selectedTabIndex = index);
                    },
                  ),

                  // Tab Content Area
                  Expanded(
                    child: _getTabContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}