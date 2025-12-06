// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit_factory.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_state.dart';
import 'package:gestanea/features/dashboard/domain/entities/postpartum_dashboard.dart';
import 'package:gestanea/features/dashboard/presentation/pages/home_screen.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/navbar.dart';
import 'postpartum_dashboard_page.dart';
import 'package:gestanea/features/pregnancy/presentation/pages/week_tracker_page.dart';
import 'postpartum_track_page.dart';
import 'package:gestanea/features/health/presentation/pages/health_log_screen.dart';
import 'package:gestanea/features/plan/presentation/pages/plan_page.dart';
import 'package:gestanea/features/marketplace/presentation/pages/marketplace_page.dart';
import 'package:gestanea/features/marketplace/logic/marketplace_bloc.dart';
import '../../../../main.dart' show routeObserver;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver, RouteAware {
  int _currentIndex = 0;
  String babyGender = 'girl';
  String? _userId;
  DashboardCubit? _dashboardCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when returning to this page from another page
  @override
  void didPopNext() {
    _refreshDashboard();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh dashboard when app is resumed
    if (state == AppLifecycleState.resumed) {
      _refreshDashboard();
    }
  }

  void _refreshDashboard() {
    final userIdInt = int.tryParse(_userId ?? '0') ?? 0;
    if (userIdInt > 0 && _dashboardCubit != null) {
      _dashboardCubit!.loadDashboard(userIdInt);
    }
  }

  void _setPageIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '0'; // Default if not authenticated
  }

  @override
  Widget build(BuildContext context) {
    _userId = _getUserId(context);
    final double h = MediaQuery.of(context).size.height * 0.09;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>(
          create: (context) {
            final cubit = DashboardCubit();
            _dashboardCubit = cubit;
            // Load dashboard with user ID
            final userIdInt = int.tryParse(_userId ?? '0') ?? 0;
            if (userIdInt > 0) {
              cubit.loadDashboard(userIdInt);
            }
            return cubit;
          },
        ),
        BlocProvider<BabyCubit>(
          create: (context) => BabyCubitFactory.create(_userId ?? '0'),
        ),
      ],
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, dashboardState) {
          // Determine mode based on dashboard state
          final bool isPregnant = dashboardState is PregnancyDashboardLoaded;
          final bool isPostpartum = dashboardState is PostpartumDashboardLoaded;
          final bool isError = dashboardState is DashboardError;
          final bool isLoading = dashboardState is DashboardLoading;

          // Get postpartum dashboard data if available
          PostpartumDashboard? postpartumDashboard;
          String currentBabyGender = babyGender;
          if (isPostpartum) {
            postpartumDashboard = (dashboardState).dashboard;
            // TODO: Extract baby gender from dashboard if available
          }

          // Show loading indicator only during actual loading
          // For initial state or error, show pregnancy dashboard as default
          if (isLoading) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF9B7FDB),
                ),
              ),
            );
          }

          // Default to pregnancy mode if not explicitly in postpartum mode
          final bool showPregnancyMode = isPregnant || isError || dashboardState is DashboardInitial;

          final pages = [
            showPregnancyMode
                ? HomeScreen(onNavigate: _setPageIndex)
                : PostpartumDashboardPage(
                    babyGender: currentBabyGender,
                    dashboard: postpartumDashboard,
                  ),
            showPregnancyMode
                ? const WeekTrackerPage()
                : PostpartumTrackPage(babyGender: currentBabyGender),
            const HealthLogScreen(),
            const PlanMainPage(),
            BlocProvider(
              create: (context) =>
                  MarketplaceBloc()..add(const LoadMarketplaceData()),
              child: const MarketplacePage(),
            ),
          ];

          return Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: h),
                  child: IndexedStack(index: _currentIndex, children: pages),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FancyNavBar(
                    currentIndex: _currentIndex,
                    onTap: (i) => setState(() => _currentIndex = i),
                    items: [
                      NavBarItem(icon: "assets/icons/home.svg", label: "Home"),
                      NavBarItem(icon: "assets/icons/track.svg", label: "Track"),
                      NavBarItem(icon: "assets/icons/health.svg", label: "Health"),
                      NavBarItem(icon: "assets/icons/plan.svg", label: "Plan"),
                      NavBarItem(icon: "assets/icons/market.svg", label: "Market"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
