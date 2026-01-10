import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../widgets/medicine_progress_card.dart';
import '../widgets/upcoming_appointments_card.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/plan/data/repositories/plan_local_data_source.dart';
import 'package:gestanea/features/plan/data/repositories/plan_database_initializer.dart';
import 'package:gestanea/features/plan/data/mock_data/plan_mock_data.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'add_medicine_flow.dart';
import 'add_appointment_flow.dart';

class MainContent extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final bool showMedicine;

  const MainContent({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.showMedicine,
  }) : super(key: key);

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final PlanLocalDataSource _dataSource = PlanLocalDataSource();
  final PlanDatabaseInitializer _dbInitializer = PlanDatabaseInitializer();
  List<MedicineModel> _medicines = [];
  List<MedicineLoggedModel> _medicineLogs = [];
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Replace with actual user ID from auth
    final userId = PlanMockData.mockUserId;

    try {
      // Initialize database with mock data if empty
      await _dbInitializer.initializeWithMockData(userId);

      // Load from database
      final medicines = await _dataSource.getMedicinesByDate(
        userId,
        DateTime.now(),
      );
      final logs = await _dataSource.getMedicineLogs(userId, DateTime.now());
      final appointments = await _dataSource.getUpcomingAppointments(userId);

      setState(() {
        _medicines = medicines;
        _medicineLogs = logs;
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.main500));
    }

    final stats = PlanMockData.getMedicineStats(_medicines, _medicineLogs);
    final total = stats['total'] ?? 0;
    final taken = stats['taken'] ?? 0;
    final progress = total > 0 ? taken / total : 0.0;
    final takenText = '$taken of $total taken';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05),
          child: MedicineProgressCard(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            progress: progress,
            takenText: takenText,
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.025),
        // Add New Medicine Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05),
          child: NeumorphicButton(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            text: localization.addNewMedicine,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicineFlow(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: AppColors.white, size: 24),
            color: AppColors.main500,
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.025),
        // Upcoming Appointments Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05),
          child: UpcomingAppointmentsCard(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            scheduledCount: _appointments.length,
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.025),
        // Add New Appointment Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05),
          child: NeumorphicButton(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            text: localization.addNewAppointment,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAppointmentFlow(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: AppColors.white, size: 24),
            color: AppColors.main500,
          ),
        ),
      ],
    );
  }
}
