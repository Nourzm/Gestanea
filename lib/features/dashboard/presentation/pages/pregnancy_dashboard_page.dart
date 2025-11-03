// lib/features/dashboard/presentation/pages/pregnancy_dashboard_page.dart
import 'package:flutter/material.dart';
import '../widgets/week_progress_card.dart';
import '../widgets/upcoming_reminders_widget.dart';
import '../widgets/health_alerts_widget.dart';
import '../providers/dashboard_provider.dart';
import 'package:gestanea/core/constants/app_routes.dart'; 

class PregnancyDashboardPage extends StatefulWidget {
  const PregnancyDashboardPage({super.key});

  @override
  State<PregnancyDashboardPage> createState() => _PregnancyDashboardPageState();
}

class _PregnancyDashboardPageState extends State<PregnancyDashboardPage> {
  final DashboardProvider _provider = DashboardProvider();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _provider.loadPregnancyDashboard();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _provider.pregnancyDashboard;

    if (_provider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dashboard == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: Text('No data available')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.white),
                          // TODO: Replace with user image
                          // backgroundImage: AssetImage('assets/images/user_avatar.png'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Hello ${dashboard.userName}! 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF9B7FDB),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Pregnancy Progress Card
                WeekProgressCard(
                  currentWeek: dashboard.currentWeek,
                  currentDay: dashboard.currentDay,
                  trimester: dashboard.trimester,
                  daysLeft: dashboard.daysLeft,
                  progressPercentage: dashboard.progressPercentage,
                ),
                const SizedBox(height: 20),

                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'Find Doctor',
                        'Search nearby',
                        const Color(0xFF9B7FDB),
                        Icons.medical_services_outlined,
        () {
          // ✅ Navigate to actual doctors screen instead of placeholder
          Navigator.pushNamed(context, AppRoutes.doctors);
        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        'Read Tips',
                        'Daily advice',
                        const Color(0xFFD4B5E8),
                        Icons.lightbulb_outline,
                        () {
                          // TODO: Team will implement - Navigate to tips
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _PlaceholderPage(title: 'Read Tips'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Upcoming Appointments & Medicine
                const Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                UpcomingRemindersWidget(
                  appointments: dashboard.upcomingAppointments,
                  medicines: dashboard.medicineReminders,
                ),
                const SizedBox(height: 24),

                // Health Alerts
                const Text(
                  'Health Alerts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                HealthAlertsWidget(alerts: dashboard.healthAlerts),
                const SizedBox(height: 24),

                // Tip of the Day
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE5B4), Color(0xFFFFD700)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tip of the Day',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dashboard.tipOfTheDay,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder page for team to implement
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF9B7FDB),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'To be implemented by team',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}