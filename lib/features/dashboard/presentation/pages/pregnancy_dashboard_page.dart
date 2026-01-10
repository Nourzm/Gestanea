// lib/features/dashboard/presentation/pages/pregnancy_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/week_progress_card.dart';
import '../widgets/upcoming_reminders_widget.dart';
import '../widgets/health_alerts_widget.dart';
import '../providers/dashboard_provider.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/dashboard/logic/cubit/upcoming_appointments_cubit.dart'; 

class PregnancyDashboardPage extends StatefulWidget {
  const PregnancyDashboardPage({super.key});

  @override
  State<PregnancyDashboardPage> createState() => _PregnancyDashboardPageState();
}

class _PregnancyDashboardPageState extends State<PregnancyDashboardPage> {
  late final DashboardProvider _provider;

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _provider = DashboardProvider.getInstance();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = _getUserId();
    if (userId.isNotEmpty) {
      _provider.setUserIdString(userId);
      await _provider.loadPregnancyDashboard();
    }
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
                _buildUpcomingSection(),
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

  Widget _buildUpcomingSection() {
    final userId = _getUserId();
    final cubit = UpcomingAppointmentsCubit.getInstance();
    
    return BlocBuilder<UpcomingAppointmentsCubit, UpcomingAppointmentsState>(
      bloc: cubit,
      builder: (context, state) {
          // Trigger load on initial state
          if (state is UpcomingAppointmentsInitial) {
            Future.microtask(() {
              if (userId.isNotEmpty) {
                cubit.loadUpcomingAppointments(userId);
              }
            });
            return const Center(child: CircularProgressIndicator());
          }
          
          // Render per-state to avoid collection-if complexity and ensure visibility
          if (userId.isEmpty) {
            return Center(
              child: Text(
                'Sign in to see your appointments',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            );
          }

          if (state is UpcomingAppointmentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UpcomingAppointmentsLoaded) {
            return Container(
              padding: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF000000).withOpacity(0.02),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.appointments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final appointment = state.appointments[index];
                      return _buildUpcomingCard(
                        icon: _getAppointmentIcon(appointment.appointmentType ?? ''),
                        title: appointment.title,
                        subtitle: _formatAppointmentDateTime(appointment),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          if (state is UpcomingAppointmentsEmpty) {
            return Center(
              child: Text(
                'No upcoming appointments in the next 7 days',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            );
          }

          if (state is UpcomingAppointmentsError) {
            return Center(
              child: Text(
                'Error loading appointments',
                style: TextStyle(color: Colors.red.shade400),
              ),
            );
          }

          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          );
        },
    );
  }

  IconData _getAppointmentIcon(String appointmentType) {
    switch (appointmentType.toLowerCase()) {
      case 'vaccination':
      case 'vaccine':
        return Icons.medical_services;
      case 'checkup':
      case 'check-up':
      case 'medical':
        return Icons.favorite;
      case 'appointment':
        return Icons.calendar_today;
      default:
        return Icons.event;
    }
  }

  String _formatAppointmentDateTime(appointment) {
    final appointmentDate = appointment.appointmentDate;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay =
        DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);

    String dayText = '';
    if (appointmentDay == today) {
      dayText = 'Today';
    } else if (appointmentDay ==
        today.add(const Duration(days: 1))) {
      dayText = 'Tomorrow';
    } else {
      dayText =
          '${appointmentDay.day} ${_getMonthName(appointmentDay.month)}';
    }

    final time =
        '${appointmentDate.hour.toString().padLeft(2, '0')}:${appointmentDate.minute.toString().padLeft(2, '0')}';
    return '$dayText at $time';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildUpcomingCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF9B7FDB),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
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