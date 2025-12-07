import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_state.dart';
import 'package:gestanea/features/dashboard/domain/entities/pregnancy_dashboard.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/features/dashboard/presentation/pages/tips_page.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/cards.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/main_card.dart';
import 'package:gestanea/core/widgets/notificationsCard.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctors_page.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctors_bloc.dart';
import 'package:gestanea/features/profile/presentation/pages/profile_page.dart';
import 'package:intl/intl.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/dashboard/logic/cubit/upcoming_appointments_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});
  final void Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 👤 Profile section (tap -> Profile page)
                    GestureDetector(
                      onTap: () async {
                        // Capture cubit before navigation
                        final dashboardCubit = context.read<DashboardCubit>();
                        final authState = context.read<AuthBloc>().state;
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileSettingsScreen(),
                          ),
                        );
                        
                        // Refresh dashboard when returning from profile page
                        // This handles the case where user triggered "I Gave Birth"
                        if (authState is AuthAuthenticated) {
                          final userId = authState.user.id;
                          if (userId.isNotEmpty) {
                            // Refresh dashboard to reflect postpartum mode
                            dashboardCubit.loadDashboardByStringId(userId);
                            // Also refresh BabyCubit to load newly created baby profile and gender
                            try {
                              final babyCubit = context.read<BabyCubit>();
                              babyCubit.loadBabyProfile();
                            } catch (_) {
                              // BabyCubit may not be in this subtree; ignore if unavailable
                            }
                          }
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            child: Image.asset("assets/images/profile.png"),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              String greeting = 'Hello!';
                              String nameText = '';
                              if (state is AuthAuthenticated) {
                                nameText = state.user.name;
                                greeting = 'Hello';
                              }
                              return Text(
                                '$greeting ${nameText.isNotEmpty ? nameText : ''}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // 🔔 Notification icon (tap -> Notifications page)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                      child: NotificationIcon(
                        icon: Icon(Icons.notifications, color: AppColors.main500),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: PregnancyProgressCard(onTap: onNavigate),
              ),
              SizedBox(height: screenHeight * 0.025),

              // Tips and Doctors Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    // Our Tips Card
                    Expanded(child: ClickableTipsCard(targetPage: Tips())),

                    SizedBox(width: screenWidth * 0.04),

                    // Our Doctors Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => DoctorsBloc(),
                                child: const DoctorsScreen(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.045),
                          decoration: BoxDecoration(
                            color: AppColors.homeCards,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF000000,
                                ).withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(5, 3),
                              ),
                              BoxShadow(
                                color: const Color(0xFFffffff),
                                blurRadius: 10,
                                offset: const Offset(-5, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Stethoscope.svg",
                                color: AppColors.main500,
                                width: 32,
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                'Our Doctors',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.main500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Text(
                                'find the best doctor',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.032,
                                  color: AppColors.main500.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Up coming section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Up coming',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onNavigate(3), // Navigate to Plan page (index 3)
                      child: Text(
                        'see all',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: AppColors.main500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Upcoming appointments (aligned with Postpartum implementation)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: _buildUpcomingSection(context),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }
  
  Widget _buildUpcomingSection(BuildContext context) {
    final userId = _getUserId(context);
    final cubit = UpcomingAppointmentsCubit.getInstance();
    
    if (cubit.state is UpcomingAppointmentsInitial) {
      cubit.loadUpcomingAppointments(userId);
    }
    
    return BlocProvider<UpcomingAppointmentsCubit>.value(
      value: cubit,
      child: BlocBuilder<UpcomingAppointmentsCubit, UpcomingAppointmentsState>(
        builder: (context, state) {
          if (state is UpcomingAppointmentsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UpcomingAppointmentsLoaded) {
            return Column(
              children: state.appointments
                  .map((appointment) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildUpcomingCard(
                          icon: _getAppointmentIcon(appointment.appointmentType ?? ''),
                          iconBgColor: AppColors.main500,
                          title: appointment.title,
                          subtitle: _formatAppointmentDateTime(appointment),
                        ),
                      ))
                  .toList(),
            );
          } else if (state is UpcomingAppointmentsError) {
            return Center(
              child: Text(
                'Error loading appointments',
                style: TextStyle(color: Colors.red.shade400),
              ),
            );
          } else {
            return Center(
              child: Text(
                'No upcoming appointments',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            );
          }
        },
      ),
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

  String _formatAppointmentDateTime(dynamic appointment) {
    final appointmentDate = appointment.appointmentDate;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
    );

    String dayText = '';
    if (appointmentDay == today) {
      dayText = 'Today';
    } else if (appointmentDay == today.add(const Duration(days: 1))) {
      dayText = 'Tomorrow';
    } else {
      dayText = '${appointmentDay.day} ${_getMonthName(appointmentDay.month)}';
    }

    final time = '${appointmentDate.hour.toString().padLeft(2, '0')}:${appointmentDate.minute.toString().padLeft(2, '0')}';
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
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.homeCards,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.main500, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.calendar_today_outlined, color: AppColors.main500, size: 20),
        ],
      ),
    );
  }
  
  String _formatAppointmentTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    String dayText;
    if (appointmentDate == today) {
      dayText = 'Today';
    } else if (appointmentDate == tomorrow) {
      dayText = 'Tomorrow';
    } else {
      dayText = DateFormat('MMM d').format(dateTime);
    }
    
    final timeText = DateFormat('h:mm a').format(dateTime);
    return '$dayText at $timeText';
  }
  
  String _formatMedicineTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = dateTime.difference(now);
    
    if (diff.isNegative) {
      return 'Overdue';
    } else if (diff.inMinutes < 60) {
      return 'In ${diff.inMinutes} minutes';
    } else if (diff.inHours < 24) {
      return 'In ${diff.inHours} hours';
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }
  
  Widget _buildUpcomingItem(
    BuildContext context,
    double screenWidth,
    double screenHeight, {
    required String title,
    required String subtitle,
    required String icon,
    required bool isAppointment,
  }) {
    return GestureDetector(
      onTap: () => onNavigate(3), // Navigate to Plan page
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: AppColors.homeCards,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.main500,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.main500,
              ),
              child: SvgPicture.asset(
                icon,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: isAppointment ? 30 : 28,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              "assets/icons/Calendar_1.svg",
              colorFilter: const ColorFilter.mode(AppColors.main500, BlendMode.srcIn),
              width: 28,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNoUpcomingItems(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.06),
      decoration: BoxDecoration(
        color: AppColors.homeCards,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.main500.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: AppColors.main500.withValues(alpha: 0.5),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'No upcoming events',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          GestureDetector(
            onTap: () => onNavigate(3),
            child: Text(
              'Add appointments in Plan',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: AppColors.main500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
