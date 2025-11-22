import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class CompactCard extends StatelessWidget {
  final VoidCallback onTap;

  const CompactCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Toggles the state to expanded
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: AppColors.shadow1,
          borderRadius: BorderRadius.circular(12),
          color: AppColors.main300,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Image Placeholder (The gray block)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 15),
            // Right Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pregnancy Pillow',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Essential nutrients and meal planning for a healthy pregnancy',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  // "5 min read" text
                  Text(
                    '5 min read',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
