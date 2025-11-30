import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';



class ClickableTipsCard extends StatefulWidget {
  final Widget targetPage;

  const ClickableTipsCard({
    super.key,
    required this.targetPage,
  });

  @override
  State<ClickableTipsCard> createState() => _ClickableTipsCardState();
}

class _ClickableTipsCardState extends State<ClickableTipsCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.targetPage),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.all(screenWidth * 0.045),
        decoration: BoxDecoration(
          color: AppColors.main500,
          borderRadius: BorderRadius.circular(25),
          boxShadow: _isPressed
              ? [
                  // Pressed shadow → smaller blur & offset
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(2, 1),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 5,
                    offset: const Offset(-2, -2),
                  ),
                ]
              : [
                  // Default floating shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(5, 3),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: const Offset(-5, -5),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/icons/stars.svg", width: 32),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'Our Tips',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'follow best practices',
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
