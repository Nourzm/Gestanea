import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/services/onboarding_service.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Phase 1: Common Info Onboarding Page
/// Collects: date_of_birth, height_cm, baseline_weight, country, user_status
class OnboardingCommonInfoPage extends StatefulWidget {
  const OnboardingCommonInfoPage({super.key});

  @override
  State<OnboardingCommonInfoPage> createState() =>
      _OnboardingCommonInfoPageState();
}

class _OnboardingCommonInfoPageState extends State<OnboardingCommonInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _phoneController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _selectedCountry;
  String? _userStatus; // 'pregnant', 'postpartum', 'baby', 'none'

  bool _autoValidate = false;
  String? _dateError;
  String? _heightError;
  String? _weightError;
  String? _countryError;
  String? _phoneError;
  String? _statusError;
  bool _isLoading = false;

  final List<String> _countries = [
    'Algeria',
    'United States',
    'United Kingdom',
    'France',
    'Canada',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_validateHeight);
    _weightController.addListener(_validateWeight);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateHeight() {
    if (_autoValidate) {
      setState(() {
        _heightError = _validateHeightValue(_heightController.text);
      });
    }
  }

  void _validateWeight() {
    if (_autoValidate) {
      setState(() {
        _weightError = _validateWeightValue(_weightController.text);
      });
    }
  }

  String? _validateHeightValue(String value) {
    if (value.trim().isEmpty) return 'Height is required';
    final height = double.tryParse(value.trim());
    if (height == null) return 'Please enter a valid number';
    if (height < 50 || height > 250) {
      return 'Please enter a height between 50-250 cm';
    }
    return null;
  }

  String? _validateWeightValue(String value) {
    if (value.trim().isEmpty) return 'Weight is required';
    final weight = double.tryParse(value.trim());
    if (weight == null) return 'Please enter a valid number';
    if (weight < 20 || weight > 300) {
      return 'Please enter a weight between 20-300 kg';
    }
    return null;
  }

  String? _validatePhone(String value) {
    // Phone is optional, but if provided, should be valid format
    if (value.trim().isEmpty) return null;
    // Basic phone validation (allows digits, spaces, dashes, plus sign)
    final phoneRegex = RegExp(r'^[\d\s\-\+\(\)]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    if (value.trim().length < 8) {
      return 'Phone number is too short';
    }
    return null;
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
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
      _dateError = _dateOfBirth == null ? 'Date of birth is required' : null;
      _heightError = _validateHeightValue(_heightController.text);
      _weightError = _validateWeightValue(_weightController.text);
      _countryError = _selectedCountry == null ? 'Country is required' : null;
      _phoneError = _validatePhone(_phoneController.text);
      _statusError = _userStatus == null ? 'Please select your status' : null;
    });

    if (_dateError != null ||
        _heightError != null ||
        _weightError != null ||
        _countryError != null ||
        _phoneError != null ||
        _statusError != null) {
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
      await onboardingService.saveCommonInfo(
        userId: user.id,
        dateOfBirth: _dateOfBirth!,
        heightCm: double.parse(_heightController.text.trim()),
        baselineWeight: double.parse(_weightController.text.trim()),
        country: _selectedCountry!,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
      );

      // Save user status
      await onboardingService.saveUserStatus(
        userId: user.id,
        userStatus: _userStatus!,
      );

      if (!mounted) return;

      // Navigate based on user status
      if (_userStatus == 'pregnant') {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingPregnancy);
      } else if (_userStatus == 'postpartum' || _userStatus == 'baby') {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingBaby);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingHealth);
      }
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HeroSection(
                  title: "Tell us about you",
                  subtitle: "Help us personalize your experience",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    ? DateFormat(
                                        'MMMM dd, yyyy',
                                      ).format(_dateOfBirth!)
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

                      // Height
                      const Text(
                        'Height (cm) *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InputField(
                        controller: _heightController,
                        hintText: 'Enter your height',
                        prefixIcon: Icons.height,
                        keyboardType: TextInputType.number,
                        errorText: _heightError,
                      ),
                      const SizedBox(height: 16),

                      // Baseline Weight
                      const Text(
                        'Baseline Weight (kg) *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InputField(
                        controller: _weightController,
                        hintText: 'Enter your weight',
                        prefixIcon: Icons.monitor_weight_outlined,
                        keyboardType: TextInputType.number,
                        errorText: _weightError,
                      ),
                      const SizedBox(height: 16),

                      // Country
                      const Text(
                        'Country *',
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
                            color: _countryError != null
                                ? Colors.red
                                : Colors.transparent,
                            width: 1,
                          ),
                          boxShadow: AppColors.shadow1,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Select country'),
                            value: _selectedCountry,
                            items: _countries.map((c) {
                              return DropdownMenuItem(value: c, child: Text(c));
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedCountry = val;
                                _countryError = null;
                              });
                            },
                          ),
                        ),
                      ),
                      if (_countryError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            _countryError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Phone
                      const Text(
                        'Phone (optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InputField(
                        controller: _phoneController,
                        hintText: 'Enter your phone number',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        errorText: _phoneError,
                      ),
                      const SizedBox(height: 16),

                      // User Status
                      const Text(
                        'What describes you best? *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCard(
                        'pregnant',
                        "I'm Pregnant",
                        'Track your pregnancy journey',
                        const LinearGradient(
                          colors: [Color(0xffF5D4FB), Color(0xffFBECFF)],
                        ),
                        'assets/icons/babyy.svg',
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCard(
                        'postpartum',
                        "I have a baby",
                        'Postpartum care and baby tracking',
                        const LinearGradient(
                          colors: [Color(0xffFBECFF), Color(0xffFDF5FF)],
                        ),
                        'assets/icons/health.svg',
                      ),
                      if (_statusError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            _statusError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
      ),
    );
  }

  Widget _buildStatusCard(
    String status,
    String title,
    String subtitle,
    Gradient gradient,
    String icon,
  ) {
    final isSelected = _userStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _userStatus = status;
          _statusError = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.main600 : Colors.transparent,
            width: 2,
          ),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppColors.onboarding,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: icon.endsWith('.svg')
                    ? SvgPicture.asset(
                        icon,
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.main600 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
