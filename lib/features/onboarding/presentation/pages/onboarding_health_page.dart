import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/services/onboarding_service.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Phase 3: Optional Health Onboarding Page
/// Collects: blood_type, chronic_conditions, allergies, emergency_contact_name, emergency_contact_phone
class OnboardingHealthPage extends StatefulWidget {
  const OnboardingHealthPage({super.key});

  @override
  State<OnboardingHealthPage> createState() => _OnboardingHealthPageState();
}

class _OnboardingHealthPageState extends State<OnboardingHealthPage> {
  final _chronicConditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();

  String? _bloodType;

  bool _isLoading = false;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void dispose() {
    _chronicConditionsController.dispose();
    _allergiesController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
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

      // Save health profile (all fields optional)
      await onboardingService.saveHealthProfile(
        userId: user.id,
        bloodType: _bloodType,
        chronicConditions: _chronicConditionsController.text.trim().isEmpty
            ? null
            : _chronicConditionsController.text.trim(),
        allergies: _allergiesController.text.trim().isEmpty
            ? null
            : _allergiesController.text.trim(),
        emergencyContactName:
            _emergencyContactNameController.text.trim().isEmpty
                ? null
                : _emergencyContactNameController.text.trim(),
        emergencyContactPhone:
            _emergencyContactPhoneController.text.trim().isEmpty
                ? null
                : _emergencyContactPhoneController.text.trim(),
      );

      // Complete onboarding
      await onboardingService.completeOnboarding(user.id);

      if (!mounted) return;

      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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

  Future<void> _skipAndComplete() async {
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
      await onboardingService.completeOnboarding(user.id);

      if (!mounted) return;

      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
                title: "Health Information",
                subtitle: "Optional: Help us keep you safe",
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blood Type
                    const Text(
                      'Blood Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        boxShadow: AppColors.shadow1,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select blood type'),
                          value: _bloodType,
                          items: _bloodTypes.map((bt) {
                            return DropdownMenuItem(
                              value: bt,
                              child: Text(bt),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _bloodType = val;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chronic Conditions
                    const Text(
                      'Chronic Conditions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _chronicConditionsController,
                      hintText: 'List any chronic conditions',
                      prefixIcon: Icons.medical_services_outlined,
                      errorText: null,
                    ),
                    const SizedBox(height: 16),

                    // Allergies
                    const Text(
                      'Allergies',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _allergiesController,
                      hintText: 'List any allergies',
                      prefixIcon: Icons.warning_amber_outlined,
                      errorText: null,
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contact Name
                    const Text(
                      'Emergency Contact Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _emergencyContactNameController,
                      hintText: 'Enter contact name',
                      prefixIcon: Icons.person_outline,
                      errorText: null,
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contact Phone
                    const Text(
                      'Emergency Contact Phone',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _emergencyContactPhoneController,
                      hintText: 'Enter contact phone',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      errorText: null,
                    ),
                    const SizedBox(height: 32),

                    // Continue Button
                    NeumorphicButton(
                      text: 'Complete',
                      onPressed: _isLoading ? null : _completeOnboarding,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 12),

                    // Skip Button
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _skipAndComplete,
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
}
