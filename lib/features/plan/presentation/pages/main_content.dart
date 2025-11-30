// Today's Medicine Progress Card
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../widgets/medicine_progress_card.dart';
import '../widgets/upcoming_appointments_card.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';

class MainContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: MedicineProgressCard(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            progress: 0.25,
            takenText: '1 of 4 taken',
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        // Add New Medicine Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: NeumorphicButton(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            text: localization.addNewMedicine,
            onPressed: () {
              // Add medicine action
            },
            icon: const Icon(Icons.add, color: AppColors.white, size: 24),
            color: AppColors.main500,
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        // Upcoming Appointments Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: UpcomingAppointmentsCard(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            scheduledCount: 3,
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        // Add New Appointment Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: NeumorphicButton(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            text: localization.addNewAppointment,
            onPressed: () {
              // Add appointment action
            },
            icon: const Icon(Icons.add, color: AppColors.white, size: 24),
            color: AppColors.main500,
          ),
        ),
      ],
    );
  }
}
