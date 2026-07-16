import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class CompactCard extends StatelessWidget {
  final VoidCallback onTap;

  final String title;
  final String description;
  final String readTime;
  final String? imagePath; // Optional custom image

  const CompactCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.readTime,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderImage = Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final imageWidget = imagePath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath!,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          )
        : placeholderImage;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.main300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            const SizedBox(width: 15),

            /// TEXT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    readTime,
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
