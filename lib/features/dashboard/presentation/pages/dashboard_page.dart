// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/dashboard/presentation/pages/home_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _controller = NotchBottomBarController(index: 0);
  int _selectedIndex = 0;

  final _pages = const [
    HomeScreen(),
    Center(child: Text('Track Page')),
    Center(child: Text('Health Page')),
    Center(child: Text('Plan Page')),
    Center(child: Text('Market Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        circleMargin: 10,
        topMargin: 10,
        removeMargins: true,
        kIconSize: 32,
        kBottomRadius: 0,
        color: AppColors.white,
        showLabel: true,
        notchColor: AppColors.main500,
        bottomBarWidth: double.infinity,
        bottomBarHeight: 40,
        durationInMilliSeconds: 300,

        /// Customize the item appearance
        itemLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        /// Pages count = icons count
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },

        /// Your items here:
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Center(
              child: SvgPicture.asset(
                'assets/icons/home.svg',
                height: 32,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeItem: Center(
              child: SvgPicture.asset(
                'assets/icons/home.svg',
                height: 32,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),

            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              'assets/icons/track.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeItem: Center(
              child: SvgPicture.asset(
                'assets/icons/track.svg',
                height: 32,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            itemLabel: 'Track',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              'assets/icons/health.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              'assets/icons/health.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            itemLabel: 'Health',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              'assets/icons/plan.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              'assets/icons/plan.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            itemLabel: 'Plan',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              'assets/icons/market.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              'assets/icons/market.svg',
              height: 32,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            itemLabel: 'Market',
          ),
        ],
      ),
    );
  }
}
