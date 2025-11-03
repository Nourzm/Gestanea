// lib/features/pregnancy/presentation/pages/week_tracker_page.dart
import 'package:flutter/material.dart';
import '../../../../main.dart' show routeObserver;
import '../widgets/week_selector_widget.dart';
import '../widgets/fetal_visualization_widget.dart';
import '../widgets/pregnancy_progress_bar.dart';
import '../widgets/kick_counter_widget.dart';

class WeekTrackerPage extends StatefulWidget {
  const WeekTrackerPage({super.key});

  @override
  State<WeekTrackerPage> createState() => _WeekTrackerPageState();
}

class _WeekTrackerPageState extends State<WeekTrackerPage> with RouteAware {
  int selectedWeek = 12; // TODO: Get from provider
  bool showWeight = true;
  bool _showForm = false; // ✅ Controls form visibility

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _weightController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  // ✅ When returning from another page, reset the form visibility
  @override
  void didPopNext() {
    setState(() {
      _showForm = false;
    });
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showWeight = true;
                          _showForm = true;
                        });
                      },
                      child: _buildToggleButton('Weight', showWeight),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showWeight = false;
                          _showForm = true;
                        });
                      },
                      child: _buildToggleButton('Length', !showWeight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ✅ Only show the form when a toggle is tapped
              if (_showForm)
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
                        controller: showWeight
                            ? _weightController
                            : _lengthController,
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
                              setState(() {
                                _showForm = false; // ✅ Hide after submit
                                 _weightController.clear();
                                 _lengthController.clear();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9B7FDB),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save Measurement',style: TextStyle(color:Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              FetalVisualizationWidget(week: selectedWeek),
              const SizedBox(height: 24),

              WeekSelectorWidget(
                currentWeek: selectedWeek,
                onWeekSelected: (week) {
                  setState(() => selectedWeek = week);
                },
              ),
              const SizedBox(height: 24),

              const PregnancyProgressBar(
                currentWeek: 12,
                currentDay: 3,
                trimester: '1st Trimester',
                daysLeft: 228,
                dueDate: 'Jul 07, 2024',
              ),
              const SizedBox(height: 32),

              const Text(
                'Kick Counter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const KickCounterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Container(
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
    );
  }
}
