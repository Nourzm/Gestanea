// lib/features/pregnancy/presentation/pages/week_tracker_page.dart
import 'package:flutter/material.dart';


class WeekTrackerPage extends StatefulWidget {
  const WeekTrackerPage({super.key});

  @override
  State<WeekTrackerPage> createState() => _WeekTrackerPageState();
}

class _WeekTrackerPageState extends State<WeekTrackerPage> {
  int selectedWeek = 12; // TODO: Get from provider
  bool showWeight = true;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Track',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7FDB),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF9B7FDB),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weight and Length Toggle
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton('Weight', showWeight, () {
                      setState(() => showWeight = true);
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleButton('Length', !showWeight, () {
                      setState(() => showWeight = false);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input Field for Weight/Length
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showWeight ? 'Baby Weight' : 'Baby Length',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: showWeight ? _weightController : _lengthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: showWeight
                            ? 'Enter weight in grams'
                            : 'Enter length in cm',
                        suffixText: showWeight ? 'g' : 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF9B7FDB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Save measurement to provider/database
                          final value = showWeight
                              ? _weightController.text
                              : _lengthController.text;
                          if (value.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  showWeight
                                      ? 'Weight saved: $value g'
                                      : 'Length saved: $value cm',
                                ),
                                backgroundColor: const Color(0xFF9B7FDB),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9B7FDB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save Measurement'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fetal Visualization
              // FetalVisualizationWidget(week: selectedWeek),
              const SizedBox(height: 24),


              // Kick Counter Section
              const Text(
                'Kick Counter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}