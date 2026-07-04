// lib/features/pregnancy/presentation/widgets/fetal_visualization_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/flip_counter_3d.dart';
import 'package:gestanea/core/widgets/gradient_ring.dart';

/// Animated, pseudo-3D illustration of the baby for the given week.
///
/// - A gradient progress ring shows how far along the pregnancy is (week / 40).
/// - The baby gently floats and "breathes", with a subtle perspective tilt for
///   a 3D feel (CSS-style transform — there is no 3D model asset).
/// - A week-specific "size of a…" comparison is shown below.
class FetalVisualizationWidget extends StatefulWidget {
  final int week;
  final int totalWeeks;

  /// When placed on a dark/gradient hero, switches the ring to white tones.
  final bool onDark;

  /// Whether to render the built-in "size of a…" pill below the ring.
  final bool showSizeComparison;

  /// Bare mode: just the floating baby image (no ring, disc, halo or badge) —
  /// for placing directly on a soft gradient panel.
  final bool bare;

  /// Whether to show the "Week X" badge at the bottom of the disc.
  final bool showBadge;

  const FetalVisualizationWidget({
    super.key,
    required this.week,
    this.totalWeeks = 40,
    this.onDark = false,
    this.showSizeComparison = true,
    this.bare = false,
    this.showBadge = true,
  });

  @override
  State<FetalVisualizationWidget> createState() =>
      _FetalVisualizationWidgetState();
}

class _FetalVisualizationWidgetState extends State<FetalVisualizationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Standard pregnancy-app size comparisons at milestone weeks.
  static const Map<int, String> _sizeComparison = {
    4: 'a poppy seed',
    6: 'a lentil',
    8: 'a raspberry',
    10: 'a strawberry',
    12: 'a lime',
    14: 'a lemon',
    16: 'an avocado',
    20: 'a banana',
    24: 'an ear of corn',
    28: 'an eggplant',
    32: 'a squash',
    36: 'a head of lettuce',
    40: 'a small pumpkin',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _sizeFor(int w) {
    final keys = _sizeComparison.keys.toList()..sort();
    int closest = keys.first;
    for (final k in keys) {
      if ((k - w).abs() < (closest - w).abs()) closest = k;
    }
    return _sizeComparison[closest]!;
  }

  Widget _floatingChild(Widget child) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, c) {
        final t = _controller.value * 2 * math.pi;
        final bob = math.sin(t) * 6;
        final breathe = 1 + math.sin(t) * 0.02;
        final tiltY = math.sin(t) * 0.10;
        final tiltX = math.cos(t) * 0.05;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(tiltY)
            ..rotateX(tiltX)
            ..translateByDouble(0.0, bob, 0.0, 1.0)
            ..scaleByDouble(breathe, breathe, 1.0, 1.0),
          child: c,
        );
      },
      child: child,
    );
  }

  Widget _babyImage({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/fetus.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) => const Center(
          child: Icon(Icons.pregnant_woman, size: 90, color: AppColors.main400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Bare mode: just the floating baby on whatever sits behind it.
    if (widget.bare) {
      return Center(child: _floatingChild(_babyImage(size: 210)));
    }

    final progress = (widget.week / widget.totalWeeks).clamp(0.0, 1.0);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 240,
            height: 240,
            child: AnimatedGradientRing(
              progress: progress,
              size: 240,
              strokeWidth: 9,
              colors: widget.onDark
                  ? [Colors.white.withValues(alpha: 0.85), Colors.white]
                  : const [
                      AppColors.main500,
                      AppColors.main600,
                      AppColors.main700,
                    ],
              trackColor: widget.onDark
                  ? Colors.white.withValues(alpha: 0.22)
                  : const Color(0xFFEFE6FA),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final t = _controller.value * 2 * math.pi;
                  final bob = math.sin(t) * 6; // vertical float
                  final breathe = 1 + math.sin(t) * 0.02; // scale pulse
                  final tiltY = math.sin(t) * 0.10; // 3D rotation
                  final tiltX = math.cos(t) * 0.05;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012) // perspective
                      ..rotateY(tiltY)
                      ..rotateX(tiltX)
                      ..translateByDouble(0.0, bob, 0.0, 1.0)
                      ..scaleByDouble(breathe, breathe, 1.0, 1.0),
                    child: child,
                  );
                },
                child: _buildDisc(),
              ),
            ),
          ),
          if (widget.showSizeComparison) ...[
            const SizedBox(height: 14),
            _buildSizeComparison(),
          ],
        ],
      ),
    );
  }

  Widget _buildDisc() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft halo for depth
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.main300,
                AppColors.main300.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        // Main disc
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.main600.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Image.asset(
            'assets/images/fetus.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => const Center(
              child: Icon(
                Icons.pregnant_woman,
                size: 90,
                color: AppColors.main400,
              ),
            ),
          ),
        ),
        // Week badge
        if (widget.showBadge)
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.main500, AppColors.main600],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.main600.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Week ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  FlipCounter3D(
                    value: widget.week,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSizeComparison() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.main300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco, size: 16, color: AppColors.main600),
          const SizedBox(width: 6),
          Text(
            'About the size of ${_sizeFor(widget.week)}',
            style: const TextStyle(
              color: AppColors.main700,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
