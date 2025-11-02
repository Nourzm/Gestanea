import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';

class WeightProgressChart extends StatelessWidget {
  const WeightProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purpleGrey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF90EE90),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'On Track',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: Size(double.infinity, 180),
              painter: WeightChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class WeightChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.main500
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = AppColors.main500
      ..style = PaintingStyle.fill;

    // Chart data points (W20 to W24)
    final dataPoints = [
      {'week': 'W20', 'weight': 60.0},
      {'week': 'W21', 'weight': 65.0},
      {'week': 'W22', 'weight': 68.0},
      {'week': 'W23', 'weight': 70.0},
      {'week': 'W24', 'weight': 72.0},
    ];

    final maxWeight = 80.0;
    final minWeight = 0.0;
    final weekCount = dataPoints.length;

    // Calculate positions
    final chartWidth = size.width - 40;
    final chartHeight = size.height - 40;
    final horizontalStep = chartWidth / (weekCount - 1);

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < dataPoints.length; i++) {
      final weight = dataPoints[i]['weight'] as double;
      final x = 20 + (i * horizontalStep);
      final y = size.height - 20 - ((weight - minWeight) / (maxWeight - minWeight) * chartHeight);
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 6, pointPaint);
    }

    // Draw Y-axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 4; i++) {
      final value = (maxWeight / 4 * i).toInt();
      final y = size.height - 20 - (i * chartHeight / 4);
      
      textPainter.text = TextSpan(
        text: value.toString(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    // Draw X-axis labels
    for (int i = 0; i < dataPoints.length; i++) {
      final week = dataPoints[i]['week'] as String;
      final x = 20 + (i * horizontalStep);
      
      textPainter.text = TextSpan(
        text: week,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - 15));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}