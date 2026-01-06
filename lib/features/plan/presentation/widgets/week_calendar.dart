import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class WeekCalendar extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final double screenWidth;
  final double screenHeight;

  const WeekCalendar({
    Key? key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDateSelected,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((date) {
        final isSelected = date.day == selectedDate.day;
        final weekdayLabel = [
          localizations.sundayShort,
          localizations.mondayShort,
          localizations.tuesdayShort,
          localizations.wednesdayShort,
          localizations.thursdayShort,
          localizations.fridayShort,
          localizations.saturdayShort,
        ][date.weekday % 7];
        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            width: screenWidth * 0.12,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
            decoration: isSelected
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [themeData.primaryColor, themeData.lightColor],
                    ),
                    borderRadius: BorderRadius.circular(20),
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
                  )
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
            child: Column(
              children: [
                Text(
                  weekdayLabel,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
