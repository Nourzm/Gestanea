import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/mood_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/bloc/mood_bloc.dart';
import '../../logic/bloc/mood_state.dart';
import 'dialogs/add_mood_dialog.dart';

class MoodTabContent extends StatelessWidget {
  const MoodTabContent({super.key});

  /// Localized display label for a canonical mood key.
  String _moodLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'very_happy':
        return l10n.veryHappy;
      case 'happy':
        return l10n.happy;
      case 'neutral':
        return l10n.neutral;
      case 'sad':
        return l10n.sad;
      case 'very_sad':
        return l10n.verySad;
      default:
        return key;
    }
  }

  Color _moodColor(String key) {
    switch (key) {
      case 'very_happy':
        return const Color(0xFFFFF9C4);
      case 'happy':
        return const Color(0xFFE8F5E9);
      case 'neutral':
        return const Color(0xFFE1F5FE);
      case 'sad':
        return const Color(0xFFE8EAF6);
      case 'very_sad':
        return const Color(0xFFFCE4EC);
      default:
        return const Color(0xFFE1F5FE);
    }
  }

  String _relativeTime(DateTime when, AppLocalizations l10n) {
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes < 1 ? 1 : diff.inMinutes);
    }
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.yesterday;
    return l10n.daysAgo(diff.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: BlocBuilder<MoodBloc, MoodState>(
            builder: (context, state) {
              final moods = state is MoodLoaded
                  ? state.moods
                  : const <MoodModel>[];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Mood
                    Text(
                      l10n.howAreYouFeelingToday,
                      style: AppTextStyles.headline2.copyWith(
                        fontSize: 18,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mood Selector (opens the logging dialog)
                    _buildMoodSelector(context),
                    const SizedBox(height: 20),

                    // Recent Mood Entries
                    Text(
                      l10n.recentEntries,
                      style: AppTextStyles.subtitle1.copyWith(
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (moods.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            l10n.noEntriesYet,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...moods
                          .take(3)
                          .map((m) => _buildMoodEntryCard(context, m, l10n)),

                    const SizedBox(height: 20),

                    // Mood Trends (last 7 days)
                    _buildMoodTrendsCard(context, moods),

                    const SizedBox(height: 20),

                    // Self-Care Suggestions
                    _buildSelfCareCard(context),

                    const SizedBox(height: 16),

                    // Tip Card
                    _buildTipCard(l10n.trackingMoodHelps),
                  ],
                ),
              );
            },
          ),
        ),

        // TOP inset shadow
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // LEFT inset shadow
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final moods = [
      {'emoji': '😄', 'label': l10n.great},
      {'emoji': '😊', 'label': l10n.good},
      {'emoji': '😐', 'label': l10n.okay},
      {'emoji': '😔', 'label': l10n.sad},
      {'emoji': '😢', 'label': l10n.verySad},
    ];

    return GestureDetector(
      onTap: () {
        final bloc = context.read<MoodBloc>();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AddMoodDialog(bloc: bloc),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(2, 2),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.white,
              blurRadius: 6,
              offset: Offset(-3, -3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: moods.map((mood) {
            return Column(
              children: [
                Text(mood['emoji']!, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 4),
                Text(
                  mood['label']!,
                  style: AppTextStyles.smallLabel.copyWith(
                    fontSize: 11,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMoodEntryCard(
    BuildContext context,
    MoodModel mood,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _moodColor(mood.mood),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _moodLabel(mood.mood, l10n),
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (mood.notes != null && mood.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    mood.notes!,
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 12,
                      color: AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            _relativeTime(mood.recordedAt, l10n),
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 11,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendsCard(BuildContext context, List<MoodModel> moods) {
    final l10n = AppLocalizations.of(context)!;

    // Count entries per mood over the last 7 days.
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final recent = moods.where((m) => m.recordedAt.isAfter(cutoff)).toList();
    final counts = <String, int>{for (final k in MoodModel.keys) k: 0};
    for (final m in recent) {
      if (counts.containsKey(m.mood)) counts[m.mood] = counts[m.mood]! + 1;
    }

    final positive = counts['very_happy']! + counts['happy']!;
    final negative = counts['sad']! + counts['very_sad']!;
    final caption = recent.isEmpty
        ? l10n.logMoodToSeeTrends
        : (positive >= negative
              ? l10n.mostlyPositiveMoods
              : l10n.takeCareYourself);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.main500, Color(0xFFB388CC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.moodTrendsLast7Days,
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MoodModel.keys
                .map(
                  (k) => _buildMoodTrendItem(
                    MoodModel.emojis[k]!,
                    counts[k].toString(),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            caption,
            style: AppTextStyles.smallLabel.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendItem(String emoji, String count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count,
            style: AppTextStyles.smallLabel.copyWith(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelfCareCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.spa, color: Color(0xFF2E7D32), size: 24),
              const SizedBox(width: 8),
              Text(
                l10n.selfCareSuggestions,
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSelfCareItem(l10n.takeShortWalk),
          _buildSelfCareItem(l10n.practiceDeepBreathing),
          _buildSelfCareItem(l10n.listenToCalmingMusic),
          _buildSelfCareItem(l10n.connectWithLovedOnes),
        ],
      ),
    );
  }

  Widget _buildSelfCareItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.body1.copyWith(
              fontSize: 12,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        message,
        style: AppTextStyles.body1.copyWith(
          color: const Color(0xFF7B4BA6),
          fontSize: 12,
        ),
      ),
    );
  }
}
