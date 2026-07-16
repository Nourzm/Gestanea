import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../logic/bloc/moods_bloc.dart';
import '../../logic/bloc/moods_state.dart';
import '../../logic/bloc/moods_event.dart';
import '../pages/moods_list_page.dart';
import 'dialogs/add_mood_dialog.dart';
import 'ai_health_insights_card.dart';

class MoodTabContent extends StatelessWidget {
  const MoodTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<MoodsBloc>().add(LoadMoods());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

                  // Mood Selector
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

                  // Dynamic Mood Cards from Database
                  BlocBuilder<MoodsBloc, MoodsState>(
                    builder: (context, state) {
                      if (state is MoodsLoaded) {
                        if (state.moods.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                l10n.noMoodsLogged,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        // Show only the 3 most recent moods
                        final recentMoods = state.moods.take(3).toList();
                        return Column(
                          children: recentMoods.map((mood) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildMoodEntryCard(
                                context,
                                emoji: _getMoodEmoji(mood.mood, l10n),
                                mood: mood.mood,
                                note: mood.notes ?? l10n.noNotes,
                                time: _formatTime(mood.recordedAt, l10n),
                                color: _getMoodColor(mood.mood, l10n),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

                  const SizedBox(height: 20),

                  // View All Button
                  Builder(
                    builder: (btnContext) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              btnContext,
                              MaterialPageRoute(
                                builder: (navContext) => BlocProvider.value(
                                  value: btnContext.read<MoodsBloc>(),
                                  child: const MoodsListPage(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.list),
                          label: Text(AppLocalizations.of(context)!.viewAllMoods),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeData.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Mood Trends
                  _buildMoodTrendsCard(context),

                  const SizedBox(height: 20),

                  // AI Mood Insights
                  BlocBuilder<MoodsBloc, MoodsState>(
                    builder: (context, state) {
                      final moods = state is MoodsLoaded ? state.moods : [];
                      
                      // Count mood distribution
                      final moodCounts = <String, int>{};
                      for (final mood in moods) {
                        moodCounts[mood.mood] = (moodCounts[mood.mood] ?? 0) + 1;
                      }
                      
                      return AIHealthInsightsCard(
                        healthData: {
                          'moodCounts': moodCounts,
                          'pregnancyWeek': 20, // TODO: Get from user profile
                        },
                        insightType: 'moods',
                        language: l10n.localeName,
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
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
      {'emoji': '😄', 'label': l10n.great, 'name': l10n.great},
      {'emoji': '😊', 'label': l10n.good, 'name': l10n.good},
      {'emoji': '😐', 'label': l10n.okay, 'name': l10n.okay},
      {'emoji': '😔', 'label': l10n.sad, 'name': l10n.sad},
      {'emoji': '😢', 'label': l10n.verySad, 'name': l10n.verySad},
    ];

    return Container(
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
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (modalContext) => AddMoodDialog(
                  bloc: context.read<MoodsBloc>(),
                  initialMood: mood['name']!,
                ),
              );
            },
            child: Column(
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
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMoodEntryCard(
    BuildContext context, {
    required String emoji,
    required String mood,
    required String note,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
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
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mood,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 12,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 11,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return BlocBuilder<MoodsBloc, MoodsState>(
      builder: (context, state) {
        if (state is! MoodsLoaded || state.moods.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [themeData.primaryColor, themeData.lightColor],
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
                Text(
                  l10n.noMoodDataAvailable,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        // Calculate frequency of each mood
        final Map<String, int> moodCounts = {
          '😄': 0,
          '😊': 0,
          '😐': 0,
          '😔': 0,
          '😢': 0,
        };

        for (final mood in state.moods) {
          final emoji = _getMoodEmoji(mood.mood, l10n);
          moodCounts[emoji] = (moodCounts[emoji] ?? 0) + 1;
        }

        // Calculate positivity
        final positiveCount = (moodCounts['😄'] ?? 0) + (moodCounts['😊'] ?? 0);
        final total = state.moods.length;
        final isPositive = positiveCount > total / 2;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeData.primaryColor, themeData.lightColor],
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
                children: [
                  _buildMoodTrendItem('😄', '${moodCounts['😄']}'),
                  _buildMoodTrendItem('😊', '${moodCounts['😊']}'),
                  _buildMoodTrendItem('😐', '${moodCounts['😐']}'),
                  _buildMoodTrendItem('😔', '${moodCounts['😔']}'),
                  _buildMoodTrendItem('😢', '${moodCounts['😢']}'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isPositive ? l10n.mostlyPositiveMoods : l10n.mixedMoodsCareMessage,
                style: AppTextStyles.smallLabel.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
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

  String _getMoodEmoji(String mood, AppLocalizations l10n) {
    final moodLower = mood.toLowerCase();
    // Check against localized mood names
    if (moodLower.contains(l10n.great.toLowerCase())) {
      return '😄';
    } else if (moodLower.contains(l10n.good.toLowerCase())) {
      return '😊';
    } else if (moodLower.contains(l10n.okay.toLowerCase())) {
      return '😐';
    } else if (moodLower.contains(l10n.verySad.toLowerCase())) {
      return '😢';
    } else if (moodLower.contains(l10n.sad.toLowerCase())) {
      return '😔';
    }
    return '😊'; // default
  }

  Color _getMoodColor(String mood, AppLocalizations l10n) {
    final moodLower = mood.toLowerCase();
    // Check against localized mood names
    if (moodLower.contains(l10n.great.toLowerCase())) {
      return const Color(0xFFFFF9C4); // Yellow
    } else if (moodLower.contains(l10n.good.toLowerCase())) {
      return const Color(0xFFFFF9C4); // Yellow
    } else if (moodLower.contains(l10n.okay.toLowerCase())) {
      return const Color(0xFFE0E0E0); // Gray
    } else if (moodLower.contains(l10n.verySad.toLowerCase())) {
      return const Color(0xFFE8EAF6); // Light Purple
    } else if (moodLower.contains(l10n.sad.toLowerCase())) {
      return const Color(0xFFE1F5FE); // Light Blue
    }
    return const Color(0xFFFFF9C4); // default yellow
  }

  String _formatTime(DateTime dateTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return l10n.minAgoShort(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.hoursAgoShort(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.daysAgoShort(difference.inDays);
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }
}
