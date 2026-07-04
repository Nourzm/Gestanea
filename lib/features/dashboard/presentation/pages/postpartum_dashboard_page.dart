import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/widgets/notifications_card.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/repositories/baby_repository.dart';
import 'package:gestanea/features/dashboard/domain/entities/postpartum_dashboard.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notifications_page.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctors_page.dart'
    show DoctorsScreen;
import 'package:gestanea/features/dashboard/presentation/pages/tips_page.dart'
    as tips;
import 'package:gestanea/features/profile/presentation/pages/profile_page.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'postpartum_track_page.dart';

class PostpartumDashboardPage extends StatefulWidget {
  final String babyGender;
  final PostpartumDashboard? dashboard;

  const PostpartumDashboardPage({
    super.key,
    required this.babyGender,
    this.dashboard,
  });

  @override
  State<PostpartumDashboardPage> createState() =>
      _PostpartumDashboardPageState();
}

class _PostpartumDashboardPageState extends State<PostpartumDashboardPage> {
  Color get primaryColor => widget.babyGender == 'girl'
      ? const Color(0xFFFF9EC9)
      : const Color(0xFF87CEEB);

  Color get lightColor => widget.babyGender == 'girl'
      ? const Color(0xFFFFC6E0)
      : const Color(0xFFB0E0E6);

  Color get accentColor => widget.babyGender == 'girl'
      ? const Color(0xFFFFA6D3)
      : const Color(0xFF9BD3F9);

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  String _formatAgeText(int months) {
    final t = AppLocalizations.of(context)!;
    if (months <= 0) {
      return t.ageNewborn;
    } else if (months < 12) {
      return t.ageMonths(months);
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return t.ageYears(years);
      }
      return t.ageYearsMonths(years, remainingMonths);
    }
  }

  String _formatNextVaccine() {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dashboard = widget.dashboard;
    if (dashboard == null || dashboard.nextVaccines.isEmpty) {
      return t.allCaughtUpShort;
    }
    final nextVaccine = dashboard.nextVaccines.first;
    final dueDate = nextVaccine.dueDate;
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return t.vaccineOverdue(nextVaccine.vaccineName);
    } else if (difference == 0) {
      return t.vaccineToday(nextVaccine.vaccineName);
    } else if (difference <= 7) {
      return t.vaccineOn(
        nextVaccine.vaccineName,
        DateFormat('MMM d', locale).format(dueDate),
      );
    } else {
      return t.nextColon(DateFormat('MMM d', locale).format(dueDate));
    }
  }

  void _navigateToTrackPage() {
    // Navigate to Track tab (index 1 in bottom nav)
    final userId = _getUserId();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => BabyCubit(
            repository: BabyRepository(
              BabyLocalDataSource(DatabaseHelper.instance),
            ),
            userId: userId,
          )..loadBabyProfile(),
          child: PostpartumTrackPage(babyGender: widget.babyGender),
        ),
      ),
    );
  }

  void _navigateToPlanPage() {
    Navigator.pushNamed(context, AppRoutes.plan);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dashboard = widget.dashboard;
    final babyName = dashboard?.babyName ?? t.babyDefault;
    final babyAge = dashboard?.babyAgeInMonths ?? 0;
    final babyWeight = dashboard?.babyWeight ?? 0.0;
    final babyHeight = dashboard?.babyHeight ?? 0.0;
    final growthStatus = dashboard?.growthStatus ?? t.onTrack;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                            String greeting = t.helloGreeting;
                            String nameText = '';
                            if (state is AuthAuthenticated) {
                              nameText = state.user.name;
                              greeting = t.hello;
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
              const SizedBox(height: 20),

              // Baby Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, lightColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          child: const Icon(
                            Icons.child_care,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                babyName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                _formatAgeText(babyAge),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.vaccines,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        _formatNextVaccine(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          t.weight,
                          babyWeight > 0
                              ? t.kgValue(babyWeight.toStringAsFixed(1))
                              : '--',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        _buildStatColumn(
                          t.heightLabel,
                          babyHeight > 0
                              ? '${babyHeight.toStringAsFixed(0)} cm'
                              : '--',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        _buildStatColumn(t.growthLabel, growthStatus),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _navigateToTrackPage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            t.moreLabel,
                            style: TextStyle(color: primaryColor),
                          ),
                          const Icon(
                            Icons.arrow_right_alt,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tips and Doctors Cards (Clickable)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const tips.Tips()),
                        );
                      },
                      child: _buildInfoCard(
                        color: primaryColor,
                        icon: Icons.lightbulb_outline,
                        title: t.ourTips,
                        subtitle: t.followBestPractices,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DoctorsScreen(),
                          ),
                        );
                      },
                      child: _buildInfoCard(
                        color: lightColor,
                        icon: Icons.medical_services_outlined,
                        title: t.ourDoctors,
                        subtitle: t.findBestDoctor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Upcoming Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.upComing,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToPlanPage,
                    child: Text(
                      t.seeAll,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Reminder Cards from dashboard data
              if (dashboard != null && dashboard.nextVaccines.isNotEmpty)
                ...dashboard.nextVaccines
                    .take(2)
                    .map(
                      (vaccine) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildReminderCard(
                          vaccine.vaccineName,
                          DateFormat(
                            'MMM d, yyyy',
                            locale,
                          ).format(vaccine.dueDate),
                          primaryColor,
                          Icons.vaccines,
                        ),
                      ),
                    )
              else
                _buildReminderCard(
                  t.noUpcomingVaccines,
                  t.allCaughtUpShort,
                  lightColor,
                  Icons.check_circle,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(
    String title,
    String time,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.7),
            radius: 20,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.calendar_month, color: color),
        ],
      ),
    );
  }
}
