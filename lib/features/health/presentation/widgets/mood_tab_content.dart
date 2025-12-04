import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'dialogs/add_mood_dialog.dart';

class MoodTabContent extends StatelessWidget {
  const MoodTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Mood
                Text(
                  'How are you feeling today?',
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Mood Selector
                _buildMoodSelector(),

                const SizedBox(height: 20),

                // Recent Mood Entries
                Text(
                  'Recent Entries',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                _buildMoodEntryCard(
                  emoji: '😊',
                  mood: 'Happy',
                  note: 'Felt energetic today',
                  time: '2 hours ago',
                  color: const Color(0xFFFFF9C4),
                ),
                const SizedBox(height: 12),
                _buildMoodEntryCard(
                  emoji: '😌',
                  mood: 'Calm',
                  note: 'Relaxing evening',
                  time: 'Yesterday',
                  color: const Color(0xFFE1F5FE),
                ),
                const SizedBox(height: 12),
                _buildMoodEntryCard(
                  emoji: '😴',
                  mood: 'Tired',
                  note: 'Need more sleep',
                  time: '2 days ago',
                  color: const Color(0xFFE8EAF6),
                ),

                const SizedBox(height: 20),

                // Mood Trends
                _buildMoodTrendsCard(),

                const SizedBox(height: 20),

                // Self-Care Suggestions
                _buildSelfCareCard(),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(
                  'Tracking your mood helps identify patterns and manage emotional wellbeing during pregnancy.',
                ),
              ],
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
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

  Widget _buildMoodSelector() {
    final moods = [
      {'emoji': '😄', 'label': 'Great'},
      {'emoji': '😊', 'label': 'Good'},
      {'emoji': '😐', 'label': 'Okay'},
      {'emoji': '😔', 'label': 'Low'},
      {'emoji': '😢', 'label': 'Sad'},
    ];

    return GestureDetector(
      onTap: () {
        showAddMoodDialog(context);
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
                Text(
                  mood['emoji']!,
                  style: const TextStyle(fontSize: 32),
                ),
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

  Widget _buildMoodEntryCard({
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
          Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
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

  Widget _buildMoodTrendsCard() {
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
            'Mood Trends (Last 7 Days)',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodTrendItem('😄', '2'),
              _buildMoodTrendItem('😊', '3'),
              _buildMoodTrendItem('😐', '1'),
              _buildMoodTrendItem('😔', '1'),
              _buildMoodTrendItem('😢', '0'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Mostly positive moods this week! 🌟',
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
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
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

  Widget _buildSelfCareCard() {
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
                'Self-Care Suggestions',
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSelfCareItem('Take a short walk'),
          _buildSelfCareItem('Practice deep breathing'),
          _buildSelfCareItem('Listen to calming music'),
          _buildSelfCareItem('Connect with loved ones'),
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