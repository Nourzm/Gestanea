import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class ExpandedCard extends StatelessWidget {
  final VoidCallback onCollapse;
  final VoidCallback onDetailsTap; // Action for the arrow button

  const ExpandedCard({
    super.key,
    required this.onCollapse,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        boxShadow: AppColors.shadow1,
        borderRadius: BorderRadius.circular(12),
        color: AppColors.main300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image Section
          GestureDetector(
            onTap: onCollapse, // Toggles the state back to compact
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              // Replace this Container with your actual Image.network or Image.asset
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.deepOrangeAccent, // Placeholder color
                alignment: Alignment.center,
                child: const Text(
                  'Food Image Here',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Bottom Text and Arrow Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pregnancy Pillow',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Essential nutrients and meal planning for a healthy pregnancy',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // The Arrow Button to redirect to the details page
                InkWell(
                  onTap: onDetailsTap, // This handles the redirection
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor, // Purple circle
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
