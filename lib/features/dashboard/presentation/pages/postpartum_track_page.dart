import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/gradient_ring.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/database/models/feeding_log_model.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:gestanea/features/baby/logic/repositories/baby_repository.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Import your pages
import '../../../baby/presentation/pages/feeding_log_page.dart';
import '../../../baby/presentation/pages/growth_tracker_page.dart';
import '../../../baby/presentation/pages/milestone_tracker_page.dart';
import '../../../baby/presentation/pages/vaccine_tracker_page.dart';

class PostpartumTrackPage extends StatefulWidget {
  final String babyGender;

  const PostpartumTrackPage({super.key, required this.babyGender});

  @override
  State<PostpartumTrackPage> createState() => _PostpartumTrackPageState();
}

class _PostpartumTrackPageState extends State<PostpartumTrackPage> {
  bool get _isGirl => widget.babyGender.toLowerCase() == 'girl';

  Color get _primary => _isGirl ? AppColors.pink500 : AppColors.blue500;
  Color get _primaryDark => _isGirl ? AppColors.pink600 : AppColors.blue600;
  Color get _soft => _isGirl ? AppColors.pink300 : AppColors.blue300;

  @override
  void initState() {
    super.initState();
    // The dashboard-level BabyCubit is created without loading; make sure the
    // profile is fetched so the summary cards have data.
    final cubit = context.read<BabyCubit>();
    if (cubit.state is BabyInitial) {
      cubit.loadBabyProfile();
    }
  }

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  void _navigateWithBabyCubit(BuildContext context, Widget page) {
    final userId = _getUserId(context);
    // Capture before the async gap so we don't use context afterwards.
    final dashboardBabyCubit = context.read<BabyCubit>();
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
          child: page,
        ),
      ),
    ).then((_) {
      // Refresh summary data after returning from a sub-page.
      if (mounted) dashboardBabyCubit.loadBabyProfile();
    });
  }

  Future<void> _showQuickAddFeeding(String babyId) async {
    final t = AppLocalizations.of(context)!;
    final dashboardBabyCubit = context.read<BabyCubit>();
    String type = 'Breastfeed';
    final amountController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final bool isBottle = type == 'Bottle';
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.purpleGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      t.logAFeed,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _typeChip(
                            label: t.breastfeed,
                            icon: Icons.child_care,
                            selected: !isBottle,
                            onTap: () =>
                                setSheetState(() => type = 'Breastfeed'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _typeChip(
                            label: t.bottle,
                            icon: Icons.baby_changing_station,
                            selected: isBottle,
                            onTap: () => setSheetState(() => type = 'Bottle'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isBottle
                            ? t.amountMlOptional
                            : t.durationMinOptional,
                        filled: true,
                        fillColor: AppColors.bg_1,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () async {
                          final raw = double.tryParse(amountController.text);
                          await _logFeed(
                            babyId: babyId,
                            type: type,
                            amountMl: isBottle ? raw : null,
                            durationMinutes: !isBottle ? raw?.toInt() : null,
                          );
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                        child: Text(
                          t.saveUpper,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    amountController.dispose();
    // Refresh the summary cards with the new feed.
    if (mounted) {
      dashboardBabyCubit.loadBabyProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.feedLogged), backgroundColor: _primaryDark),
      );
    }
  }

  Future<void> _logFeed({
    required String babyId,
    required String type,
    double? amountMl,
    int? durationMinutes,
  }) async {
    final repo = BabyRepository(BabyLocalDataSource(DatabaseHelper.instance));
    final now = DateTime.now();
    await repo.addFeedingLog(
      FeedingLogModel(
        id: const Uuid().v4(),
        babyId: babyId,
        feedingType: type,
        durationMinutes: durationMinutes,
        amountMl: amountMl,
        loggedAt: now,
        createdAt: now,
      ),
    );
  }

  Widget _typeChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _primary.withValues(alpha: 0.15) : AppColors.bg_1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _primaryDark : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: _primaryDark, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? _primaryDark : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _ageInMonths(DateTime dob) {
    final now = DateTime.now();
    return (now.year - dob.year) * 12 + (now.month - dob.month);
  }

  String _formatAge(int months) {
    final t = AppLocalizations.of(context)!;
    if (months <= 0) return t.ageNewborn;
    if (months < 12) return t.ageMonths(months);
    final years = months ~/ 12;
    final rem = months % 12;
    return rem == 0 ? t.ageYears(years) : t.ageYearsMonths(years, rem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      floatingActionButton: BlocBuilder<BabyCubit, BabyState>(
        builder: (context, state) {
          if (state is! BabyLoaded) return const SizedBox.shrink();
          final babyId = state.baby.id;
          return FloatingActionButton.extended(
            onPressed: () => _showQuickAddFeeding(babyId),
            backgroundColor: _primaryDark,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.logFeed),
          );
        },
      ),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.trackTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: _primaryDark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocBuilder<BabyCubit, BabyState>(
          builder: (context, state) {
            if (state is BabyLoading || state is BabyInitial) {
              return Center(child: CircularProgressIndicator(color: _primary));
            }
            if (state is NoBabyProfile) {
              return _buildEmpty();
            }

            BabyModel? baby;
            List<FeedingLogModel> feedingLogs = const [];
            int milestonesAchieved = 0;
            int milestonesTotal = 0;
            double? latestWeight;
            if (state is BabyLoaded) {
              baby = state.baby;
              feedingLogs = state.feedingLogs;
              milestonesTotal = state.milestones.length;
              milestonesAchieved = state.milestones
                  .where((m) => m.achievedDate != null)
                  .length;
              latestWeight = state.latestGrowth?.weight;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (baby != null) _buildBabyHeader(baby),
                  const SizedBox(height: 20),
                  _buildBabyProgress(
                    achieved: milestonesAchieved,
                    total: milestonesTotal,
                    latestWeight: latestWeight,
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryRow(
                    feedingLogs: feedingLogs,
                    latestWeight: latestWeight,
                    milestonesAchieved: milestonesAchieved,
                    milestonesTotal: milestonesTotal,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.trackingTools,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildToolsGrid(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBabyHeader(BabyModel baby) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary, _primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            child: const Icon(Icons.child_care, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baby.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatAge(_ageInMonths(baby.dateOfBirth)),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabyProgress({
    required int achieved,
    required int total,
    required double? latestWeight,
  }) {
    final double ratio = total > 0 ? achieved / total : 0.0;
    final int pct = (ratio * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          // 3D-tilted animated progress ring
          SizedBox(
            width: 120,
            height: 120,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015) // perspective
                ..rotateX(0.18), // tilt the dial back in space
              child: AnimatedGradientRing(
                progress: ratio,
                size: 120,
                strokeWidth: 12,
                colors: _isGirl
                    ? const [
                        AppColors.pink300,
                        AppColors.pink500,
                        AppColors.pink600,
                      ]
                    : const [
                        AppColors.blue300,
                        AppColors.blue500,
                        AppColors.blue600,
                      ],
                trackColor: _isGirl ? AppColors.pink200 : AppColors.blue200,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: pct.toDouble()),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => Text(
                    '${value.round()}%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.babyProgress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  total > 0
                      ? AppLocalizations.of(
                          context,
                        )!.milestonesReached(achieved, total)
                      : AppLocalizations.of(context)!.noMilestonesYet,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                if (latestWeight != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (_isGirl ? AppColors.pink200 : AppColors.blue200),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.latestWeightValue(latestWeight.toStringAsFixed(1)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _primaryDark,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required List<FeedingLogModel> feedingLogs,
    required double? latestWeight,
    required int milestonesAchieved,
    required int milestonesTotal,
  }) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final feedsToday = feedingLogs
        .where(
          (f) =>
              f.loggedAt.year == now.year &&
              f.loggedAt.month == now.month &&
              f.loggedAt.day == now.day,
        )
        .length;
    final lastFeed = feedingLogs.isNotEmpty
        ? DateFormat('h:mm a', locale).format(feedingLogs.first.loggedAt)
        : '—';

    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon: Icons.local_drink,
            value: '$feedsToday',
            label: t.feedsToday,
            sub: feedingLogs.isNotEmpty ? t.lastFeedAt(lastFeed) : t.noFeedsYet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            icon: Icons.monitor_weight,
            value: latestWeight != null
                ? '${latestWeight.toStringAsFixed(1)}kg'
                : '—',
            label: t.latestWeight,
            sub: latestWeight != null ? t.recorded : t.notSet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            icon: Icons.flag,
            value: '$milestonesAchieved/$milestonesTotal',
            label: t.milestonesLabel,
            sub: t.achievedLabel,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String value,
    required String label,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.shadow1,
      ),
      child: Column(
        children: [
          Icon(icon, color: _primaryDark, size: 24),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            sub,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsGrid() {
    final t = AppLocalizations.of(context)!;
    final tools = [
      _Tool(
        title: t.feedingLogTitle,
        subtitle: t.feedingLogSub,
        icon: Icons.local_drink,
        color: _primary,
        page: () => const FeedingLogPage(),
      ),
      _Tool(
        title: t.growthTrackerTitle,
        subtitle: t.growthTrackerSub,
        icon: Icons.monitor_weight,
        color: _primaryDark,
        page: () => const GrowthTrackerPage(),
      ),
      _Tool(
        title: t.milestonesLabel,
        subtitle: t.milestonesSub,
        icon: Icons.flag,
        color: _isGirl ? AppColors.pink400 : AppColors.blue400,
        page: () => const MilestoneTrackerPage(),
      ),
      _Tool(
        title: t.vaccinesTitle,
        subtitle: t.vaccinesSub,
        icon: Icons.vaccines,
        color: _isGirl ? AppColors.pink600 : AppColors.blue600,
        page: () => VaccineTrackerPage(isGirl: _isGirl),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.15,
      children: tools.map(_toolCard).toList(),
    );
  }

  Widget _toolCard(_Tool tool) {
    return GestureDetector(
      onTap: () => _navigateWithBabyCubit(context, tool.page()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppColors.shadow1,
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(tool.icon, size: 30, color: tool.color),
            ),
            const SizedBox(height: 14),
            Text(
              tool.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tool.subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.child_care, size: 64, color: _soft),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noBabyProfile,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.addBabyPrompt,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tool {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() page;

  _Tool({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });
}
