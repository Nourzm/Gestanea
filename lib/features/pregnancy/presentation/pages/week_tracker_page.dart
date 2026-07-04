// lib/features/pregnancy/presentation/pages/week_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/flip_counter_3d.dart';
import 'package:gestanea/core/database/models/kick_count_model.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notifications_page.dart';
import 'package:gestanea/features/profile/presentation/pages/profile_page.dart';
import 'package:gestanea/features/pregnancy/data/repositories/pregnancy_repository.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
  // The pregnancy's actual current week (auto-calculated, read-only).
  int currentWeek = 1;
  // The week the user is currently browsing (defaults to current week).
  int selectedWeek = 1;
  int currentDay = 0;
  String trimester = '1st Trimester';
  int daysLeft = 280;
  double progressPercentage = 0;
  DateTime? dueDate;
  bool _isLoading = true;

  int _todayKicks = 0;
  List<KickCountModel> _recentKicks = [];

  final PregnancyRepository _repository = PregnancyRepository();

  bool get _isBrowsing => selectedWeek != currentWeek;

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
    if (userId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final data = await _repository.getPregnancyInfoByStringId(userId);
      if (!mounted) return;
      setState(() {
        currentWeek = data['currentWeek'] ?? 1;
        selectedWeek = currentWeek;
        currentDay = data['currentDay'] ?? 0;
        trimester = data['trimester'] ?? '1st Trimester';
        daysLeft = data['daysLeft'] ?? 280;
        progressPercentage = data['progressPercentage'] ?? 0;
        dueDate = data['dueDate'];
        _isLoading = false;
      });
      await _loadKicks();
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadKicks() async {
    final userId = _getUserId();
    if (userId.isEmpty) return;
    try {
      final total = await _repository.getTodayKickTotalByStringId(userId);
      final recent = await _repository.getKickHistoryByStringId(
        userId,
        limit: 3,
      );
      if (!mounted) return;
      setState(() {
        _todayKicks = total;
        _recentKicks = recent;
      });
    } catch (_) {
      // Non-fatal — history is supplementary.
    }
  }

  @override
  void didPopNext() {
    _loadPregnancyData();
  }

  String _formatDueDate() {
    if (dueDate == null) return AppLocalizations.of(context)!.notSet;
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('MMM dd, yyyy', locale).format(dueDate!);
  }

  String _localizedTrimester() {
    final t = AppLocalizations.of(context)!;
    if (trimester.startsWith('1')) return t.firstTrimester;
    if (trimester.startsWith('2')) return t.secondTrimester;
    if (trimester.startsWith('3')) return t.thirdTrimester;
    return trimester;
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

  // Short, non-clinical "what's happening this week" notes at milestone weeks.
  static const List<int> _noteWeeks = [
    4,
    6,
    8,
    10,
    12,
    14,
    16,
    20,
    24,
    28,
    32,
    36,
    40,
  ];

  String _weeklyNoteFor(int week) {
    final t = AppLocalizations.of(context)!;
    int closest = _noteWeeks.first;
    for (final k in _noteWeeks) {
      if ((k - week).abs() < (closest - week).abs()) closest = k;
    }
    switch (closest) {
      case 4:
        return t.weekNote4;
      case 6:
        return t.weekNote6;
      case 8:
        return t.weekNote8;
      case 10:
        return t.weekNote10;
      case 12:
        return t.weekNote12;
      case 14:
        return t.weekNote14;
      case 16:
        return t.weekNote16;
      case 20:
        return t.weekNote20;
      case 24:
        return t.weekNote24;
      case 28:
        return t.weekNote28;
      case 32:
        return t.weekNote32;
      case 36:
        return t.weekNote36;
      default:
        return t.weekNote40;
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.main300,
            backgroundImage: const AssetImage('assets/images/profile.png'),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.main300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _localizedTrimester(),
            style: const TextStyle(
              color: AppColors.main600,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsPage()),
          ),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: const BoxDecoration(
              color: AppColors.main300,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.main600,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  /// Rounded card holding the current week's days, today highlighted.
  Widget _buildDateStrip() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: now.weekday - 1));
    final locale = Localizations.localeOf(context).languageCode;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final d = monday.add(Duration(days: i));
          final isToday = d == today;
          return Column(
            children: [
              Text(
                DateFormat('EEE', locale).format(d),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isToday ? AppColors.pink600 : AppColors.main400,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isToday
                      ? const LinearGradient(
                          colors: [AppColors.pink400, AppColors.pink500],
                        )
                      : null,
                ),
                child: Text(
                  '${d.day}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isToday ? Colors.white : AppColors.main600,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Soft pastel gradient hero with the animated week ring + baby.
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.main300, AppColors.pink300],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          FetalVisualizationWidget(
            week: selectedWeek,
            showSizeComparison: false,
            showBadge: false,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlipCounter3D(
                value: selectedWeek,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.main700,
                ),
              ),
              Text(
                ' ${AppLocalizations.of(context)!.weeksDaysSuffix(currentDay)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.main700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekPills() {
    final weeks = List.generate(
      5,
      (i) => selectedWeek - 2 + i,
    ).where((w) => w >= 1 && w <= 42).toList();
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
        const SizedBox(height: 8),
        Text(
          _isBrowsing
              ? AppLocalizations.of(context)!.viewingWeek(selectedWeek)
              : AppLocalizations.of(context)!.currentWeekLabel,
          style: const TextStyle(
            color: AppColors.main600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _weekPill(int week, bool isSelected) {
    final bool isActual = week == currentWeek;
    return GestureDetector(
      onTap: () => setState(() => selectedWeek = week),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.main500, AppColors.main600],
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isActual ? AppColors.main600 : AppColors.main300,
            width: isActual ? 2 : 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$week',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.main600,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBrowsingBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.main300,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.main600, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(
                context,
              )!.previewingWeek(selectedWeek, currentWeek),
              style: const TextStyle(
                color: AppColors.main700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => selectedWeek = currentWeek),
            child: Text(
              AppLocalizations.of(context)!.today,
              style: const TextStyle(
                color: AppColors.main600,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeCard() {
    final t = AppLocalizations.of(context)!;
    final m = _metricsFor(selectedWeek);
    return Row(
      children: [
        Expanded(child: _sizeStat(Icons.straighten, t.length, m.$2)),
        const SizedBox(width: 12),
        Expanded(child: _sizeStat(Icons.monitor_weight, t.weight, m.$1)),
      ],
    );
  }

  Widget _sizeStat(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.main300,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.main600, size: 19),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.main400),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.main700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.main300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.main600,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _weeklyNoteFor(selectedWeek),
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKickHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.main500, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.today,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.kicksValue(_todayKicks),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.main600,
                ),
              ),
            ],
          ),
          if (_recentKicks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                AppLocalizations.of(context)!.noKickSessions,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            )
          else ...[
            const Divider(height: 24),
            ..._recentKicks.map(_kickRow),
          ],
        ],
      ),
    );
  }

  Widget _kickRow(KickCountModel k) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.main300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.child_friendly,
              color: AppColors.main600,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.kicksValue(k.kickCount),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  DateFormat(
                    'MMM d, h:mm a',
                    Localizations.localeOf(context).languageCode,
                  ).format(k.recordedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (k.durationMinutes != null)
            Text(
              AppLocalizations.of(context)!.minutesShort(k.durationMinutes!),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bg_1,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.main500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildDateStrip(),
                const SizedBox(height: 20),
                _buildHero(),
                const SizedBox(height: 20),
                _buildWeekPills(),
                const SizedBox(height: 20),
                if (_isBrowsing) _buildBrowsingBanner(),
                _buildSizeCard(),
                const SizedBox(height: 24),
                _sectionTitle(
                  AppLocalizations.of(context)!.whatToExpectWeek(selectedWeek),
                ),
                const SizedBox(height: 12),
                _buildWeeklyNote(),
                const SizedBox(height: 20),
                PregnancyProgressBar(
                  currentWeek: currentWeek,
                  currentDay: currentDay,
                  trimester: trimester,
                  daysLeft: daysLeft,
                  dueDate: _formatDueDate(),
                ),
                const SizedBox(height: 28),
                _sectionTitle(AppLocalizations.of(context)!.kickCounter),
                const SizedBox(height: 16),
                KickCounterWidget(onSessionSaved: _loadKicks),
                const SizedBox(height: 16),
                _buildKickHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
