import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class FancyNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavBarItem> items;
  final double barHeight;
  const FancyNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items, required this.barHeight,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // --- RESPONSIVE VALUES ---
    final notchSize = w * 0.10; // size of notch curve
    final circleSize = w * 0.18; // floating circle size
    final iconSizeActive = w * 0.09; // active middle icon size
    final iconSizeInactive = w * 0.065; // inactive icons
    final itemWidth = w / items.length;
    final bottomPadding = h * 0.015; // space for labels

    return SizedBox(
      height: barHeight + circleSize * 0.6,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // -------------------------
          // WHITE BAR WITH NOTCH
          // -------------------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _NotchedBarPainter(
                notchCenterX: itemWidth * currentIndex + itemWidth / 2,
                notchRadius: notchSize,
                borderRadius: 20,
              ),
              child: Container(height: barHeight),
            ),
          ),

          // -------------------------
          // FLOATING CIRCLE
          // -------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: barHeight - circleSize * 0.40,
            left: itemWidth * currentIndex + (itemWidth - circleSize) / 2,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: AppColors.main500,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.main500.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  items[currentIndex].icon,
                  width: iconSizeActive,
                  height: iconSizeActive,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),

          // -------------------------
          // ICONS & LABELS
          // -------------------------
          Positioned(
            bottom: bottomPadding,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final active = i == currentIndex;

                return GestureDetector(
                  onTap: () => onTap(i),
                  child: SizedBox(
                    width: itemWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!active)
                          SvgPicture.asset(
                            items[i].icon,
                            width: iconSizeInactive,
                            height: iconSizeInactive,
                            colorFilter: ColorFilter.mode(
                              Colors.grey.shade500,
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          SizedBox(height: iconSizeInactive),

                        SizedBox(height: h * 0.005),

                        Text(
                          items[i].label,
                          style: TextStyle(
                            fontSize: w * 0.033, // responsive
                            fontWeight: FontWeight.w600,
                            color: active
                                ? AppColors.main500
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem {
  final String icon;
  final String label;

  NavBarItem({required this.icon, required this.label});
}

class _NotchedBarPainter extends CustomPainter {
  final double notchCenterX;
  final double notchRadius;
  final double borderRadius;

  _NotchedBarPainter({
    required this.notchCenterX,
    required this.notchRadius,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    path.lineTo(notchCenterX - notchRadius * 1.2, 0);

    path.quadraticBezierTo(
      notchCenterX,
      notchRadius * 1.9,
      notchCenterX + notchRadius * 1.2,
      0,
    );

    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - borderRadius,
      size.height,
    );

    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
