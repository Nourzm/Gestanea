// lib/features/pregnancy/presentation/widgets/fetal_visualization_widget.dart
import 'package:flutter/material.dart';

class FetalVisualizationWidget extends StatelessWidget {
  final int week;

  const FetalVisualizationWidget({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Image.asset('assets/images/baby_not_born.png'),
          // TODO: Replace with actual fetus image
          // Image.asset(
          //   'assets/images/fetus/week_$week.png',
          //   width: 150,
          //   height: 150,
          //   fit: BoxFit.contain,
          // ),
        ),
      ),
    );
  }
}