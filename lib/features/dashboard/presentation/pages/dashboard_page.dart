// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit_factory.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_state.dart';
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

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver, RouteAware {
  int _currentIndex = 0;
  String? _userId;
  DashboardCubit? _dashboardCubit;
  BabyCubit? _babyCubit;

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
    } else if (_userId != null && _userId!.isNotEmpty && _dashboardCubit != null) {
      // For UUID-based user IDs, use the string-based method
      _dashboardCubit!.loadDashboardByStringId(_userId!);
    }
    // Also refresh baby profile to get updated gender
    _babyCubit?.loadBabyProfile();
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

  Color _getNavBarColor(String babyGender) {
    final isGirl = babyGender.toLowerCase() == 'girl' || 
                   babyGender.toLowerCase() == 'female';
    return isGirl 
      ? const Color(0xFFFF9EC9)  // Pink for girls
      : const Color(0xFF87CEEB); // Blue for boys
  }

  @override
  Widget build(BuildContext context) {
    _userId = _getUserId(context);
    final height = MediaQuery.of(context).size.height;
    final double h = height * 0.09;

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
          create: (context) {
            final babyCubit = BabyCubitFactory.create(_userId ?? '0');
            _babyCubit = babyCubit; // Store reference for refresh
            babyCubit.loadBabyProfile(); // Load baby profile to get gender
            return babyCubit;
          },
        ),
      ],
      child: BlocBuilder<BabyCubit, BabyState>(
        builder: (context, babyState) {
          // Get baby gender from BabyLoaded state
          String currentBabyGender = 'boy'; // Default to boy
          if (babyState is BabyLoaded) {
            final gender = babyState.baby.gender?.toLowerCase() ?? '';
            currentBabyGender = (gender == 'female' || gender == 'girl') ? 'girl' : 'boy';
          }

          return BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, dashboardState) {
              // Determine mode based on dashboard state
              final bool isPregnant = dashboardState is PregnancyDashboardLoaded;
              final bool isError = dashboardState is DashboardError;
              final bool isLoading = dashboardState is DashboardLoading;

          // Show loading indicator only during actual loading
          // For initial state or error, show pregnancy dashboard as default
          if (isLoading) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: const Center(
                child: CircularProgressIndicator(color: Color(0xFF9B7FDB)),
              ),
            );
          }

          // Default to pregnancy mode if not explicitly in postpartum mode
          final bool showPregnancyMode =
              isPregnant || isError || dashboardState is DashboardInitial;

          final pages = [
            showPregnancyMode
                ? HomeScreen(onNavigate: _setPageIndex)
                : PostpartumDashboardPage(
                    babyGender: currentBabyGender,
                    onNavigationIndexChange: _setPageIndex,
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
                    barHeight: 80,
                    currentIndex: _currentIndex,
                    onTap: (i) => setState(() => _currentIndex = i),
                    primaryColor: showPregnancyMode ? null : _getNavBarColor(currentBabyGender),
                    items: [
                      NavBarItem(icon: "assets/icons/home.svg", label: "Home"),
                      NavBarItem(
                        icon: "assets/icons/track.svg",
                        label: "Track",
                      ),
                      NavBarItem(
                        icon: "assets/icons/health.svg",
                        label: "Health",
                      ),
                      NavBarItem(icon: "assets/icons/plan.svg", label: "Plan"),
                      NavBarItem(
                        icon: "assets/icons/market.svg",
                        label: "Market",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
            },
          );
        },
      ),
    );
  }
}
