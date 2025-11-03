import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/features/doctors/presentation/widgets/header.dart';
import 'package:pregnancy_baby_app/features/doctors/presentation/widgets/search_field.dart';
import 'package:pregnancy_baby_app/features/doctors/presentation/widgets/filter_bar.dart';
import 'package:pregnancy_baby_app/features/doctors/presentation/widgets/doctor_card.dart';
import 'package:pregnancy_baby_app/features/doctors/data/models/doctors_model.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Sarah Johnson',
      specialty: 'Cardiologist',
      distance: '0.8 km away',
      rating: 4.8,
      reviews: 156,
    ),
    Doctor(
      name: 'Dr. Michael Chen',
      specialty: 'General Practitioner',
      distance: '1.2 km away',
      rating: 4.6,
      reviews: 203,
    ),
    Doctor(
      name: 'Dr. Emily Rodriguez',
      specialty: 'Pediatrician',
      distance: '1.5 km away',
      rating: 4.9,
      reviews: 312,
    ),
    Doctor(
      name: 'Dr. James Williams',
      specialty: 'Dermatologist',
      distance: '2.1 km away',
      rating: 4.7,
      reviews: 189,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            DoctorsHeader(title: 'Doctors'),
            const SizedBox(height: 16),
            SearchField(
              controller: _searchController,
              hintText: 'Search doctors by name or specialty...',
              icon: Icons.search,
            ),
            const SizedBox(height: 12),
            SearchField(
              controller: _locationController,
              hintText: 'Enter your location...',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 20),
            DoctorsFilterBar(doctorCount: doctors.length),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return DoctorCard(doctor: doctors[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
