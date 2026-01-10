// lib/features/baby/presentation/pages/baby_profile_page.dart
import 'package:flutter/material.dart';
import 'growth_tracker_page.dart';
import 'milestone_tracker_page.dart';

class BabyProfilePage extends StatelessWidget {
  const BabyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get data from BabyProvider
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Baby Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7FDB),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF9B7FDB)),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Baby Avatar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB6D9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.child_care, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Emma',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Info Cards
              _buildInfoCard('Gender', 'Female', Icons.female, const Color(0xFFFFB6D9)),
              const SizedBox(height: 12),
              _buildInfoCard('Date of Birth', 'July 15, 2024', Icons.cake, const Color(0xFF9B7FDB)),
              const SizedBox(height: 12),
              _buildInfoCard('Age', '3 months', Icons.access_time, const Color(0xFF87CEEB)),
              const SizedBox(height: 12),
              _buildInfoCard('Current Weight', '5.2 kg', Icons.monitor_weight, const Color(0xFFFFB6D9)),
              const SizedBox(height: 12),
              _buildInfoCard('Current Height', '58 cm', Icons.height, const Color(0xFF9B7FDB)),
              const SizedBox(height: 32),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GrowthTrackerPage()),
                    );
                  },
                  icon: const Icon(Icons.trending_up),
                  label: const Text('View Growth Chart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B7FDB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MilestoneTrackerPage()),
                    );
                  },
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Track Milestones'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9B7FDB),
                    side: const BorderSide(color: Color(0xFF9B7FDB), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
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
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}