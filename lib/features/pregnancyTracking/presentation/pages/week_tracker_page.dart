// lib/features/pregnancy/presentation/pages/week_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancyTracking/data/repositories/pregnancy_repository.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/header.dart';
import '../../../../main.dart' show routeObserver;
import '../widgets/fetal_visualization_widget.dart';
import '../widgets/pregnancy_progress_bar.dart';
import '../widgets/kick_counter_widget.dart';

class WeekTrackerPage extends StatefulWidget {
  const WeekTrackerPage({super.key});

  @override
  State<WeekTrackerPage> createState() => _WeekTrackerPageState();
}

class _WeekTrackerPageState extends State<WeekTrackerPage> with RouteAware {
  int selectedWeek = 1;
  int currentDay = 0;
  String trimester = '1st Trimester';
  int daysLeft = 280;
  double progressPercentage = 0;
  DateTime? dueDate;
  bool _isLoading = true;

  final PregnancyRepository _repository = PregnancyRepository();

  @override
  void initState() {
    super.initState();
    _loadPregnancyData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  Future<void> _loadPregnancyData() async {
    final userId = _getUserId();
    if (userId.isNotEmpty) {
      try {
        final data = await _repository.getPregnancyInfo(userId);
        if (mounted) {
          setState(() {
            selectedWeek = data['currentWeek'] ?? 1;
            currentDay = data['currentDay'] ?? 0;
            trimester = data['trimester'] ?? '1st Trimester';
            daysLeft = data['daysLeft'] ?? 280;
            progressPercentage = data['progressPercentage'] ?? 0;
            dueDate = data['dueDate'];
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // When returning from another page, refresh data
  @override
  void didPopNext() {
    _loadPregnancyData();
  }

  String _formatDueDate() {
    if (dueDate == null) return 'Not set';
    final months = [
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
      'Dec',
    ];
    return '${months[dueDate!.month - 1]} ${dueDate!.day.toString().padLeft(2, '0')}, ${dueDate!.year}';
  }

  Widget _buildWeekInfoCard() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_today_rounded,
            value: '$currentDay',
            label: 'Day of Week',
            color: AppColors.main500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.favorite_rounded,
            value: trimester.split(' ')[0],
            label: 'Trimester',
            color: AppColors.pink500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.hourglass_bottom_rounded,
            value: '$daysLeft',
            label: 'Days Left',
            color: const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.main700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textDark.withOpacity(0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.main600),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0FF),
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.main300.withOpacity(0.4),
                    AppColors.main300.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.pink300.withOpacity(0.2),
                    AppColors.pink300.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Header(
                  title: 'Pregnancy Tracker',
                  showBackButton: false,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _loadPregnancyData();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FetalVisualizationWidget(week: selectedWeek),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Statistics'),
                          const SizedBox(height: 12),
                          _buildWeekInfoCard(),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Your Progress'),
                          const SizedBox(height: 12),
                          PregnancyProgressBar(
                            currentWeek: selectedWeek,
                            currentDay: currentDay,
                            trimester: trimester,
                            daysLeft: daysLeft,
                            dueDate: _formatDueDate(),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Baby Movements'),
                          const SizedBox(height: 12),
                          const KickCounterWidget(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.main700,
        letterSpacing: -0.5,
      ),
    );
  }
}
