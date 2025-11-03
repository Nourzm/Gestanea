import 'package:flutter/material.dart';

// Import your pages
import '../../../baby/presentation/pages/feeding_log_page.dart';
import '../../../baby/presentation/pages/growth_tracker_page.dart';
import '../../../baby/presentation/pages/milestone_tracker_page.dart';
import '../../../baby/presentation/pages/vaccine_tracker_page.dart';

class PostpartumTrackPage extends StatelessWidget {
  final String babyGender;

  const PostpartumTrackPage({super.key, required this.babyGender});

  @override
  Widget build(BuildContext context) {
    final bool isGirl = babyGender.toLowerCase() == 'girl';

    final List<Map<String, dynamic>> trackItems = [
      {
        'title': 'Feeding Log',
        'icon': Icons.local_drink,
        'color': isGirl ? Colors.pink[100] : Colors.blue[100],
        'page': const FeedingLogPage(),
      },
      {
        'title': 'Growth Tracker',
        'icon': Icons.monitor_weight,
        'color': isGirl ? Colors.pink[200] : Colors.blue[200],
        'page': const GrowthTrackerPage(),
      },
      {
        'title': 'Milestone',
        'icon': Icons.flag,
        'color': isGirl ? Colors.pink[50] : Colors.blue[50],
        'page': const MilestoneTrackerPage(),
      },
      {
        'title': 'Vaccine',
        'icon': Icons.vaccines,
        'color': isGirl ? Colors.pink[50] : Colors.blue[50],
        'page': VaccineTrackerPage(isGirl: isGirl), // ✅ Pass gender here
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Baby Progress"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: trackItems.map((item) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['page']),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 50, color: Colors.deepPurple),
                    const SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
