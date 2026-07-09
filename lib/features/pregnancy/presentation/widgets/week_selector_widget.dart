// lib/features/pregnancy/presentation/widgets/week_selector_widget.dart
import 'package:flutter/material.dart';

class WeekSelectorWidget extends StatelessWidget {
  final int currentWeek;
  final Function(int) onWeekSelected;

  const WeekSelectorWidget({
    super.key,
    required this.currentWeek,
    required this.onWeekSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 40,
            itemBuilder: (context, index) {
              final week = index + 1;
              final isSelected = week == currentWeek;
              return GestureDetector(
                onTap: () => onWeekSelected(week),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9B7FDB) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF9B7FDB)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$week',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select Week',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
