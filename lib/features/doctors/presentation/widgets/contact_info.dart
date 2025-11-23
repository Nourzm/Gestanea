import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class ContactInfoSection extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const ContactInfoSection({super.key, required this.doctor});

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
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
          child: Icon(icon, size: 20, color: AppColors.main600),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.main300,
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
          Text('Contact Information', style: AppTextStyles.headline2),
          const SizedBox(height: 20),
          _buildContactItem(
            icon: Icons.location_on_outlined,
            title: 'Address',
            content: doctor['address'],
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            content: doctor['phone_number'],
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.access_time_outlined,
            title: 'Opening Hours',
            content: doctor['opening_hours'],
          ),
        ],
      ),
    );
  }
}
