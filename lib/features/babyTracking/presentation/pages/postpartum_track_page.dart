import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/babyTracking/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/features/babyTracking/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/babyTracking/logic/repositories/baby_repository.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/features/babyTracking/presentation/pages/feeding_log_page.dart';
import 'package:gestanea/features/babyTracking/presentation/pages/growth_tracker_page.dart';
import 'package:gestanea/features/babyTracking/presentation/pages/milestone_tracker_page.dart';
import 'package:gestanea/features/babyTracking/presentation/pages/vaccine_tracker_page.dart';

class PostpartumTrackPage extends StatelessWidget {
  final String babyGender;

  const PostpartumTrackPage({super.key, required this.babyGender});

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  void _navigateWithBabyCubit(BuildContext context, Widget page) {
    final userId = _getUserId(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => BabyCubit(
            repository: BabyRepository(
              BabyLocalDataSource(DatabaseHelper.instance),
            ),
            userId: userId,
          )..loadBabyProfile(),
          child: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isGirl = babyGender.toLowerCase() == 'girl';
    final Color primaryColor = isGirl ? AppColors.pink500 : AppColors.blue500;
    final Color secondaryColor = isGirl ? AppColors.pink300 : AppColors.blue300;

    final List<Map<String, dynamic>> trackItems = [
      {
        'title': 'Feeding Log',
        'image': 'assets/images/feeding.png',
        'color': AppColors.homeCards,

        'pageBuilder': () => const FeedingLogPage(),
      },
      {
        'title': 'Growth Tracker',
        'image': 'assets/images/weight-tracker.png',
        'color': AppColors.homeCards,

        'pageBuilder': () => const GrowthTrackerPage(),
      },
      {
        'title': 'Milestone',
        'image': 'assets/images/milestones2.png',
        'color': AppColors.homeCards,

        'pageBuilder': () => const MilestoneTrackerPage(),
      },
      {
        'title': 'Vaccine',
        'image': 'assets/images/vaccine.png',
        'color': AppColors.homeCards,

        'pageBuilder': () => VaccineTrackerPage(isGirl: isGirl),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header with notifications
            Header(
              title: 'Track',
              onNotificationTapped: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                );
              },
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(
                'Monitor your baby\'s development journey',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.main600,
                  fontSize: 14,
                ),
              ),
            ),

            // Grid Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: trackItems.length,
                  itemBuilder: (context, index) {
                    final item = trackItems[index];
                    return _TrackCard(
                      title: item['title'],
                      imagePath: item['image'],
                      backgroundColor: item['color'],

                      onTap: () {
                        final pageBuilder =
                            item['pageBuilder'] as Widget Function();
                        _navigateWithBabyCubit(context, pageBuilder());
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;

  final VoidCallback onTap;

  const _TrackCard({
    required this.title,
    required this.imagePath,
    required this.backgroundColor,

    required this.onTap,
  });

  @override
  State<_TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<_TrackCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: _isPressed
              ? [
                  // Pressed state - subtle shadows
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    blurRadius: 4,
                    offset: const Offset(-2, -2),
                  ),
                ]
              : AppColors.shadow1,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              SizedBox(
                width: 80,
                height: 80,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(widget.imagePath),
                ),
              ),

              const SizedBox(height: 12),
              // Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
