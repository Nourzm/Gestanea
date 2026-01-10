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
  final bool isGirl;
  
  const FeedingLogPage({super.key, this.babyId, this.isGirl = false});

  @override
  State<FeedingLogPage> createState() => _FeedingLogPageState();
}

class _FeedingLogPageState extends State<FeedingLogPage> {
  String selectedType = 'All';
  bool _hasLoadedData = false;
  
  Color get primaryColor => widget.isGirl ? const Color(0xFFFF9EC9) : const Color(0xFF87CEEB);
  Color get secondaryColor => widget.isGirl ? const Color(0xFFFFC6E0) : const Color(0xFFB0E0E6);

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
                        icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Feeding Log',
                            style: AppTextStyles.headline1.copyWith(color: primaryColor),
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
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
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
                                child: _buildTypeButton('All', Icons.list_alt, context.read<BabyCubit>()),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTypeButton('Breastfeed', Icons.child_care, context.read<BabyCubit>()),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTypeButton('Bottle', Icons.baby_changing_station, context.read<BabyCubit>()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Recent Logs (Today only)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today\'s Feedings',
                                style: AppTextStyles.headline2,
                              ),
                              TextButton(
                                onPressed: () {
                                  _showAllFeedingsDialog(context, feedingLogs);
                                },
                                child: Text(
                                  'See All',
                                  style: AppTextStyles.body1.copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (todayLogs.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No feedings today',
                                  style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                                ),
                              ),
                            )
                          else
                            ...todayLogs.map((log) => _buildFeedingLogItem(log)),
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
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('Add Feeding', style: AppTextStyles.bodyWhite),
      ),
    );
  }

  Widget _buildTypeButton(String type, IconData icon, BabyCubit babyCubit) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
        // Load feeding logs filtered by type
        babyCubit.loadFeedingLogs(filterType: type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : AppColors.white,
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
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              log.feedingType == 'Breastfeed'
                  ? Icons.child_care
                  : Icons.baby_changing_station,
              color: primaryColor,
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
                      : '${log.durationMinutes ?? 0} min - ${log.amountMl?.toInt() ?? 0} ml',
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
    // Capture the BabyCubit before showing dialog to avoid context issues
    final babyCubit = context.read<BabyCubit>();
    
    String feedingType = 'Breastfeed';
    String? selectedSide;
    final durationController = TextEditingController();
    final amountController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    String? durationError;
    String? amountError;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
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
                      initialValue: feedingType,
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
                          borderSide: BorderSide(color: primaryColor),
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
                          durationError = null;
                          amountError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Duration field (for both types)
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.body1,
                      decoration: InputDecoration(
                        labelText: 'Duration (minutes) *',
                        labelStyle: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        errorText: durationError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.purpleGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onChanged: (_) {
                        if (durationError != null) {
                          setDialogState(() => durationError = null);
                        }
                      },
                    ),
                    // Amount field (only for Bottle)
                    if (feedingType == 'Bottle') ...[                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.body1,
                      decoration: InputDecoration(
                        labelText: 'Amount (ml) *',
                        labelStyle: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        errorText: amountError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.purpleGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onChanged: (_) {
                        if (amountError != null) {
                          setDialogState(() => amountError = null);
                        }
                      },
                    ),
                    ],
                    if (feedingType == 'Breastfeed') ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedSide,
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
                            borderSide: BorderSide(color: primaryColor),
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
                          context: builderContext,
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
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            suffixIcon: Icon(Icons.access_time, color: primaryColor),
                          ),
                          controller: TextEditingController(
                            text: selectedTime.format(builderContext),
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
                    final duration = int.tryParse(durationController.text);
                    final amount = int.tryParse(amountController.text);
                    
                    // Validate duration is required for all types
                    if (duration == null || duration <= 0) {
                      setDialogState(() {
                        durationError = 'Duration is required';
                      });
                      return;
                    }
                    
                    // Validate amount is required for Bottle
                    if (feedingType == 'Bottle' && (amount == null || amount <= 0)) {
                      setDialogState(() {
                        amountError = 'Amount is required';
                      });
                      return;
                    }
                    
                    final now = DateTime.now();
                    final loggedAt = DateTime(
                      now.year, now.month, now.day,
                      selectedTime.hour, selectedTime.minute,
                    );
                    
                    babyCubit.addFeedingLog(
                      feedingType: feedingType,
                      durationMinutes: duration,
                      amountMl: feedingType == 'Bottle' ? amount?.toDouble() : null,
                      breastSide: selectedSide,
                      loggedAt: loggedAt,
                    );
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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

  void _showAllFeedingsDialog(BuildContext context, List<FeedingLogModel> allLogs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.purpleGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Feeding History',
                      style: AppTextStyles.headline2,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: allLogs.isEmpty
                    ? Center(
                        child: Text(
                          'No feeding logs yet',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: allLogs.length,
                        itemBuilder: (context, index) {
                          final log = allLogs[index];
                          return _buildFeedingHistoryItem(log);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedingHistoryItem(FeedingLogModel log) {
    final timeStr = DateFormat('h:mm a').format(log.loggedAt);
    final dateStr = DateFormat('MMM d, yyyy').format(log.loggedAt);
    
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
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              log.feedingType == 'Breastfeed'
                  ? Icons.child_care
                  : Icons.baby_changing_station,
              color: primaryColor,
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
                      : '${log.durationMinutes ?? 0} min - ${log.amountMl?.toInt() ?? 0} ml',
                  style: AppTextStyles.body1,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: AppTextStyles.smallLabel.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}