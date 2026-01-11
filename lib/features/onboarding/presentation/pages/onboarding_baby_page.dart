import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/services/onboarding_service.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Phase 2b: Baby/Postpartum Onboarding Page
/// Collects: baby name, gender, date_of_birth, birth_weight, birth_height
class OnboardingBabyPage extends StatefulWidget {
  const OnboardingBabyPage({super.key});

  @override
  State<OnboardingBabyPage> createState() => _OnboardingBabyPageState();
}

class _OnboardingBabyPageState extends State<OnboardingBabyPage> {
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _birthHeightController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _gender; // 'boy' or 'girl'

  bool _autoValidate = false;
  String? _nameError;
  String? _dateError;
  String? _genderError;
  String? _weightError;
  String? _heightError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthWeightController.dispose();
    _birthHeightController.dispose();
    super.dispose();
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) return 'Baby name is required';
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateWeight(String value) {
    if (value.trim().isEmpty) return null; // Optional
    final weight = double.tryParse(value.trim());
    if (weight == null) return 'Please enter a valid number';
    if (weight < 0.5 || weight > 10) {
      return 'Please enter a weight between 0.5-10 kg';
    }
    return null;
  }

  String? _validateHeight(String value) {
    if (value.trim().isEmpty) return null; // Optional
    final height = double.tryParse(value.trim());
    if (height == null) return 'Please enter a valid number';
    if (height < 20 || height > 100) {
      return 'Please enter a height between 20-100 cm';
    }
    return null;
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
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
        _dateError = null;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() {
      _autoValidate = true;
      _nameError = _validateName(_nameController.text);
      _dateError = _dateOfBirth == null ? 'Date of birth is required' : null;
      _genderError = _gender == null ? 'Please select gender' : null;
      _weightError = _validateWeight(_birthWeightController.text);
      _heightError = _validateHeight(_birthHeightController.text);
    });

    if (_nameError != null ||
        _dateError != null ||
        _genderError != null ||
        _weightError != null ||
        _heightError != null) {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authenticated user'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final onboardingService = OnboardingService();
      await onboardingService.saveBabyInfo(
        userId: user.id,
        babyName: _nameController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        gender: _gender!,
        birthWeight: _birthWeightController.text.trim().isEmpty
            ? null
            : double.tryParse(_birthWeightController.text.trim()),
        birthHeight: _birthHeightController.text.trim().isEmpty
            ? null
            : double.tryParse(_birthHeightController.text.trim()),
      );

      if (!mounted) return;

      // Navigate to optional health page
      Navigator.pushReplacementNamed(context, '/onboarding/health');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeroSection(
                title: "Baby Information",
                subtitle: "Tell us about your baby",
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baby Name
                    const Text(
                      'Baby Name *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _nameController,
                      hintText: 'Enter baby\'s name',
                      prefixIcon: Icons.person_outline,
                      errorText: _autoValidate ? _nameError : null,
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth
                    const Text(
                      'Date of Birth *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDateOfBirth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _dateError != null
                                ? Colors.red
                                : Colors.transparent,
                            width: 1,
                          ),
                          boxShadow: AppColors.shadow1,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.main600,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _dateOfBirth != null
                                  ? DateFormat('MMMM dd, yyyy').format(_dateOfBirth!)
                                  : 'Select date of birth',
                              style: TextStyle(
                                fontSize: 16,
                                color: _dateOfBirth != null
                                    ? Colors.black87
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_dateError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _dateError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Gender
                    const Text(
                      'Gender *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderCard(
                            'Girl',
                            'girl',
                            const LinearGradient(
                              colors: [Color(0xFFFFB6D9), Color(0xFFFFE5F1)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderCard(
                            'Boy',
                            'boy',
                            const LinearGradient(
                              colors: [Color(0xFF87CEEB), Color(0xFFE1F5FF)],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_genderError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _genderError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Birth Weight and Height
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Birth Weight (kg)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InputField(
                                controller: _birthWeightController,
                                hintText: 'kg',
                                prefixIcon: Icons.monitor_weight_outlined,
                                keyboardType: TextInputType.number,
                                errorText: _autoValidate ? _weightError : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Birth Height (cm)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InputField(
                                controller: _birthHeightController,
                                hintText: 'cm',
                                prefixIcon: Icons.height,
                                keyboardType: TextInputType.number,
                                errorText: _autoValidate ? _heightError : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Continue Button
                    NeumorphicButton(
                      text: 'Continue',
                      onPressed: _isLoading ? null : _saveAndContinue,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, String value, Gradient gradient) {
    final isSelected = _gender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value;
          _genderError = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.main600 : Colors.transparent,
            width: 2,
          ),
          boxShadow: AppColors.shadow1,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
