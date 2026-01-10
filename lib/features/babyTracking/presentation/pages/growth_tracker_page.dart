// lib/features/baby/presentation/pages/growth_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/features/babyTracking/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/babyTracking/logic/cubit/baby_state.dart';
import 'package:intl/intl.dart';

class GrowthTrackerPage extends StatefulWidget {
  final String? babyId;

  const GrowthTrackerPage({super.key, this.babyId});

  @override
  State<GrowthTrackerPage> createState() => _GrowthTrackerPageState();
}

class _GrowthTrackerPageState extends State<GrowthTrackerPage> {
  bool showWeight = true;
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Check if baby profile is already loaded
    final cubit = context.read<BabyCubit>();
    if (cubit.currentBabyId != null) {
      cubit.loadGrowthRecords();
      _hasLoadedData = true;
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: BlocConsumer<BabyCubit, BabyState>(
          listener: (context, state) {
            // When baby profile is loaded, load growth records
            if (state is BabyLoaded && !_hasLoadedData) {
              _hasLoadedData = true;
              context.read<BabyCubit>().loadGrowthRecords();
            }
          },
          builder: (context, state) {
            // Handle loading and error states
            if (state is BabyLoading || state is GrowthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BabyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<BabyCubit>().loadBabyProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is NoBabyProfile) {
              return const Center(
                child: Text(
                  'No baby profile found. Please add your baby first.',
                ),
              );
            }

            List<BabyGrowthModel> growthRecords = [];
            if (state is GrowthLoaded) {
              growthRecords = state.growthRecords;
            }

            // Filter records based on current view (weight only - model has no height)
            final filteredRecords =
                growthRecords.where((r) => r.weight != null).toList()
                  ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));

            // Get latest record
            final latestValue = filteredRecords.isNotEmpty
                ? filteredRecords.first.weight
                : null;
            final latestDate = filteredRecords.isNotEmpty
                ? filteredRecords.first.recordedDate
                : null;

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.main500,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Growth Tracker',
                            style: AppTextStyles.headline1.copyWith(
                              color: AppColors.main500,
                            ),
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
                          // Current Stats
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
                            child: Column(
                              children: [
                                Text(
                                  'Current Weight',
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  latestValue != null
                                      ? '$latestValue kg'
                                      : 'No data',
                                  style: AppTextStyles.numberHighlight.copyWith(
                                    fontSize: 36,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  latestDate != null
                                      ? 'Last updated: ${DateFormat('MMM d, yyyy').format(latestDate)}'
                                      : 'No records yet',
                                  style: AppTextStyles.smallLabel.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Chart Placeholder
                          Container(
                            height: 250,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppColors.shadow1,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Weight Progress Chart',
                                  style: AppTextStyles.subtitle1.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: Center(
                                    child: Icon(
                                      Icons.show_chart,
                                      size: 80,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Chart visualization would go here',
                                  style: AppTextStyles.smallLabel,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Recent Logs
                          Text('Recent Logs', style: AppTextStyles.headline2),
                          const SizedBox(height: 12),
                          if (filteredRecords.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No weight records yet',
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...filteredRecords
                                .take(5)
                                .map(
                                  (record) => _buildLogItem(
                                    '${record.weight} kg',
                                    DateFormat(
                                      'MMM d, yyyy',
                                    ).format(record.recordedDate),
                                    record == filteredRecords.first,
                                  ),
                                ),
                          const SizedBox(height: 24),

                          // Add Log Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showAddLogDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Weight Log'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.main500,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
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

  Widget _buildLogItem(String value, String date, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLatest
            ? AppColors.pink300.withValues(alpha: 0.3)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest ? AppColors.pink500 : Colors.transparent,
          width: 2,
        ),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isLatest ? AppColors.pink500 : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                value,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isLatest ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(date, style: AppTextStyles.body1),
        ],
      ),
    );
  }

  void _showAddLogDialog(BuildContext context) {
    _valueController.clear();
    _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.bg_1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('Add Weight Log', style: AppTextStyles.headline2),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: AppTextStyles.body1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.main500,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => _selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: AppTextStyles.body1,
                          hintText: DateFormat(
                            'MMM d, yyyy',
                          ).format(_selectedDate),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: AppColors.main500,
                          ),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('MMM d, yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final value = double.tryParse(_valueController.text);
                    if (value != null) {
                      context.read<BabyCubit>().addGrowthRecord(
                        recordedDate: _selectedDate,
                        weight: value,
                      );
                      Navigator.pop(dialogContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main500,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
