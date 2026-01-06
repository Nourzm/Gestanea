import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../pages/plan_page.dart'; // Ensure only this correct import exists

class PlanToggle extends StatelessWidget {
  final PlanSection selectedSection;
  final Function(PlanSection) onToggle;
  final double screenWidth;
  final double screenHeight;

  const PlanToggle({
    Key? key,
    required this.selectedSection,
    required this.onToggle,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Get current theme colors
    final themeData = context.watch<ThemeCubit>().currentTheme;

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.purpleGrey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(4, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 10,
            offset: Offset(-6, -6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                onToggle(PlanSection.medicines);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  // Use theme primary color for selected state
                  color: selectedSection == PlanSection.medicines
                      ? themeData.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/pills.svg",
                      color: selectedSection == PlanSection.medicines
                          ? Colors.white
                          : Colors.black87,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      localizations.medicine,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: selectedSection == PlanSection.medicines
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                onToggle(PlanSection.appointments);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  // Use theme primary color for selected state
                  color: selectedSection == PlanSection.appointments
                      ? themeData.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: selectedSection == PlanSection.appointments
                          ? Colors.white
                          : Colors.black87,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      localizations.appointments,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: selectedSection == PlanSection.appointments
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
