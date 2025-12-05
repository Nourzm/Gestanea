import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class FancyNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavBarItem> items;

  const FancyNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / items.length;

    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // WHITE BAR WITH NOTCH
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _NotchedBarPainter(
                notchCenterX: width * currentIndex + width / 2,
                notchRadius: 40, // deeper notch
                borderRadius: 20
              ),
              child: Container(height: 75),
            ),
          ),

          // FLOATING CIRCLE
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: 45, // pushed deeper inside notch
            left: width * currentIndex + (width - 75) / 2,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: AppColors.main500,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.main500.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  items[currentIndex].icon,
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),

          // BOTTOM ICONS + LABELS
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final active = i == currentIndex;

                return GestureDetector(
                  onTap: () => onTap(i),
                  child: SizedBox(
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!active)
                          SvgPicture.asset(
                            items[i].icon,
                            width: 30,
                            height: 30,
                            colorFilter: const ColorFilter.mode(
                              Color(0xff999EA7),
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          const SizedBox(height: 26), // keeps layout aligned

                        const SizedBox(height: 8),

                        Text(
                          items[i].label,
                          style: TextStyle(
                            fontSize: 13,
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
  final double borderRadius; // new parameter for corner radius

  _NotchedBarPainter({
    required this.notchCenterX,
    required this.notchRadius,
    required this.borderRadius, // default radius
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    // top-left corner
    path.moveTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    // left side of notch
    path.lineTo(notchCenterX - notchRadius * 1.2, 0);

    // smooth arc
    path.quadraticBezierTo(
      notchCenterX,
      notchRadius * 1.9,
      notchCenterX + notchRadius * 1.2,
      0,
    );

    // top-right corner
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // right side
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - borderRadius, size.height);

    // bottom side
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
