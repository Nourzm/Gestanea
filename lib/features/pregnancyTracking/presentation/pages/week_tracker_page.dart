// lib/features/pregnancy/presentation/pages/week_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancyTracking/data/repositories/pregnancy_repository.dart';
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

  int _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return int.tryParse(authState.user.id) ?? 0;
    }
    return 0;
  }

  Future<void> _loadPregnancyData() async {
    final userId = _getUserId();
    if (userId > 0) {
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9B7FDB).withValues(alpha: 0.1),
            const Color(0xFF9B7FDB).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9B7FDB).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Week Circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF9B7FDB),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9B7FDB).withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'WEEK',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '$selectedWeek',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Days Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF9B7FDB),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+$currentDay day${currentDay != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9B7FDB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                trimester,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$daysLeft days to go',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF9B7FDB)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Track',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7FDB),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF9B7FDB),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FetalVisualizationWidget(week: selectedWeek),
              const SizedBox(height: 24),

              // Display current week info (read-only, auto-calculated)
              _buildWeekInfoCard(),
              const SizedBox(height: 24),

              PregnancyProgressBar(
                currentWeek: selectedWeek,
                currentDay: currentDay,
                trimester: trimester,
                daysLeft: daysLeft,
                dueDate: _formatDueDate(),
              ),
              const SizedBox(height: 32),

              const Text(
                'Kick Counter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              const KickCounterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
