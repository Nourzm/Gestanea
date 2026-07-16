import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class ExpandedCard extends StatelessWidget {
  final VoidCallback onCollapse;
  final VoidCallback onDetailsTap;

  final String title;
  final String description;
  final String readTime; // <-- add this
  final String? imagePath;

  const ExpandedCard({
    super.key,
    required this.onCollapse,
    required this.onDetailsTap,
    required this.title,
    required this.description,
    required this.readTime, // <-- add this
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = imagePath != null
        ? ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath!,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          )
        : ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.deepOrangeAccent,
              alignment: Alignment.center,
              child: const Text(
                'Image Here',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        boxShadow: AppColors.shadow1,
        borderRadius: BorderRadius.circular(12),
        color: AppColors.main300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(onTap: onCollapse, child: imageWidget),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        readTime, // <-- display it
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onDetailsTap,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
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
