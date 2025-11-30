import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../widgets/week_calendar.dart';
import '../widgets/plan_toggle.dart';
import 'main_content.dart';
import 'medicines_page.dart';
import 'appointments_page.dart';

class PlanMainPage extends StatefulWidget {
  const PlanMainPage({super.key});

  @override
  State<PlanMainPage> createState() => _PlanMainPageState();
}

enum PlanSection { none, medicines, appointments }

class _PlanMainPageState extends State<PlanMainPage> {
  PlanSection selectedSection = PlanSection.none;
  DateTime selectedDate = DateTime.now();

  // Get days for the week
  List<DateTime> getWeekDays() {
    final today = DateTime.now();
    final weekDay = today.weekday;
    final startOfWeek = today.subtract(Duration(days: weekDay % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _formattedDate(DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    final weekdays = [
      localizations.sunday,
      localizations.monday,
      localizations.tuesday,
      localizations.wednesday,
      localizations.thursday,
      localizations.friday,
      localizations.saturday,
    ];
    final months = [
      localizations.jan,
      localizations.feb,
      localizations.mar,
      localizations.apr,
      localizations.may,
      localizations.jun,
      localizations.jul,
      localizations.aug,
      localizations.sep,
      localizations.oct,
      localizations.nov,
      localizations.dec,
    ];
    String weekday = weekdays[date.weekday % 7];
    String month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  void _navigateToPage(PlanSection section) {
    if (section == PlanSection.medicines) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const MedicinesPage()));
    } else if (section == PlanSection.appointments) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const AppointmentsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final weekDays = getWeekDays();

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: 'Plan', showBackButton: false),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Display
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Text(
                        _formattedDate(selectedDate),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Week Calendar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: WeekCalendar(
                        weekDays: weekDays,
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Medicine / Appointments Toggle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: PlanToggle(
                        selectedSection: selectedSection,
                        onToggle: (section) {
                          _navigateToPage(section);
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Main Content
                    MainContent(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      showMedicine: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
