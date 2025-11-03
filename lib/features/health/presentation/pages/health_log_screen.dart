import 'package:flutter/material.dart';
import '../widgets/vitals_card.dart';
import '../widgets/bmi_card.dart';
import '../widgets/weight_progress_chart.dart';

class HealthLogPage extends StatefulWidget {
  const HealthLogPage({Key? key}) : super(key: key);

  @override
  State<HealthLogPage> createState() => _HealthLogPageState();
}

class _HealthLogPageState extends State<HealthLogPage> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF0FF),
      body: SafeArea(
        child: Row(
          children: [
            // Side Navigation
            Container(
              width: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple.shade50,
                    Colors.pink.shade50,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.favorite, 'Vitals', 0),
                  _buildNavItem(Icons.medication, 'Symptoms', 1),
                  _buildNavItem(Icons.science, 'Lab\nResults', 2),
                  _buildNavItem(Icons.warning_amber_rounded, 'Risk\nAlerts', 3),
                  _buildNavItem(Icons.sentiment_satisfied_alt, 'Mood', 4),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Health Log',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9D6DB8),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined),
                              color: const Color(0xFF9D6DB8),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Track your wellness',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Vitals Row
                          Row(
                            children: [
                              Expanded(
                                child: VitalsCard(
                                  icon: Icons.monitor_weight_outlined,
                                  title: 'Weight',
                                  value: '69 Kg',
                                  status: 'Normal',
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: VitalsCard(
                                  icon: Icons.favorite,
                                  title: 'Heart Rate',
                                  value: '69 Kg',
                                  status: 'Normal',
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Blood Pressure & Add Measurement
                          Row(
                            children: [
                              Expanded(
                                child: VitalsCard(
                                  icon: Icons.favorite,
                                  title: 'Heart Rate',
                                  value: '69 Kg',
                                  status: 'Normal',
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB3)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Add',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        'Measurment',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // BMI Card
                          const BMICard(),
                          const SizedBox(height: 16),
                          // Weight Progress Chart
                          const WeightProgressChart(),
                          const SizedBox(height: 16),
                          // Health Tip
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8D5F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Great job! You\'re maintaining a healthy weight gain pace. Keep up with your balanced diet and gentle exercise routine.',
                              style: TextStyle(
                                color: Color(0xFF7B4BA6),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF9D6DB8),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Market'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF9D6DB8) : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF9D6DB8) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}