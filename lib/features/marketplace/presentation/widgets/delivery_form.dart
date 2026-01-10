import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'neumorphic_section.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class DeliveryForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController instructionsController;

  const DeliveryForm({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.instructionsController,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.deliveryInformation,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            AppLocalizations.of(context)!.fullName,
            fullNameController,
            AppLocalizations.of(context)!.enterYourFullName,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            AppLocalizations.of(context)!.phoneNumber,
            phoneController,
            AppLocalizations.of(context)!.enterYourPhoneNumber,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            AppLocalizations.of(context)!.deliveryAddress,
            addressController,
            AppLocalizations.of(context)!.streetAddressApartment,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            AppLocalizations.of(context)!.city,
            cityController,
            AppLocalizations.of(context)!.enterYourCity,
          ),
          const SizedBox(height: 16),
          _buildFormField(
            AppLocalizations.of(context)!.specialInstructions,
            instructionsController,
            AppLocalizations.of(context)!.addDeliveryNotes,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontSize: 12,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        NeumorphicTextField(
          controller: controller,
          hintText: hint,
          maxLines: maxLines,
        ),
      ],
    );
  }
}

class NeumorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const NeumorphicTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white, width: 0.5),
        boxShadow: [
          const BoxShadow(
            color: AppColors.white,
            offset: Offset(-2.5, -2.5),
            blurRadius: 5,
            spreadRadius: -5,
            inset: true,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
            inset: true,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: themeData.primaryColor,
          fontSize: 14,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: themeData.primaryColor.withOpacity(0.4),
            fontSize: 14,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
