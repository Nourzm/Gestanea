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
                    // Profile section (tap -> Profile page)
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
                            dashboardCubit.loadDashboardByStringId(userId);
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

                    //Notification icon (tap -> Notifications page)
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
                        icon: Icon(
                          Icons.notifications,
                          color: AppColors.main500,
                        ),
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
                                  color: AppColors.main500.withValues(
                                    alpha: 0.7,
                                  ),
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
                      onTap: () =>
                          onNavigate(3), // Navigate to Plan page (index 3)
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

              // Upcoming items from database
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    List<AppointmentReminder> appointments = [];
                    List<MedicineReminder> medicines = [];

                    if (state is PregnancyDashboardLoaded) {
                      appointments = state.dashboard.upcomingAppointments;
                      medicines = state.dashboard.medicineReminders;
                    }

                    // Combine and limit to 3 items
                    final List<Widget> upcomingItems = [];

                    // Add appointments
                    for (
                      var i = 0;
                      i < appointments.length && upcomingItems.length < 3;
                      i++
                    ) {
                      upcomingItems.add(
                        _buildUpcomingItem(
                          context,
                          screenWidth,
                          screenHeight,
                          title: appointments[i].title,
                          subtitle: _formatAppointmentTime(
                            appointments[i].dateTime,
                          ),
                          icon: "assets/icons/heartplus.svg",
                          isAppointment: true,
                        ),
                      );
                    }

                    // Add medicines
                    for (
                      var i = 0;
                      i < medicines.length && upcomingItems.length < 3;
                      i++
                    ) {
                      upcomingItems.add(
                        _buildUpcomingItem(
                          context,
                          screenWidth,
                          screenHeight,
                          title: medicines[i].medicineName,
                          subtitle: _formatMedicineTime(
                            medicines[i].nextDoseTime,
                          ),
                          icon: "assets/icons/pills.svg",
                          isAppointment: false,
                        ),
                      );
                    }

                    // Show placeholder if no upcoming events
                    if (upcomingItems.isEmpty) {
                      return _buildNoUpcomingItems(screenWidth, screenHeight);
                    }

                    return Column(children: upcomingItems);
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAppointmentTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
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
          border: Border.all(color: AppColors.main500, width: 1),
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
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
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
              colorFilter: const ColorFilter.mode(
                AppColors.main500,
                BlendMode.srcIn,
              ),
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
