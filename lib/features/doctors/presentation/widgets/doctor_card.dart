import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/features/doctors/presentation/pages/doctor_details.dart';
import 'doctor_info.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onTap;

  const DoctorCard({Key? key, required this.doctor, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          // Navigate to doctor details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(doctor: doctor),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.main300,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.main400.withOpacity(0.3),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildDoctorAvatar(),
            const SizedBox(width: 12),
            Expanded(child: DoctorInfo(doctor: doctor)),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar() {
    const double size = 60;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.main500, AppColors.main600],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.main600.withOpacity(0.4),
            offset: const Offset(2, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.userDoctor,
          color: AppColors.white,
          size: size * 0.4,
        ),
      ),
    );
  }
}
