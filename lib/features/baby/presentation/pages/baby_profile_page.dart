// lib/features/baby/presentation/pages/baby_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:intl/intl.dart';
import 'growth_tracker_page.dart';
import 'milestone_tracker_page.dart';

class BabyProfilePage extends StatefulWidget {
  final String? babyId;

  const BabyProfilePage({super.key, this.babyId});

  @override
  State<BabyProfilePage> createState() => _BabyProfilePageState();
}

class _BabyProfilePageState extends State<BabyProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load baby profile for the current user
    context.read<BabyCubit>().loadBabyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: BlocBuilder<BabyCubit, BabyState>(
          builder: (context, state) {
            if (state is BabyLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BabyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.body1),
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

            if (state is BabyLoaded) {
              final baby = state.baby;
              final birthDate = baby.dateOfBirth;
              final ageInMonths =
                  DateTime.now().difference(birthDate).inDays ~/ 30;
              final formattedBirthDate = DateFormat(
                'MMMM d, yyyy',
              ).format(birthDate);

              return Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color:
                                    (baby.gender?.toLowerCase() ?? '') ==
                                        'female'
                                    ? AppColors.pink500
                                    : AppColors.blue500,
                                shape: BoxShape.circle,
                                boxShadow: AppColors.shadow1,
                              ),
                              child: const Icon(
                                Icons.child_care,
                                size: 60,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              baby.name,
                              style: AppTextStyles.headline1.copyWith(
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildInfoCard(
                              'Gender',
                              baby.gender ?? 'Not specified',
                              (baby.gender?.toLowerCase() ?? '') == 'female'
                                  ? Icons.female
                                  : Icons.male,
                              (baby.gender?.toLowerCase() ?? '') == 'female'
                                  ? AppColors.pink500
                                  : AppColors.blue500,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              'Date of Birth',
                              formattedBirthDate,
                              Icons.cake,
                              AppColors.main500,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              'Age',
                              '$ageInMonths months',
                              Icons.access_time,
                              AppColors.blue500,
                            ),
                            const SizedBox(height: 12),
                            if (baby.birthWeight != null)
                              _buildInfoCard(
                                'Birth Weight',
                                '${baby.birthWeight} kg',
                                Icons.monitor_weight,
                                AppColors.pink500,
                              ),
                            if (baby.birthWeight != null)
                              const SizedBox(height: 12),
                            if (baby.birthHeight != null)
                              _buildInfoCard(
                                'Birth Height',
                                '${baby.birthHeight} cm',
                                Icons.height,
                                AppColors.main500,
                              ),
                            const SizedBox(height: 32),
                            _buildActionButtons(context, baby.id),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return _buildNoDataView(context);
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                'Baby Profile',
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.main500,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.main500),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataView(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.child_care, size: 80, color: AppColors.main300),
                const SizedBox(height: 16),
                Text(
                  'No baby profile found',
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a baby to get started',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, String babyId) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => BlocProvider.value(
                    value: context.read<BabyCubit>(),
                    child: GrowthTrackerPage(babyId: babyId),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.trending_up),
            label: const Text('View Growth Chart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.main500,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => BlocProvider.value(
                    value: context.read<BabyCubit>(),
                    child: MilestoneTrackerPage(babyId: babyId),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.emoji_events),
            label: const Text('Track Milestones'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.main500,
              side: const BorderSide(color: AppColors.main500, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.smallLabel),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
