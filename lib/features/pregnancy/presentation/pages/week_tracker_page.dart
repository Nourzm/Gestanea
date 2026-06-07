// lib/features/pregnancy/presentation/pages/week_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancy/data/repositories/pregnancy_repository.dart';
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
        final data = await _repository.getPregnancyInfoByStringId(userId);
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
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dueDate!.month - 1]} ${dueDate!.day.toString().padLeft(2, '0')}, ${dueDate!.year}';
  }

  // Weight/length estimates per gestational week. Approximate ACOG-style
  // ranges — surfaced as a quick reference, not a medical claim.
  static const Map<int, (String weight, String length)> _fetalMetrics = {
    4: ('< 1 g', '0.4 cm'),
    8: ('1 g', '1.6 cm'),
    12: ('14 g', '5.4 cm'),
    16: ('100 g', '11.6 cm'),
    20: ('300 g', '25.6 cm'),
    24: ('600 g', '30 cm'),
    28: ('1.0 kg', '37.6 cm'),
    32: ('1.7 kg', '42.4 cm'),
    36: ('2.6 kg', '47.4 cm'),
    40: ('3.5 kg', '51.2 cm'),
  };

  (String, String) _metricsFor(int week) {
    final keys = _fetalMetrics.keys.toList()..sort();
    int closest = keys.first;
    for (final k in keys) {
      if ((k - week).abs() < (closest - week).abs()) closest = k;
    }
    return _fetalMetrics[closest]!;
  }

  Widget _buildWeightLengthRow() {
    final m = _metricsFor(selectedWeek);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _metricColumn('Weight', m.$1, CrossAxisAlignment.start),
        _metricColumn('Length', m.$2, CrossAxisAlignment.end),
      ],
    );
  }

  Widget _metricColumn(String label, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.main600,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.main500,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekPills() {
    final weeks = List.generate(5, (i) => selectedWeek - 2 + i)
        .where((w) => w >= 1 && w <= 42)
        .toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final w in weeks) ...[
              _weekPill(w, w == selectedWeek),
              const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Current Week',
          style: TextStyle(
            color: AppColors.main600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _weekPill(int week, bool isCurrent) {
    return GestureDetector(
      onTap: () => setState(() => selectedWeek = week),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isCurrent
              ? const LinearGradient(
                  colors: [AppColors.main500, AppColors.main600],
                )
              : null,
          color: isCurrent ? null : Colors.white,
          border: isCurrent
              ? null
              : Border.all(color: AppColors.main300, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          '$week',
          style: TextStyle(
            color: isCurrent ? Colors.white : AppColors.main600,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
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
          child: CircularProgressIndicator(
            color: Color(0xFF9B7FDB),
          ),
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
              _buildWeightLengthRow(),
              const SizedBox(height: 12),
              FetalVisualizationWidget(week: selectedWeek),
              const SizedBox(height: 16),
              _buildWeekPills(),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
