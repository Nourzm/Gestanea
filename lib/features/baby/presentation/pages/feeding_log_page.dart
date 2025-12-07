// =============================================================================
// FILE: presentation/pages/feeding_log_page.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/feeding_log_model.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:intl/intl.dart';

class FeedingLogPage extends StatefulWidget {
  final String? babyId;
  
  const FeedingLogPage({super.key, this.babyId});

  @override
  State<FeedingLogPage> createState() => _FeedingLogPageState();
}

class _FeedingLogPageState extends State<FeedingLogPage> {
  String selectedType = 'Breastfeed';
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Check if baby profile is already loaded
    final cubit = context.read<BabyCubit>();
    if (cubit.currentBabyId != null) {
      cubit.loadFeedingLogs();
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
            // When baby profile is loaded, load feeding logs
            if (state is BabyLoaded && !_hasLoadedData) {
              _hasLoadedData = true;
              context.read<BabyCubit>().loadFeedingLogs();
            }
          },
          builder: (context, state) {
            // Handle loading and error states
            if (state is BabyLoading || state is FeedingLoading) {
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
            
            List<FeedingLogModel> feedingLogs = [];
            if (state is FeedingLoaded) {
              feedingLogs = state.feedingLogs;
            }
            
            // Filter by selected type and today
            final today = DateTime.now();
            final todayLogs = feedingLogs.where((log) {
              final logDate = log.loggedAt;
              return logDate.year == today.year && 
                     logDate.month == today.month && 
                     logDate.day == today.day;
            }).toList();
            
            // Calculate totals
            final totalFeedings = todayLogs.length;
            final totalMinutes = todayLogs.fold<int>(0, (sum, log) => sum + (log.durationMinutes ?? 0));
            final hours = totalMinutes ~/ 60;
            final minutes = totalMinutes % 60;

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
                            'Feeding Log',
                            style: AppTextStyles.headline1.copyWith(color: AppColors.main500),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
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
                          // Today's Summary
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.pink500, AppColors.pink300],
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
                                    Icon(Icons.restaurant, color: AppColors.white, size: 32),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$totalFeedings times',
                                      style: AppTextStyles.headline2.copyWith(color: AppColors.white),
                                    ),
                                    Text(
                                      'Today',
                                      style: AppTextStyles.smallLabel.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 60,
                                  color: AppColors.white.withValues(alpha: 0.3),
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.timer, color: AppColors.white, size: 32),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${hours}h ${minutes}m',
                                      style: AppTextStyles.headline2.copyWith(color: AppColors.white),
                                    ),
                                    Text(
                                      'Total Time',
                                      style: AppTextStyles.smallLabel.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Feeding Type Selector
                          Row(
                            children: [
                              Expanded(
                                child: _buildTypeButton('Breastfeed', Icons.child_care),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTypeButton('Bottle', Icons.baby_changing_station),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Recent Logs
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Feedings',
                                style: AppTextStyles.headline2,
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Navigate to all feeding logs page
                                },
                                child: Text(
                                  'View All',
                                  style: AppTextStyles.body1.copyWith(color: AppColors.main500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (feedingLogs.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No feeding logs yet',
                                  style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                                ),
                              ),
                            )
                          else
                            ...feedingLogs.take(10).map((log) => _buildFeedingLogItem(log)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddFeedingDialog(context);
        },
        backgroundColor: AppColors.main500,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('Add Feeding', style: AppTextStyles.bodyWhite),
      ),
    );
  }

  Widget _buildTypeButton(String type, IconData icon) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main500 : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedingLogItem(FeedingLogModel log) {
    final startTime = log.loggedAt;
    final timeStr = DateFormat('h:mm a').format(startTime);
    
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.pink500.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              log.feedingType == 'Breastfeed'
                  ? Icons.child_care
                  : Icons.baby_changing_station,
              color: AppColors.pink500,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.feedingType,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.feedingType == 'Breastfeed'
                      ? '${log.durationMinutes ?? 0} min${log.breastSide != null ? ' - ${log.breastSide} side' : ''}'
                      : '${log.amountMl ?? 0} ml',
                  style: AppTextStyles.body1,
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: AppTextStyles.body1,
          ),
        ],
      ),
    );
  }

  void _showAddFeedingDialog(BuildContext context) {
    String feedingType = 'Breastfeed';
    String? selectedSide;
    final durationController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Add Feeding',
                style: AppTextStyles.headline2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: feedingType,
                      decoration: InputDecoration(
                        labelText: 'Feeding Type',
                        labelStyle: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.purpleGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.main500),
                        ),
                      ),
                      items: ['Breastfeed', 'Bottle'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: AppTextStyles.body1),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          feedingType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.body1,
                      decoration: InputDecoration(
                        labelText: feedingType == 'Breastfeed'
                            ? 'Duration (minutes)'
                            : 'Amount (ml)',
                        labelStyle: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.purpleGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.main500),
                        ),
                      ),
                    ),
                    if (feedingType == 'Breastfeed') ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedSide,
                        decoration: InputDecoration(
                          labelText: 'Side (optional)',
                          labelStyle: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.purpleGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.main500),
                          ),
                        ),
                        items: [null, 'Left', 'Right', 'Both'].map((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value ?? 'Not specified', style: AppTextStyles.body1),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedSide = value;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          style: AppTextStyles.body1,
                          decoration: InputDecoration(
                            labelText: 'Time',
                            labelStyle: AppTextStyles.body1.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.purpleGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.main500),
                            ),
                            suffixIcon: Icon(Icons.access_time, color: AppColors.main500),
                          ),
                          controller: TextEditingController(
                            text: selectedTime.format(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final loggedAt = DateTime(
                      now.year, now.month, now.day,
                      selectedTime.hour, selectedTime.minute,
                    );
                    
                    final value = int.tryParse(durationController.text) ?? 0;
                    
                    context.read<BabyCubit>().addFeedingLog(
                      feedingType: feedingType,
                      durationMinutes: feedingType == 'Breastfeed' ? value : null,
                      amountMl: feedingType == 'Bottle' ? value.toDouble() : null,
                      breastSide: selectedSide,
                      loggedAt: loggedAt,
                    );
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main500,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save', style: AppTextStyles.bodyWhite),
                ),
              ],
            );
          },
        );
      },
    );
  }
}