// =============================================================================
// FILE: presentation/pages/feeding_log_page.dart
// =============================================================================

import 'package:flutter/material.dart';

class FeedingLogPage extends StatefulWidget {
  
  const FeedingLogPage({super.key});

  @override
  State<FeedingLogPage> createState() => _FeedingLogPageState();
}

class _FeedingLogPageState extends State<FeedingLogPage> {
  String selectedType = 'Breastfeed';

  // TODO: Load from database
  final List<Map<String, dynamic>> feedingLogs = [
    {
      'type': 'Breastfeed',
      'time': '2:30 PM',
      'duration': '15 min',
      'side': 'Left'
    },
    {
      'type': 'Bottle',
      'time': '11:00 AM',
      'amount': '120 ml',
      'side': null
    },
    {
      'type': 'Breastfeed',
      'time': '8:30 AM',
      'duration': '20 min',
      'side': 'Right'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          'Feeding Log',
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
              // Today's Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB6D9), Color(0xFFFFD6E8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Icon(Icons.restaurant, color: Colors.white, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '8 times', // TODO: Calculate from today's data
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white30,
                    ),
                    Column(
                      children: const [
                        Icon(Icons.timer, color: Colors.white, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '2h 15m', // TODO: Calculate from today's data
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Total Time',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feeding Type Selector
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton('Breastfeed', Icons.child_care),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton('Bottle', Icons.baby_changing_station),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Logs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Feedings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all feeding logs page
                      print('Navigate to All Feeding Logs');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Color(0xFF9B7FDB)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...feedingLogs.map((log) => _buildFeedingLogItem(log)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddFeedingDialog(context);
        },
        backgroundColor: const Color(0xFF9B7FDB),
        icon: const Icon(Icons.add),
        label: const Text('Add Feeding'),
      ),
    );
  }

  Widget _buildTypeButton(String type, IconData icon) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9B7FDB) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedingLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB6D9).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              log['type'] == 'Breastfeed'
                  ? Icons.child_care
                  : Icons.baby_changing_station,
              color: const Color(0xFFFFB6D9),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['type'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log['side'] != null
                      ? '${log['duration']} - ${log['side']} side'
                      : '${log['amount']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            log['time'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFeedingDialog(BuildContext context) {
    String feedingType = 'Breastfeed';
    final TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Add Feeding'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: feedingType,
                    decoration: InputDecoration(
                      labelText: 'Feeding Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Breastfeed', 'Bottle'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        feedingType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: feedingType == 'Breastfeed'
                          ? 'Duration (minutes)'
                          : 'Amount (ml)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: const Icon(Icons.access_time),
                      hintText: TimeOfDay.now().format(context),
                    ),
                    onTap: () {
                      // TODO: Show time picker
                      print('Show time picker');
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Save to database
                    print('Saving feeding: $feedingType - ${durationController.text}');
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B7FDB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}