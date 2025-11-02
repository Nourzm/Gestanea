import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/features/health/presentation/widgets/health_tab_bar.dart';
import 'package:pregnancy_baby_app/features/health/presentation/widgets/vitals_tab_content.dart';

class HealthLogScreen extends StatefulWidget {
  const HealthLogScreen({super.key});

  @override
  State<HealthLogScreen> createState() => _HealthLogScreenState();
}

class _HealthLogScreenState extends State<HealthLogScreen> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.favorite_border, 'label': 'Vitals'},
    {'icon': Icons.healing, 'label': 'Symptoms'},
    {'icon': Icons.science_outlined, 'label': 'Lab\nResults'},
    {'icon': Icons.warning_amber_outlined, 'label': 'Risk\nAlerts'},
    {'icon': Icons.star_border, 'label': 'Mood'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Row(
          children: [
            // Vertical Tab Bar
            HealthTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            
            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Health Log',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.main500,
                              ),
                            ),
                            Text(
                              'Track your wellness',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.purpleGrey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.notifications_outlined, color: AppColors.main600),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content based on selected tab
                  Expanded(
                    child: _buildTabContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return VitalsTabContent();
      case 1:
        return _buildComingSoon('Symptoms');
      case 2:
        return _buildComingSoon('Lab Results');
      case 3:
        return _buildComingSoon('Risk Alerts');
      case 4:
        return _buildComingSoon('Mood');
      default:
        return VitalsTabContent();
    }
  }

  Widget _buildComingSoon(String tabName) {
    return Center(
      child: Text(
        '$tabName - Coming Soon',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}