import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:gestanea/features/dashboard/logic/cubit/dashboard_state.dart';

class PregnancyProgressCard extends StatelessWidget {
  const PregnancyProgressCard({super.key, required this.onTap});
  final void Function(int)  onTap;
  // Color Palette extracted from the image
  final Color bgLight = const Color(0xFFF8D9F8);
  final Color bgDark = const Color(0xFFF1C0F2);
  final Color textPurple = const Color(0xFF9C60CE);
  final Color labelPurple = const Color(0xFFA870CA);
  final Color ringBorder = const Color(0xFFAC6BDF);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        // Extract pregnancy data from state
        int currentWeek = 1;
        int currentDay = 0;
        int daysLeft = 280;
        double progressPercentage = 0;

        if (state is PregnancyDashboardLoaded) {
          currentWeek = state.dashboard.currentWeek;
          currentDay = state.dashboard.currentDay;
          daysLeft = state.dashboard.daysLeft;
          progressPercentage = state.dashboard.progressPercentage;
        }

        return SizedBox(
          height: 280,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [bgLight, bgDark],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomLeft: Radius.elliptical(120, 70),
                    bottomRight: Radius.elliptical(120, 70),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 10,
                      offset: Offset(8, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0xFFFFFFFF),
                      blurRadius: 8,
                      offset: Offset(-7, -7),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Stat - Progress percentage
                      Flexible(
                        flex: 2,
                        child: _buildStatItem(
                          value: "${progressPercentage.toStringAsFixed(1)}%",
                          label: "DONE",
                          align: CrossAxisAlignment.center,
                        ),
                      ),

                      // Center Ring with week and day
                      Expanded(
                        flex: 4, 
                        child: _buildCentralRing(currentWeek, currentDay),
                      ),

                      // Right Stat - Days left
                      Flexible(
                        flex: 2,
                        child: _buildStatItem(
                          value: "$daysLeft",
                          label: "DAYS TO GO",
                          align: CrossAxisAlignment.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 10,
                child: GestureDetector(
                  onTap: () => onTap(1),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: AppColors.main600),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x4C000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "More",
                          style: TextStyle(
                            color: textPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16, color: textPurple),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCentralRing(int week, int day) {
    return Center(
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // This creates the soft white glow BEHIND the purple ring
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.6),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ringBorder,
              width: 5, // Thickness of the purple ring
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WEEK",
                style: TextStyle(
                  color: labelPurple,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$week",
                  style: TextStyle(
                    color: textPurple,
                    fontSize: 68,
                    fontWeight:
                        FontWeight.w300, // Thin font weight for the number
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "+$day day${day != 1 ? 's' : ''}",
                style: TextStyle(
                  color: labelPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required CrossAxisAlignment align,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: textPurple,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: labelPurple,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
