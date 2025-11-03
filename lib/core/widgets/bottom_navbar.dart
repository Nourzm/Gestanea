import 'package:flutter/material.dart';

class NotchNavBarExample extends StatefulWidget {
  const NotchNavBarExample({super.key});

  @override
  State<NotchNavBarExample> createState() => _NotchNavBarExampleState();
}

class _NotchNavBarExampleState extends State<NotchNavBarExample> {
  int _selectedIndex = 0;

  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.search_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Text(
          "Page ${_selectedIndex + 1}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: CustomAnimatedNavBar(
        icons: icons,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class CustomAnimatedNavBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomAnimatedNavBar({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Moving notch
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            alignment: Alignment(
                (selectedIndex - (icons.length - 1) / 2) *
                    (2 / (icons.length - 1)),
                0),
            child: CustomPaint(
              painter: NotchPainter(),
              child: const SizedBox(width: 80, height: 70),
            ),
          ),

          // Icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected ? Colors.deepPurple.withOpacity(0.1) : null,
                  ),
                  child: Icon(
                    icons[index],
                    size: isSelected ? 32 : 28,
                    color:
                        isSelected ? Colors.deepPurpleAccent : Colors.grey[500],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class NotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.deepPurpleAccent;
    final Path path = Path();

    // Draw the curved notch shape
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.3,
        size.width * 0.5, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.3,
        size.width, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
