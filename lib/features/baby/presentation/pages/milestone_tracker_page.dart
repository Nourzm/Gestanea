// =============================================================================
// FILE: presentation/pages/milestone_tracker_page.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/milestone_model.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:intl/intl.dart';

class MilestoneTrackerPage extends StatefulWidget {
  final String? babyId;
  
  const MilestoneTrackerPage({super.key, this.babyId});

  @override
  State<MilestoneTrackerPage> createState() => _MilestoneTrackerPageState();
}

class _MilestoneTrackerPageState extends State<MilestoneTrackerPage> {
  // Default milestones if none exist in database
  static const List<Map<String, dynamic>> defaultMilestones = [
    {'title': 'First Smile', 'age': 6},
    {'title': 'Holds Head Up', 'age': 2},
    {'title': 'Rolls Over', 'age': 4},
    {'title': 'Sits Without Support', 'age': 6},
    {'title': 'Crawls', 'age': 8},
    {'title': 'First Words', 'age': 12},
  ];

  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Check if baby profile is already loaded
    final cubit = context.read<BabyCubit>();
    if (cubit.currentBabyId != null) {
      cubit.loadMilestones();
      _hasLoadedData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: BlocConsumer<BabyCubit, BabyState>(
          listener: (context, state) {
            // When baby profile is loaded, load milestones
            if (state is BabyLoaded && !_hasLoadedData) {
              _hasLoadedData = true;
              context.read<BabyCubit>().loadMilestones();
            }
          },
          builder: (context, state) {
            // Handle loading and error states
            if (state is BabyLoading || state is MilestoneLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is BabyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<BabyCubit>().loadBabyProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is NoBabyProfile) {
              return const Center(
                child: Text('No baby profile found. Please add your baby first.'),
              );
            }
            
            List<MilestoneModel> milestones = [];
            if (state is MilestoneLoaded) {
              milestones = state.allMilestones;
            }
            
            // Calculate progress
            int completedCount = milestones.where((m) => m.achievedDate != null).length;
            int totalCount = milestones.isEmpty ? defaultMilestones.length : milestones.length;
            double percentage = totalCount > 0 ? (completedCount / totalCount * 100) : 0;

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Milestones',
                            style: AppTextStyles.headline1.copyWith(color: AppColors.main500),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: AppColors.main500, size: 24),
                        onPressed: () => _showAddMilestoneDialog(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Progress Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.main500, AppColors.main300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppColors.shadow1,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '$completedCount/$totalCount',
                                      style: AppTextStyles.numberHighlight.copyWith(fontSize: 32),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Completed',
                                      style: AppTextStyles.body1.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${percentage.toInt()}%',
                                      style: AppTextStyles.numberHighlight.copyWith(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Milestones List
                          Text(
                            'Developmental Milestones',
                            style: AppTextStyles.headline2,
                          ),
                          const SizedBox(height: 12),
                          if (milestones.isEmpty)
                            ...defaultMilestones.map((m) => _buildDefaultMilestoneItem(
                              m['title'] as String,
                              m['age'] as int,
                            ))
                          else
                            ...milestones.map((milestone) => _buildMilestoneItem(
                              milestone,
                            )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDefaultMilestoneItem(String title, int ageMonths) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.purpleGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expected at $ageMonths months',
                  style: AppTextStyles.smallLabel,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<BabyCubit>().addMilestone(
                milestoneName: title,
                expectedAgeMonths: ageMonths,
                achievedDate: DateTime.now(),
              );
            },
            icon: const Icon(Icons.check_circle_outline),
            color: AppColors.main500,
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(MilestoneModel milestone) {
    final isCompleted = milestone.achievedDate != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? AppColors.main500 : Colors.transparent,
          width: 2,
        ),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.main500 : AppColors.purpleGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.emoji_events_outlined,
              color: isCompleted ? AppColors.white : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.milestoneName,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompleted && milestone.achievedDate != null
                      ? 'Completed: ${DateFormat('MMM d, yyyy').format(milestone.achievedDate!)}'
                      : 'Expected at ${milestone.expectedAgeMonths ?? 'N/A'} months',
                  style: AppTextStyles.smallLabel,
                ),
              ],
            ),
          ),
          if (!isCompleted)
            IconButton(
              onPressed: () {
                context.read<BabyCubit>().markMilestoneAchieved(milestone.id);
              },
              icon: const Icon(Icons.check_circle_outline),
              color: AppColors.main500,
            ),
        ],
      ),
    );
  }

  void _showAddMilestoneDialog(BuildContext context) {
    final titleController = TextEditingController();
    final ageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.bg_1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Add Milestone', style: AppTextStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Milestone Title',
                  labelStyle: AppTextStyles.body1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.main500, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Expected Age (months)',
                  labelStyle: AppTextStyles.body1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.main500, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<BabyCubit>().addMilestone(
                    milestoneName: titleController.text,
                    expectedAgeMonths: int.tryParse(ageController.text),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main500,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

