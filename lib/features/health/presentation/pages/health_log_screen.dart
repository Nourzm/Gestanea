import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/widgets/header.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/core/session/session_manager.dart';
import '../widgets/health_tab_sidebar.dart';
import '../widgets/vitals_tab_content.dart';
import '../widgets/symptoms_tab_content.dart';
import '../widgets/lab_results_tab_content.dart';
import '../widgets/risk_alerts_tab_content.dart';
import '../widgets/mood_tab_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_event.dart';
import '../../logic/bloc/symptoms_bloc.dart';
import '../../logic/bloc/symptoms_event.dart';
import '../../logic/bloc/moods_bloc.dart';
import '../../logic/bloc/moods_event.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class HealthLogScreen extends StatefulWidget {
  const HealthLogScreen({super.key});

  @override
  State<HealthLogScreen> createState() => _HealthLogScreenState();
}

class _HealthLogScreenState extends State<HealthLogScreen> {
  int _selectedTabIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final sessionManager = SessionManager();
    var userId = await sessionManager.getCurrentUserId();
    
    // Use a default test user ID if not logged in (for development)
    if (userId == null || userId.isEmpty) {
      userId = 'test_user_id';
      await sessionManager.saveCurrentUserId(userId);
    }
    
    setState(() {
      _userId = userId;
    });
  }

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.favorite, 'labelKey': 'vitals'},
    {'icon': Icons.medication, 'labelKey': 'symptoms'},
    {'icon': Icons.science, 'labelKey': 'labResults'},
    {'icon': Icons.warning_amber_rounded, 'labelKey': 'riskAlerts'},
    {'icon': Icons.sentiment_satisfied_alt, 'labelKey': 'mood'},
  ];

  Widget _getTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const VitalsTabContent();
      case 1:
        return const SymptomsTabContent();
      case 2:
        return const LabResultsTabContent();
      case 3:
        return const RiskAlertsTabContent();
      case 4:
        return const MoodTabContent();
      default:
        return const VitalsTabContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MeasurementsBloc()..add(LoadMeasurements()),
        ),
        BlocProvider(create: (context) => SymptomsBloc()..add(LoadSymptoms())),
        BlocProvider(create: (context) => MoodsBloc()..add(LoadMoods())),
        BlocProvider(
          create: (context) {
            final bloc = LabResultsBloc();
            if (_userId != null) {
              bloc.setUserId(_userId!);
            }
            bloc.add(LoadLabResults());
            return bloc;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bg_1,
        body: SafeArea(
          child: Column(
            children: [
              // Header with notification navigation
              Header(
                title: localizations.healthLog,
                onNotificationTapped: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  );
                },
              ),

              // Subtitle - CLOSER to header (pulled up)
              Transform.translate(
                offset: const Offset(0, -8),
                child: Text(
                  localizations.trackYourWellness,
                  style: TextStyle(
                    color: context
                        .watch<ThemeCubit>()
                        .currentTheme
                        .primaryColor,
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              // Main content with sidebar and tab content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Sidebar Navigation
                    HealthTabSidebar(
                      tabs: _tabs,
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() => _selectedTabIndex = index);
                      },
                    ),

                    // Tab Content Area
                    Expanded(child: _getTabContent()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
