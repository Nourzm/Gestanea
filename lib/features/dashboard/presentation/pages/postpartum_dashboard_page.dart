import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/features/baby/data/datasources/vaccine_local_data_source.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:gestanea/features/baby/logic/repositories/baby_repository.dart';
import 'package:gestanea/features/baby/presentation/pages/baby_settings_page.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctors_page.dart' show DoctorsScreen;
import 'package:gestanea/features/doctors/logic/bloc/doctors_bloc.dart';
import 'package:gestanea/features/dashboard/presentation/pages/tips_page.dart' as tips;
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/features/dashboard/logic/cubit/upcoming_appointments_cubit.dart';
import 'postpartum_track_page.dart';
import 'package:gestanea/features/baby/presentation/pages/vaccine_tracker_page.dart';

class PostpartumDashboardPage extends StatefulWidget {
  final String babyGender;

  const PostpartumDashboardPage({
    super.key,
    required this.babyGender,
  });

  @override
  State<PostpartumDashboardPage> createState() =>
      _PostpartumDashboardPageState();
}

class _PostpartumDashboardPageState extends State<PostpartumDashboardPage> {
    final VaccineLocalDataSource _vaccineLocalDataSource = VaccineLocalDataSource();
  // Gender-based theme colors
  late String currentBabyGender;

  @override
  void initState() {
    super.initState();
    currentBabyGender = widget.babyGender;
  }

