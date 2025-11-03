// =============================================================================
// FILE: presentation/pages/milestone_tracker_page.dart
// =============================================================================

import 'package:flutter/material.dart';

class MilestoneTrackerPage extends StatefulWidget {
  const MilestoneTrackerPage({super.key});

  @override
  State<MilestoneTrackerPage> createState() => _MilestoneTrackerPageState();
}

class _MilestoneTrackerPageState extends State<MilestoneTrackerPage> {
  // TODO: Load from database
  final List<Map<String, dynamic>> milestones = [
    {
      'title': 'First Smile',
      'age': '6 weeks',
      'completed': true,
      'date': 'Aug 26, 2024'
    },
    {
      'title': 'Holds Head Up',
      'age': '2 months',
      'completed': true,
      'date': 'Sep 15, 2024'
    },
    {
      'title': 'Rolls Over',
      'age': '4 months',
      'completed': false,
      'date': null
    },
    {
      'title': 'Sits Without Support',
      'age': '6 months',
      'completed': false,
      'date': null
    },
    {
      'title': 'Crawls',
      'age': '8 months',
      'completed': false,
      'date': null
    },
    {
      'title': 'First Words',
      'age': '12 months',
      'completed': false,
      'date': null
    },
  ];

  @override
  Widget build(BuildContext context) {
    int completedCount = milestones.where((m) => m['completed'] == true).length;
    int totalCount = milestones.length;
    double percentage = (completedCount / totalCount * 100);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Milestones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7FDB),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B7FDB), Color(0xFFD4B5E8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$completedCount/$totalCount',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${percentage.toInt()}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Milestones List
              const Text(
                'Developmental Milestones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...milestones.map((milestone) => _buildMilestoneItem(
                    milestone['title'],
                    milestone['age'],
                    milestone['completed'],
                    milestone['date'],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneItem(
    String title,
    String age,
    bool completed,
    String? date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed ? const Color(0xFF9B7FDB) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed ? const Color(0xFF9B7FDB) : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed ? Icons.check : Icons.emoji_events_outlined,
              color: completed ? Colors.white : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration:
                        completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completed && date != null
                      ? 'Completed: $date'
                      : 'Expected at $age',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!completed)
            IconButton(
              onPressed: () {
                setState(() {
                  // TODO: Mark milestone as completed and save to database
                  print('Mark $title as completed');
                });
              },
              icon: const Icon(Icons.check_circle_outline),
              color: const Color(0xFF9B7FDB),
            ),
        ],
      ),
    );
  }
}

