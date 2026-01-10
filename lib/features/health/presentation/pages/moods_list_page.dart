import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/models/mood_model.dart';
import '../../logic/bloc/moods_bloc.dart';
import '../../logic/bloc/moods_state.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class MoodsListPage extends StatelessWidget {
  const MoodsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Moods'),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MoodsBloc, MoodsState>(
        builder: (context, state) {
          if (state is MoodsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoodsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          }

          if (state is MoodsLoaded) {
            if (state.moods.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No moods logged yet!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Tap "Log Mood" to start.'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.moods.length,
              itemBuilder: (context, index) {
                final mood = state.moods[index];
                return _buildMoodCard(mood);
              },
            );
          }

          return const Center(child: Text('No data'));
        },
      ),
    );
  }

  Widget _buildMoodCard(MoodModel mood) {
    final Color cardColor = _getMoodColor(mood.mood);
    final String emoji = _getMoodEmoji(mood.mood);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mood.mood,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (mood.intensity != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < mood.intensity!
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(mood.recordedAt),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            if (mood.notes != null && mood.notes!.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                mood.notes!,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getMoodEmoji(String mood) {
    final moodLower = mood.toLowerCase();
    if (moodLower.contains('great') || moodLower.contains('amazing') || moodLower.contains('excellent')) {
      return '😄';
    } else if (moodLower.contains('good') || moodLower.contains('happy') || moodLower.contains('joyful')) {
      return '😊';
    } else if (moodLower.contains('okay') || moodLower.contains('neutral') || moodLower.contains('fine')) {
      return '😐';
    } else if (moodLower.contains('sad') || moodLower.contains('down') || moodLower.contains('low')) {
      return '😔';
    } else if (moodLower.contains('very sad') || moodLower.contains('terrible') || moodLower.contains('awful')) {
      return '😢';
    } else if (moodLower.contains('calm') || moodLower.contains('relaxed') || moodLower.contains('peaceful')) {
      return '😌';
    } else if (moodLower.contains('tired') || moodLower.contains('exhausted') || moodLower.contains('sleepy')) {
      return '😴';
    }
    return '😊'; // default
  }

  Color _getMoodColor(String mood) {
    final moodLower = mood.toLowerCase();
    if (moodLower.contains('great') || moodLower.contains('amazing') || moodLower.contains('excellent')) {
      return const Color(0xFFFFF9C4); // Yellow
    } else if (moodLower.contains('good') || moodLower.contains('happy') || moodLower.contains('joyful')) {
      return const Color(0xFFFFF9C4); // Yellow
    } else if (moodLower.contains('okay') || moodLower.contains('neutral') || moodLower.contains('fine')) {
      return const Color(0xFFE0E0E0); // Gray
    } else if (moodLower.contains('sad') || moodLower.contains('down') || moodLower.contains('low')) {
      return const Color(0xFFE1F5FE); // Light Blue
    } else if (moodLower.contains('very sad') || moodLower.contains('terrible') || moodLower.contains('awful')) {
      return const Color(0xFFE8EAF6); // Light Purple
    } else if (moodLower.contains('calm') || moodLower.contains('relaxed') || moodLower.contains('peaceful')) {
      return const Color(0xFFE1F5FE); // Light Blue
    } else if (moodLower.contains('tired') || moodLower.contains('exhausted') || moodLower.contains('sleepy')) {
      return const Color(0xFFE8EAF6); // Light Purple
    }
    return const Color(0xFFFFF9C4); // default yellow
  }
}
