import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/datasources/vaccine_local_data_source.dart';
import '../../logic/cubit/baby_cubit.dart';

class VaccineTrackerPage extends StatefulWidget {
  final bool isGirl; // true for girl (pink), false for boy (blue)
  const VaccineTrackerPage({super.key, required this.isGirl});

  @override
  State<VaccineTrackerPage> createState() => _VaccineTrackerPageState();
}

class _VaccineTrackerPageState extends State<VaccineTrackerPage> {
  late final VaccineLocalDataSource _vaccineDataSource;
  List<Map<String, dynamic>> _vaccines = [];
  bool _loading = true;
  String? _error;
  String? _actionLoadingId;

  @override
  void initState() {
    super.initState();
    _vaccineDataSource = VaccineLocalDataSource();
    _loadVaccines();
  }

  Future<void> _loadVaccines() async {
    try {
      final cubit = context.read<BabyCubit>();
      final babyId = cubit.currentBabyId;
      if (babyId == null) {
        setState(() {
          _error = 'No baby profile found.';
          _loading = false;
        });
        return;
      }
      final vaccines = await _vaccineDataSource.getVaccinesForBaby(babyId);
      setState(() {
        _vaccines = vaccines;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load vaccines.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.isGirl
        ? AppColors.pink500
        : AppColors.blue500;
    final Color secondaryColor = widget.isGirl
        ? AppColors.pink300
        : AppColors.main300;
    final Color backgroundColor = AppColors.bg_1;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        'Vaccine Tracker',
                        style: AppTextStyles.headline2.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Month Selector
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chevron_left, color: AppColors.white),
                        const SizedBox(width: 16),
                        Text(
                          'March 2024',
                          style: AppTextStyles.subtitle1.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.chevron_right, color: AppColors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Vaccine List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : _vaccines.isEmpty
                    ? Center(child: Text('No vaccines scheduled.'))
                    : ListView.builder(
                        itemCount: _vaccines.length,
                        itemBuilder: (context, index) {
                          final v = _vaccines[index];
                          final completed = v['is_completed'] == 1;
                          final title = v['vaccine_name'] ?? '';
                          final scheduledAge = v['scheduled_age'] ?? '';
                          final scheduledDate = v['scheduled_date'];
                          final completedDate = v['completed_date'];
                          String subtitle;
                          if (completed) {
                            subtitle = 'Completed: $scheduledAge';
                            if (completedDate != null) {
                              subtitle += ' ($completedDate)';
                            }
                          } else {
                            subtitle = 'Upcoming: $scheduledAge';
                            if (scheduledDate != null) {
                              subtitle += ' ($scheduledDate)';
                            }
                          }
                          return GestureDetector(
                            onTap: () async {
                              await _showVaccineActionsDialog(context, v);
                            },
                            child: Stack(
                              children: [
                                _buildVaccineCard(
                                  title: title,
                                  subtitle: subtitle,
                                  completed: completed,
                                  primaryColor: primaryColor,
                                ),
                                if (_actionLoadingId == v['id'])
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white.withOpacity(0.6),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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

  // Helper methods must be declared before build
  Widget _buildVaccineCard({
    required String title,
    required String subtitle,
    required bool completed,
    required Color primaryColor,
  }) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green.withValues(alpha: 0.1)
                  : primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              completed ? Icons.check_circle : Icons.access_time,
              color: completed ? Colors.green : primaryColor,
              size: 24,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body1.copyWith(
                    color: completed ? Colors.green : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showVaccineActionsDialog(BuildContext context, Map<String, dynamic> vaccine) async {
    final completed = vaccine['is_completed'] == 1;
    final List<Widget> actions = [];
    if (!completed) {
      actions.add(ListTile(
        leading: const Icon(Icons.event_available),
        title: const Text('Schedule'),
        onTap: () async {
          Navigator.pop(context);
          await _pickAndScheduleVaccine(vaccine);
        },
      ));
      actions.add(ListTile(
        leading: const Icon(Icons.check_circle),
        title: const Text('Mark as Done'),
        onTap: () async {
          Navigator.pop(context);
          await _pickAndMarkVaccineDone(vaccine);
        },
      ));
      actions.add(ListTile(
        leading: const Icon(Icons.update),
        title: const Text('Reschedule'),
        onTap: () async {
          Navigator.pop(context);
          await _pickAndRescheduleVaccine(vaccine);
        },
      ));
    } else {
      actions.add(ListTile(
        leading: const Icon(Icons.info),
        title: const Text('View Completion Date'),
        subtitle: Text(vaccine['completed_date'] ?? 'No date'),
        onTap: () => Navigator.pop(context),
      ));
    }
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(vaccine['vaccine_name'] ?? 'Vaccine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
      ),
    );
  }

  Future<void> _pickAndScheduleVaccine(Map<String, dynamic> vaccine) async {
    final picked = await _pickDateDialog(context, initial: vaccine['scheduled_date']);
    if (picked != null) {
      setState(() => _actionLoadingId = vaccine['id']);
      await _vaccineDataSource.scheduleVaccine(vaccine['id'], picked);
      await _loadVaccines();
      setState(() => _actionLoadingId = null);
    }
  }

  Future<void> _pickAndMarkVaccineDone(Map<String, dynamic> vaccine) async {
    final picked = await _pickDateDialog(context, initial: vaccine['completed_date']);
    if (picked != null) {
      setState(() => _actionLoadingId = vaccine['id']);
      await _vaccineDataSource.markVaccineAsDone(vaccine['id'], picked);
      await _loadVaccines();
      setState(() => _actionLoadingId = null);
    }
  }

  Future<void> _pickAndRescheduleVaccine(Map<String, dynamic> vaccine) async {
    final picked = await _pickDateDialog(context, initial: vaccine['scheduled_date']);
    if (picked != null) {
      setState(() => _actionLoadingId = vaccine['id']);
      await _vaccineDataSource.rescheduleVaccine(vaccine['id'], picked);
      await _loadVaccines();
      setState(() => _actionLoadingId = null);
    }
  }

  Future<String?> _pickDateDialog(BuildContext context, {String? initial}) async {
    DateTime? initialDate;
    if (initial != null) {
      try {
        initialDate = DateTime.parse(initial);
      } catch (_) {}
    }
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      return picked.toIso8601String().split('T').first;
    }
    return null;
  }
}