import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/presentation/widgets/preg_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class Personalize1 extends StatefulWidget {
  const Personalize1({super.key});

  @override
  State<Personalize1> createState() => _Personalize1State();
}

class _Personalize1State extends State<Personalize1> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCountry;
  String? _selectedLanguage;

  String? _nameError;
  String? _phoneError;
  String? _countryError;
  String? _languageError;

  final List<String> _countries = [
    'Algeria',
    'United States',
    'United Kingdom',
    'France',
    'Canada',
    'Other',
  ];

  final List<String> _languages = ['English', 'French', 'Arabic', 'Other'];

  @override
  void initState() {
    super.initState();

    // Clear errors when user starts typing
    _nameController.addListener(() {
      if (_nameError != null) {
        setState(() => _nameError = null);
      }
    });

    _phoneController.addListener(() {
      if (_phoneError != null) {
        setState(() => _phoneError = null);
      }
    });
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String value) {
    if (value.isEmpty) {
      return null; // Phone is optional
    }
    // Basic phone validation - at least 10 digits
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() {
      _nameError = _validateName(name);
      _phoneError = _validatePhone(phone);
      _countryError = _selectedCountry == null ? 'Country is required' : null;
      _languageError = _selectedLanguage == null
          ? 'Language is required'
          : null;
    });

    // Prevent submission if any validation fails
    if (_nameError != null ||
        _phoneError != null ||
        _countryError != null ||
        _languageError != null) {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => _nameError = 'No authenticated user');
      return;
    }

    // Trigger profile save via bloc
    context.read<AuthBloc>().add(
      UpdateProfileRequested(
        id: user.id,
        name: name,
        email: user.email ?? '',
        phone: phone.isNotEmpty ? phone : null,
        country: _selectedCountry,
        language: _selectedLanguage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Profile saved, show pregnancy selection
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const _PregnancySelectionPage(),
              ),
            );
          } else if (state is AuthFailure) {
            // Show error as field error instead of snackbar
            setState(() {
              _nameError = state.message.replaceAll('Exception: ', '');
            });
          }
        },
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
                    const Text(
                      'Full Name *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                      prefixIcon: Icons.person_outline,
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _phoneController,
                      hintText: 'Enter your phone',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      errorText: _phoneError,
                    ),
                    const SizedBox(height: 16),
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
                        borderRadius: BorderRadius.circular(16),
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
                              if (val != null) _countryError = null;
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
                    const Text(
                      'Language *',
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
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _languageError != null
                              ? Colors.red
                              : Colors.transparent,
                          width: 1,
                        ),
                        boxShadow: AppColors.shadow1,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select language'),
                          value: _selectedLanguage,
                          items: _languages.map((l) {
                            return DropdownMenuItem(value: l, child: Text(l));
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedLanguage = val;
                              if (val != null) _languageError = null;
                            });
                          },
                        ),
                      ),
                    ),
                    if (_languageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _languageError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: NeumorphicButton(
                            text: 'Continue',
                            onPressed: isLoading ? null : _saveProfile,
                            isLoading: isLoading,
                          ),
                        );
                      },
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

class _PregnancySelectionPage extends StatelessWidget {
  const _PregnancySelectionPage();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(
              title: "What describes you best?",
              subtitle: "We'll customize your experience",
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.02,
              ),
              child: const PregnancySelectionScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
