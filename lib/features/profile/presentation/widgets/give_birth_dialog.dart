// lib/features/profile/presentation/widgets/give_birth_dialog.dart
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class GiveBirthDialog extends StatefulWidget {
  const GiveBirthDialog({super.key});

  @override
  State<GiveBirthDialog> createState() => _GiveBirthDialogState();
}

class _GiveBirthDialogState extends State<GiveBirthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  DateTime _dateOfBirth = DateTime.now();
  String _gender = 'girl';
  bool _autoValidate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.main600,
              onPrimary: Colors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.bg_1,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _submit() {
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState!.validate()) {
      final result = {
        'name': _nameController.text.trim(),
        'dateOfBirth': _dateOfBirth,
        'gender': _gender,
        'birthWeight': _weightController.text.isNotEmpty
            ? double.tryParse(_weightController.text)
            : null,
        'birthHeight': _heightController.text.isNotEmpty
            ? double.tryParse(_heightController.text)
            : null,
      };
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    
    // Responsive sizing
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final dialogMaxWidth = screenWidth * 0.9;
    final dialogMaxHeight = screenHeight * 0.85;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: dialogMaxWidth,
          maxHeight: dialogMaxHeight,
        ),
        decoration: BoxDecoration(
          color: AppColors.bg_1,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section with Icon
                _buildHeader(screenWidth),
                SizedBox(height: screenHeight * 0.03),

                // Baby Name Field
                _buildNeumorphicTextField(
                  label: 'Baby\'s Name',
                  hint: 'Enter baby\'s name',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter baby\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),

                // Date of Birth Field
                _buildDateField(screenWidth),
                SizedBox(height: screenHeight * 0.02),

                // Gender Selection
                _buildGenderSelector(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.02),

                // Weight and Height Fields (Side by Side)
                Row(
                  children: [
                    Expanded(
                      child: _buildNeumorphicTextField(
                        label: 'Birth Weight',
                        hint: 'kg',
                        controller: _weightController,
                        icon: Icons.monitor_weight_outlined,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        isOptional: true,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: _buildNeumorphicTextField(
                        label: 'Birth Height',
                        hint: 'cm',
                        controller: _heightController,
                        icon: Icons.height,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        isOptional: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                // Action Buttons
                _buildActionButtons(screenWidth, screenHeight, t),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.alerts.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.035),
            decoration: BoxDecoration(
              color: AppColors.alerts,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.alerts.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.child_care,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Congratulations!',
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.alerts,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  'Tell us about your baby',
                  style: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.6),
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isOptional = false,
  }) {
    final errorText = _autoValidate && validator != null
        ? validator(controller.text)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isOptional)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.main600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: errorText != null
                ? Border.all(color: Colors.red.withOpacity(0.5), width: 1.5)
                : null,
            boxShadow: [
              const BoxShadow(
                color: AppColors.white,
                offset: Offset(-2.5, -2.5),
                blurRadius: 5,
                spreadRadius: -5,
                inset: true,
              ),
              BoxShadow(
                color: errorText != null
                    ? Colors.red.withOpacity(0.15)
                    : const Color(0xFF000000).withOpacity(0.25),
                offset: const Offset(2.5, 2.5),
                blurRadius: 5,
                inset: true,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: errorText != null
                    ? Colors.red.withOpacity(0.7)
                    : AppColors.main600,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isOptional)
                      Text(
                        label,
                        style: TextStyle(
                          color: AppColors.main400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    TextFormField(
                      controller: controller,
                      keyboardType: keyboardType ?? TextInputType.text,
                      validator: validator,
                      autovalidateMode: _autoValidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.4),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        errorText: null, // We show error below
                      ),
                      onChanged: (value) {
                        if (_autoValidate) {
                          setState(() {}); // Re-validate on change
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateField(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Date of Birth',
            style: TextStyle(
              color: AppColors.main600,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
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
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.main600, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(_dateOfBirth),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to change date',
                        style: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.main600.withOpacity(0.6), size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Gender',
            style: TextStyle(
              color: AppColors.main600,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                icon: Icons.female,
                label: 'Girl',
                isSelected: _gender == 'girl',
                color: const Color(0xFFFFB6D9),
                onTap: () => setState(() => _gender = 'girl'),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: _buildGenderOption(
                icon: Icons.male,
                label: 'Boy',
                isSelected: _gender == 'boy',
                color: const Color(0xFF87CEEB),
                onTap: () => setState(() => _gender = 'boy'),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.15)
              : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.main300.withOpacity(0.5),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: AppColors.white,
                    offset: Offset(-2.5, -2.5),
                    blurRadius: 5,
                    spreadRadius: -5,
                    inset: true,
                  ),
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.15),
                    offset: const Offset(2.5, 2.5),
                    blurRadius: 5,
                    inset: true,
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Color.lerp(color, Colors.black, 0.3)
                  : AppColors.textPrimary.withOpacity(0.4),
              size: screenWidth * 0.1,
            ),
            SizedBox(height: screenHeight * 0.008),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.038,
                color: isSelected
                    ? Color.lerp(color, Colors.black, 0.3)
                    : AppColors.textPrimary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    double screenWidth,
    double screenHeight,
    AppLocalizations t,
  ) {
    return Column(
      children: [
        NeumorphicButton(
          text: 'Continue',
          onPressed: _submit,
          color: AppColors.alerts,
          prefixIcon: Icons.check_circle_outline,
          minHeight: screenHeight * 0.065,
        ),
        SizedBox(height: screenHeight * 0.015),
        SizedBox(
          height: screenHeight * 0.065,
          child: NeumorphicButton(
            text: t.cancel,
            onPressed: () => Navigator.of(context).pop(),
            color: AppColors.error2,
            prefixIcon: Icons.close,
          ),
        ),
      ],
    );
  }
}
