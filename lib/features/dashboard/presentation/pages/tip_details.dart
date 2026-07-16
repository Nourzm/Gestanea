import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class WavyShadowAndFillPainter extends CustomPainter {
  const WavyShadowAndFillPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // ---- PATH ----
    final Path path = Path()
      ..lineTo(size.width, size.height * 1.02)
      ..cubicTo(
        size.width,
        size.height * 1.02,
        0,
        size.height * 1.02,
        0,
        size.height * 1.02,
      )
      ..cubicTo(0, size.height * 1.02, 0, size.height / 4, 0, size.height / 4)
      ..cubicTo(
        0,
        size.height / 4,
        size.width * 0.22,
        size.height * 0.14,
        size.width * 0.56,
        size.height * 0.17,
      )
      ..cubicTo(
        size.width * 0.87,
        size.height * 0.19,
        size.width,
        size.height * 0.02,
        size.width,
        size.height * 0.02,
      )
      ..cubicTo(
        size.width,
        size.height * 0.02,
        size.width,
        size.height * 1.02,
        size.width,
        size.height * 1.02,
      );

    // ---- BACKGROUND GRADIENT ----
    final Paint mainGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [AppColors.main600, Color.fromARGB(255, 206, 157, 252)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw both gradients as combined layers
    canvas.drawPath(path, mainGradient);

    // ---- NORMAL SHADOW ---- (0px -4px 10px rgba(0,0,0,0.3))
    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 10, false);

    // ---- INSET SHADOW ---- (inset 0px 2px 10px rgba(255,255,255,0.3))
    final Paint insetShadow = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.saveLayer(Rect.largest, Paint());
    canvas.drawPath(path, insetShadow);
    canvas.drawPath(path, Paint()..blendMode = BlendMode.dstOut);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomCurvedPage extends StatelessWidget {
  const CustomCurvedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/onboarding5.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      color: const Color(
                        0xFF8A2BE2,
                      ).withOpacity(0.3), // Purple overlay
                    ),
                    Positioned(
                      top: 10,
                      left: 16,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Healthy Nutrition',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -MediaQuery.of(context).size.height * 0.28),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  width: double.infinity,
                  child: CustomPaint(
                    painter: const WavyShadowAndFillPainter(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top:
                            MediaQuery.of(context).size.height * 0.75 * 0.05 +
                            20, // A refined estimate to clear the peak.
                        left: 20,
                        right: 20,
                      ),
                      child: _buildDummyContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDummyContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 140),

      // Title
      const Text(
        'Healthy Nutrition',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),

      // Description
      const Text(
        'Include a variety of fruits, vegetables, lean proteins, and whole grains to support both mother and baby.',
        style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
      ),
      const SizedBox(height: 20),

      // Section header
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Quick Tips',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 12),

      // Tips list
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '• Eat a rainbow of fruits and vegetables every day.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 6),
          Text(
            '• Include lean proteins such as chicken, fish, beans, and tofu.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          SizedBox(height: 6),
          Text(
            '• Prefer whole grains like brown rice, oats, and whole wheat bread.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Featured section
      const Text(
        'Featured Article',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 12),

      // Featured card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Balancing Nutrients for Pregnancy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Learn how to combine fruits, vegetables, proteins, and grains to nourish both mother and baby.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
