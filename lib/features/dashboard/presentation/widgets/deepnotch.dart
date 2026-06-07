import 'package:flutter/material.dart';

class DeepNotchPainter extends CustomPainter {
  final double notchCenterX;
  final double radius; // circle radius
  final double depth; // how deep the circle cuts inside the bar

  DeepNotchPainter({
    required this.notchCenterX,
    required this.radius,
    required this.depth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start top-left
    path.moveTo(0, 0);

    // Move to notch start
    path.lineTo(notchCenterX - radius - 12, 0);

    // Smooth dip into notch
    path.quadraticBezierTo(notchCenterX, depth, notchCenterX + radius + 12, 0);

    // Right side
    path.lineTo(size.width, 0);

    // Down to bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    // Soft shadow under bar
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.15), 10, true);

    // Draw actual bar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
