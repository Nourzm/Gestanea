import 'package:flutter/material.dart';

/// Displays an integer that flips on its horizontal axis in 3D whenever the
/// value changes — like a flip-clock digit. Pure-Flutter perspective transform,
/// no dependencies.
class FlipCounter3D extends StatelessWidget {
  final int value;
  final TextStyle style;
  final Duration duration;

  const FlipCounter3D({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 550),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final v = animation.value; // 0 → 1 incoming, 1 → 0 outgoing
            final angle = (1 - v) * (3.1415926 / 2); // 90° → 0°
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0018) // perspective depth
                ..rotateX(angle),
              child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
            );
          },
          child: child,
        );
      },
      child: Text('$value', key: ValueKey<int>(value), style: style),
    );
  }
}
