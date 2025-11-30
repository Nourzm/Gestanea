import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class PregnancyProgressCard extends StatelessWidget {
  const PregnancyProgressCard({super.key, required this.onTap});
  final void Function(int)  onTap;
  // Color Palette extracted from the image
  final Color bgLight = const Color(0xFFF8D9F8);
  final Color bgDark = const Color(0xFFF1C0F2);
  final Color textPurple = const Color(0xFF9C60CE);
  final Color labelPurple = const Color(0xFFA870CA);
  final Color ringBorder = const Color(0xFFAC6BDF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height:
                320, // Slightly shorter than total stack to allow button overhang
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgLight, bgDark],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomLeft: Radius.elliptical(120, 70),
                bottomRight: Radius.elliptical(120, 70),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 10,
                  offset: Offset(8, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0xFFFFFFFF),
                  blurRadius: 8,
                  offset: Offset(-7, -7),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Stat
                  Flexible(
                    flex: 2,
                    child: _buildStatItem(
                      value: "18.9%",
                      label: "DONE",
                      align: CrossAxisAlignment.center,
                    ),
                  ),

                  // Center Ring (The detailed part)
                  Expanded(flex: 4, child: _buildCentralRing()),

                  // Right Stat
                  Flexible(
                    flex: 2,
                    child: _buildStatItem(
                      value: "228",
                      label: "DAYS TO GO",
                      align: CrossAxisAlignment.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 10, // Adjust as needed
            child: GestureDetector(
              onTap: () => onTap(1),
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5, color: AppColors.main600),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x4C000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "More",
                      style: TextStyle(
                        color: textPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: textPurple),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralRing() {
    return Center(
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // This creates the soft white glow BEHIND the purple ring
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ringBorder,
              width: 5, // Thickness of the purple ring
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WEEK",
                style: TextStyle(
                  color: labelPurple,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "7",
                  style: TextStyle(
                    color: textPurple,
                    fontSize: 68,
                    fontWeight:
                        FontWeight.w300, // Thin font weight for the number
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "+3 day",
                style: TextStyle(
                  color: labelPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required CrossAxisAlignment align,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: textPurple,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: labelPurple,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