  @override
  void didUpdateWidget(PostpartumDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.babyGender != widget.babyGender) {
      setState(() {
        currentBabyGender = widget.babyGender;
      });
    }
  }

  bool get isGirl => currentBabyGender.toLowerCase() == 'girl' || 
                     currentBabyGender.toLowerCase() == 'female';
  
  Color get primaryColor => isGirl 
      ? const Color(0xFFFF9EC9)  // Pink for girls
      : const Color(0xFF87CEEB); // Blue for boys
  Color get lightBlue => isGirl 
      ? const Color(0xFFFFC6E0)  // Light pink for girls
      : const Color(0xFFD6E9F8); // Light blue for boys
  Color get cardBlue => isGirl 
      ? const Color(0xFFFFE4F0)  // Card pink for girls
      : const Color(0xFFE8F4FC); // Card blue for boys
  Color get accentBlue => isGirl 
      ? const Color(0xFFFF85B3)  // Accent pink for girls
      : const Color(0xFF4A90D9); // Accent blue for boys

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  String _formatAgeText(DateTime dateOfBirth) {
    final now = DateTime.now();
    final months = (now.year - dateOfBirth.year) * 12 + (now.month - dateOfBirth.month);
    
    if (months == 0) {
      return 'Newborn';
    } else if (months == 1) {
      return '1 month old';
    } else if (months < 12) {
      return '$months months old';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'year' : 'years'} old';
      }
      return '$years years, $remainingMonths months old';
    }
  }

  void _navigateToTrackPage() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<BabyCubit, BabyState>(
        builder: (context, state) {
          String babyName = 'Baby';
          DateTime babyDateOfBirth = DateTime.now();
          String nextVaccineDate = '-';
          int upcomingVaccines = 0;
          String growthStatus = 'On track';

          if (state is BabyLoaded) {
            babyName = state.baby.name;
            babyDateOfBirth = state.baby.dateOfBirth;
            // Update gender if it changed
            if (state.baby.gender != null && state.baby.gender != currentBabyGender) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  currentBabyGender = state.baby.gender ?? widget.babyGender;
                });
              });
            }
          }

          // Fetch next vaccines asynchronously
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: (state is BabyLoaded)
                ? _vaccineLocalDataSource.getUpcomingVaccinesForBaby(state.baby.id, limit: 3)
                : Future.value([]),
            builder: (context, snapshot) {
              final vaccines = snapshot.data ?? [];
              upcomingVaccines = vaccines.length;
              if (vaccines.isNotEmpty) {
                // Find the soonest scheduled_date (if set), else use scheduled_age
                final first = vaccines.first;
                if (first['scheduled_date'] != null && first['scheduled_date'] != '') {
                  nextVaccineDate = first['scheduled_date'];
                } else {
                  nextVaccineDate = first['scheduled_age'] ?? '-';
                }
              }
              return SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================== HEADER ====================
                        _buildHeader(),
                        const SizedBox(height: 24),

                        // ==================== BABY CARD ====================
                        _buildBabyCard(
                          babyName: babyName,
                          ageText: _formatAgeText(babyDateOfBirth),
                          nextVaccineDate: nextVaccineDate,
                          upcomingVaccines: upcomingVaccines,
                          growthStatus: growthStatus,
                        ),
                        const SizedBox(height: 20),

                        // ==================== TIPS & DOCTORS ====================
                        _buildQuickActions(),
                        const SizedBox(height: 24),

                        // ==================== UPCOMING SECTION ====================
                        _buildUpcomingSection(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    String userName = 'User';
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile + Greeting (Clickable)
        GestureDetector(
          onTap: () {
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
                  child: const BabySettingsPage(),
                ),
              ),
            ).then((result) {
              // Reload baby profile to get updated gender if changed
              context.read<BabyCubit>().loadBabyProfile();
            });
          },
          child: Row(
            children: [
              // Profile Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting Text
              Text(
                'Hello $userName !',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Notification Bell
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            );
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: primaryColor,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBabyCard({
    required String babyName,
    required String ageText,
    required String nextVaccineDate,
    required int upcomingVaccines,
    required String growthStatus,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.7),
            lightBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baby Avatar + Name + Age
          Row(
            children: [
              // Baby Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              // Name and Age
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      babyName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ageText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Next Vaccine Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Next vaccine: $nextVaccineDate',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Vaccines and Growth Stats
          Row(
            children: [
              // Vaccines Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vaccines',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$upcomingVaccines upcoming',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Growth Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Growth',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      growthStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // More Button
          Center(
            child: GestureDetector(
              onTap: _navigateToTrackPage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'More',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        // Our Tips Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const tips.Tips()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lightbulb icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Our Tips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'follow best practices',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Our Doctors Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => DoctorsBloc(),
                    child: const DoctorsScreen(),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stethoscope icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Our Doctors',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'find the best doctor',
                    style: TextStyle(
                      color: primaryColor.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    // Only show scheduled (not completed) vaccines as upcoming events
    final babyState = context.read<BabyCubit>().state;
    String? babyId;
    if (babyState is BabyLoaded) {
      babyId = babyState.baby.id;
    }
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: babyId != null ? _vaccineLocalDataSource.getUpcomingVaccinesForBaby(babyId, limit: 10) : Future.value([]),
      builder: (context, vaccineSnapshot) {
        final vaccines = vaccineSnapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                // Optionally add a 'see all' button for vaccines
              ],
            ),
            const SizedBox(height: 16),
            if (vaccines.isNotEmpty)
              Column(
                children: vaccines
                    .map((vaccine) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              final userId = _getUserId();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider<BabyCubit>.value(
                                    value: context.read<BabyCubit>(),
                                    child: VaccineTrackerPage(
                                      isGirl: currentBabyGender.toLowerCase() == 'girl' || currentBabyGender.toLowerCase() == 'female',
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: _buildUpcomingCard(
                              icon: Icons.medical_services,
                              iconBgColor: Colors.green.shade300,
                              title: vaccine['vaccine_name'] ?? 'Vaccine',
                              subtitle: vaccine['scheduled_date'] != null && vaccine['scheduled_date'] != ''
                                  ? vaccine['scheduled_date']
                                  : (vaccine['scheduled_age'] ?? ''),
                            ),
                          ),
                        ))
                    .toList(),
              )
            else
              Center(
                child: Text(
                  'No upcoming scheduled vaccines',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
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
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Calendar icon
          Icon(
            Icons.calendar_today_outlined,
            color: primaryColor.withValues(alpha: 0.5),
            size: 20,
          ),
        ],
      ),
    );
  }
}
