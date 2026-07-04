import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../widgets/medicine_progress_card.dart';
import '../widgets/upcoming_appointments_card.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'add_medicine_flow.dart';
import 'add_appointment_flow.dart';
import '../../logic/plan_bloc.dart';

class MainContent extends StatefulWidget {
  final String userId;
  final double screenWidth;
  final double screenHeight;
  final bool showMedicine;

  const MainContent({
    super.key,
    required this.userId,
    required this.screenWidth,
    required this.screenHeight,
    required this.showMedicine,
  });

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<PlanBloc>().add(
      LoadPlanData(userId: widget.userId, date: DateTime.now()),
    );
  }

  Map<String, int> _getMedicineStats(medicines, medicineLogs) {
    final total = medicines.length;
    final taken = medicineLogs.where((log) => log.status == 'taken').length;
    return {'total': total, 'taken': taken};
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        if (state is PlanLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.main500),
          );
        }

        if (state is PlanError) {
          return Center(
            child: Text(
              '${AppLocalizations.of(context)!.error}: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is! PlanLoaded) {
          return Center(child: Text(AppLocalizations.of(context)!.noData));
        }

        final stats = _getMedicineStats(state.medicines, state.medicineLogs);
        final total = stats['total'] ?? 0;
        final taken = stats['taken'] ?? 0;
        final progress = total > 0 ? taken / total : 0.0;
        final takenText = localization.medicinesTaken(taken, total);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * 0.05,
              ),
              child: MedicineProgressCard(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
                progress: progress,
                takenText: takenText,
              ),
            ),
            SizedBox(height: widget.screenHeight * 0.025),
            SizedBox(height: widget.screenHeight * 0.025),
            // Add New Medicine Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * 0.05,
              ),
              child: NeumorphicButton(
                text: localization.addNewMedicine,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddMedicineFlow(userId: widget.userId),
                    ),
                  );
                  if (result == true) {
                    _loadData(); // Refresh data
                  }
                },
                prefixIcon: Icons.add,
                color: AppColors.main500,
              ),
            ),
            SizedBox(height: widget.screenHeight * 0.025),
            // Upcoming Appointments Card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * 0.05,
              ),
              child: UpcomingAppointmentsCard(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
                scheduledCount: state.appointments.length,
              ),
            ),
            SizedBox(height: widget.screenHeight * 0.025),
            // Add New Appointment Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * 0.05,
              ),
              child: NeumorphicButton(
                text: localization.addNewAppointment,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddAppointmentFlow(userId: widget.userId),
                    ),
                  );
                  if (result == true) {
                    _loadData(); // Refresh data
                  }
                },
                prefixIcon: Icons.add,
                color: AppColors.main500,
              ),
            ),
          ],
        );
      },
    );
  }
}
