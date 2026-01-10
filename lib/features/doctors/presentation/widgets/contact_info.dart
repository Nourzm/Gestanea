import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class ContactInfoSection extends StatelessWidget {
  final DoctorModel doctor;

  const ContactInfoSection({super.key, required this.doctor});

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required themeData,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.bg_1,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(2, 2),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.white,
                blurRadius: 6,
                offset: Offset(-3, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: themeData.secondaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.smallLabel),
              const SizedBox(height: 4),
              Text(
                content,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeData.lightColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.contactInformation, style: AppTextStyles.headline2),
          const SizedBox(height: 20),
          _buildContactItem(
            icon: Icons.location_on_outlined,
            title: l10n.address,
            content: doctor.address ?? 'N/A',
            themeData: themeData,
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: l10n.phoneNumber,
            content: doctor.phone ?? 'N/A',
            themeData: themeData,
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.access_time_outlined,
            title: l10n.openingHours,
            content: 'Mon-Sat: 8:00 AM - 6:00 PM',
            themeData: themeData,
          ),
        ],
      ),
    );
  }
}
