import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/session/session_manager.dart';
import '../widgets/week_calendar.dart';
import '../widgets/plan_toggle.dart';
import 'main_content.dart';
import 'medicines_page.dart';
import 'appointments_page.dart';
import '../../logic/plan_bloc.dart';
import '../../logic/medicines_bloc.dart';
import '../../data/repositories/medicine_repository.dart';
import '../../data/repositories/appointment_repository.dart';

class PlanMainPage extends StatefulWidget {
  const PlanMainPage({super.key});

  @override
  State<PlanMainPage> createState() => _PlanMainPageState();
}

class _PlanMainPageState extends State<PlanMainPage> {
  final _sessionManager = SessionManager();
  String? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId = await _sessionManager.getCurrentUserId();
    setState(() {
      _userId = userId;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bg_1,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.main500),
        ),
      );
    }

    if (_userId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg_1,
        body: Center(
          child: Text(AppLocalizations.of(context)!.pleaseLoginToViewPlan),
        ),
      );
    }

    return BlocProvider(
      create: (context) => PlanBloc(
        medicineRepository: MedicineRepository.getInstance(),
        appointmentRepository: AppointmentRepository.getInstance(),
      ),
      child: _PlanMainPageContent(userId: _userId!),
    );
  }
}

class _PlanMainPageContent extends StatefulWidget {
  final String userId;

  const _PlanMainPageContent({required this.userId});

  @override
  State<_PlanMainPageContent> createState() => _PlanMainPageContentState();
}

enum PlanSection { none, medicines, appointments }

class _PlanMainPageContentState extends State<_PlanMainPageContent> {
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

  void _navigateToPage(PlanSection section) async {
    final bloc = context.read<PlanBloc>();
    if (section == PlanSection.medicines) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bloc),
              BlocProvider(create: (context) => MedicinesBloc()),
            ],
            child: MedicinesPage(userId: widget.userId),
          ),
        ),
      );
      // Reload plan data when returning
      bloc.add(LoadPlanData(userId: widget.userId, date: selectedDate));
    } else if (section == PlanSection.appointments) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: bloc,
            child: AppointmentsPage(userId: widget.userId),
          ),
        ),
      );
      // Reload plan data when returning
      bloc.add(LoadPlanData(userId: widget.userId, date: selectedDate));
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
            Header(
              title: AppLocalizations.of(context)!.plan,
              showBackButton: false,
            ),
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
                      userId: widget.userId,
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
