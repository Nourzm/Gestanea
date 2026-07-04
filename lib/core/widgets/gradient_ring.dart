import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An animated circular progress ring with a sweep-gradient stroke and a soft
/// outer glow, giving a tactile 3D-ish depth. Animates whenever [progress]
/// changes. Optionally centers a [child] inside the ring.
class AnimatedGradientRing extends StatelessWidget {
  final double progress; // 0..1
  final double size;
  final double strokeWidth;
  final List<Color> colors;
  final Color trackColor;
  final Widget? child;
  final Duration duration;

  const AnimatedGradientRing({
    super.key,
    required this.progress,
    required this.size,
    this.strokeWidth = 8,
    required this.colors,
    this.trackColor = const Color(0xFFEFE6FA),
    this.child,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return CustomPaint(
          painter: _RingPainter(
            progress: value,
            strokeWidth: strokeWidth,
            colors: colors,
            trackColor: trackColor,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;
  final Color trackColor;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * progress;

    // Track
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Glow underlay for depth
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..color = colors.last.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(rect, startAngle, sweep, false, glowPaint);

    // Gradient progress arc
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * math.pi,
      colors: colors,
      transform: const GradientRotation(-math.pi / 2),
    );
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);
    canvas.drawArc(rect, startAngle, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.strokeWidth != strokeWidth ||
      old.colors != colors ||
      old.trackColor != trackColor;
}
