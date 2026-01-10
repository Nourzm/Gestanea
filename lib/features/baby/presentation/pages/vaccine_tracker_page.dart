import 'package:flutter/material.dart';

class VaccineTrackerPage extends StatelessWidget {

  final bool isGirl; // true for girl (pink), false for boy (blue)
  const VaccineTrackerPage({super.key, required this.isGirl});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isGirl ? Colors.pink.shade400 : Colors.blue.shade400;
    final Color backgroundColor = isGirl ? const Color(0xFFFFF5FA) : const Color(0xFFE8F1FF);
    final Color upcomingColor = isGirl ? Colors.pink.shade50 : Colors.blue.shade50;
    final Color textColor = isGirl ? Colors.pink.shade600 : Colors.blue.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Vaccine Tracker', style: TextStyle(color: primaryColor)),
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.notifications_none, color: primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Month Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left, color: Colors.grey[700]),
                  const SizedBox(width: 5),
                  const Text(
                    'March 2024',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.chevron_right, color: Colors.grey[700]),
                ],
              ),
              const SizedBox(height: 25),

              // Vaccine List
              Expanded(
                child: ListView(
                  children: [
                    vaccineCard(
                      title: 'BCG + HRV',
                      subtitle: 'Completed: Birth (Jan 15)',
                      completed: true,
                      primaryColor: primaryColor,
                      upcomingColor: upcomingColor,
                    ),
                    vaccineCard(
                      title: 'Rotavirus',
                      subtitle: 'Completed: 2 months (Feb 20)',
                      completed: true,
                      primaryColor: primaryColor,
                      upcomingColor: upcomingColor,
                    ),
                    vaccineCard(
                      title: 'PCV13',
                      subtitle: 'Upcoming: 2 months (April 10)',
                      completed: false,
                      primaryColor: primaryColor,
                      upcomingColor: upcomingColor,
                    ),
                    vaccineCard(
                      title: 'DTcaVPI-Hib-HBV',
                      subtitle: 'Upcoming: 3 months (May 10)',
                      completed: false,
                      primaryColor: primaryColor,
                      upcomingColor: upcomingColor,
                    ),
                  ],
                ),
              ),

              // See Full Schedule
              Center(
                child: Text(
                  'See Full Schedule',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget vaccineCard({
    required String title,
    required String subtitle,
    required bool completed,
    required Color primaryColor,
    required Color upcomingColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: completed ? Colors.green.shade50 : upcomingColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: completed ? Colors.green.shade300 : upcomingColor.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          completed ? Icons.check_circle : Icons.access_time,
          color: completed ? Colors.green : primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
