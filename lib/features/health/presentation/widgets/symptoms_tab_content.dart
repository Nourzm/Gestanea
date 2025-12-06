import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../logic/bloc/symptoms_bloc.dart';
import '../../logic/bloc/symptoms_state.dart';
import '../pages/symptoms_list_page.dart';
import 'dialogs/add_symptom_dialog.dart';

class SymptomsTabContent extends StatelessWidget {
  const SymptomsTabContent({super.key});

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
                // Recent Symptoms
                Text(
                  localizations.recentSymptoms,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Dynamic Symptom Cards from Database
                BlocBuilder<SymptomsBloc, SymptomsState>(
                  builder: (context, state) {
                    if (state is SymptomsLoaded) {
                      if (state.symptoms.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'No symptoms logged yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      
                      // Show only the 4 most recent symptoms
                      final recentSymptoms = state.symptoms.take(4).toList();
                      return Column(
                        children: recentSymptoms.map((symptom) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildSymptomCard(
                              context,
                              icon: _getSymptomIcon(symptom. symptomName),
                              symptom: symptom. symptomName,
                              severity: symptom.severity ??  'N/A',
                              severityColor: _getSeverityColor(symptom. severity),
                              time: _formatTime(symptom.recordedAt),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),

                const SizedBox(height: 20),

                // Add Symptom Button
                _buildAddSymptomButton(context),

                const SizedBox(height: 20),

                // View All Button
                Builder(
                  builder: (btnContext) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton. icon(
                        onPressed: () {
                          Navigator.push(
                            btnContext,
                            MaterialPageRoute(
                              builder: (navContext) => BlocProvider.value(
                                value: btnContext.read<SymptomsBloc>(),
                                child: const SymptomsListPage(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('View All Symptoms'),
                        style: ElevatedButton. styleFrom(
                          backgroundColor: AppColors.main500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  }
                ),

                const SizedBox(height: 20),

                // Symptom Frequency Chart
                _buildFrequencyChart(context),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(localizations. commonSymptomsWeek24),
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

  IconData _getSymptomIcon(String symptom) {
    final lowerSymptom = symptom.toLowerCase();
    if (lowerSymptom.contains('pain') || lowerSymptom.contains('back')) {
      return Icons.airline_seat_flat;
    } else if (lowerSymptom.contains('sleep')) {
      return Icons.nights_stay;
    } else if (lowerSymptom.contains('swell') || lowerSymptom.contains('feet')) {
      return Icons.water_drop;
    } else if (lowerSymptom.contains('heart')) {
      return Icons.food_bank;
    } else if (lowerSymptom.contains('head')) {
      return Icons.psychology;
    } else if (lowerSymptom.contains('nausea')) {
      return Icons.sick;
    }
    return Icons.health_and_safety;
  }

  Color _getSeverityColor(String?  severity) {
    switch (severity?. toLowerCase()) {
      case 'mild':
        return const Color(0xFFFFF3CD);
      case 'moderate':
        return const Color(0xFFFFE0B2);
      case 'severe':
        return const Color(0xFFFFB8B8);
      default:
        return const Color(0xFFFFF3CD);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd'). format(dateTime);
    }
  }

  Widget _buildSymptomCard(
    BuildContext context, {
    required IconData icon,
    required String symptom,
    required String severity,
    required Color severityColor,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors. main300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors. main500, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symptom,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTextStyles.smallLabel.copyWith(
                    fontSize: 11,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              severity,
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 11,
                color: const Color(0xFF856404),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSymptomButton(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Builder(
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            final bloc = ctx.read<SymptomsBloc>();
            showModalBottomSheet(
              context: ctx,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (dialogContext) => AddSymptomDialog(bloc: bloc),
            );
          },
          child: Container(
            padding: const EdgeInsets. all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.pink600, AppColors.pink500],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  localizations.logNewSymptom,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildFrequencyChart(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors. white,
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
            localizations.symptomFrequency,
            style: AppTextStyles.subtitle1.copyWith(
              fontSize: 14,
              color: AppColors. textDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildFrequencyBar(context, localizations. backPain, 0.85),
          const SizedBox(height: 10),
          _buildFrequencyBar(context, localizations.swollenFeet, 0.6),
          const SizedBox(height: 10),
          _buildFrequencyBar(context, localizations.heartburn, 0.5),
          const SizedBox(height: 10),
          _buildFrequencyBar(context, localizations.sleepIssues, 0.7),
        ],
      ),
    );
  }

  Widget _buildFrequencyBar(BuildContext context, String label, double value) {
    final localizations = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 12,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '${(value * 7).toInt()} ${localizations.times}',
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 11,
                color: AppColors. textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.main300,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.main500),
            ),
          ),
        ),
      ],
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