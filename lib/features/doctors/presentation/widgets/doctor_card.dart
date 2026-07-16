import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'doctor_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({Key? key, required this.doctor, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeData.lightColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: themeData.lightColor.withOpacity(0.3),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildDoctorAvatar(themeData),
            const SizedBox(width: 12),
            Expanded(child: DoctorInfo(doctor: doctor)),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(themeData) {
    const double size = 60;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [themeData.primaryColor, themeData.secondaryColor],
        ),

        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: themeData.secondaryColor.withOpacity(0.4),
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
