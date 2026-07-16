import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/services/onboarding_service.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Phase 2a: Pregnancy Onboarding Page
/// Collects: lmp_date, due_date (auto-calculated), is_first_pregnancy, is_high_risk, medical_conditions
class OnboardingPregnancyPage extends StatefulWidget {
  const OnboardingPregnancyPage({super.key});

  @override
  State<OnboardingPregnancyPage> createState() =>
      _OnboardingPregnancyPageState();
}

class _OnboardingPregnancyPageState extends State<OnboardingPregnancyPage> {
  final _medicalConditionsController = TextEditingController();

  DateTime? _lmpDate;
  DateTime? _dueDate;
  bool? _isFirstPregnancy;
  bool? _isHighRisk;

  bool _autoValidate = false;
  String? _lmpError;
  String? _dueDateError;
  String? _firstPregnancyError;
  String? _highRiskError;
  bool _isLoading = false;

  @override
  void dispose() {
    _medicalConditionsController.dispose();
    super.dispose();
  }

  Future<void> _selectLmpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lmpDate ?? DateTime.now().subtract(const Duration(days: 90)),
      firstDate: DateTime.now().subtract(const Duration(days: 280)),
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
        _lmpDate = picked;
        // Auto-calculate due date (LMP + 280 days)
        _dueDate = picked.add(const Duration(days: 280));
        _lmpError = null;
      });
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 190)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 280)),
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
        _dueDate = picked;
        _dueDateError = null;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() {
      _autoValidate = true;
      _lmpError = _lmpDate == null ? 'LMP date is required' : null;
      _dueDateError = _dueDate == null ? 'Due date is required' : null;
      _firstPregnancyError = _isFirstPregnancy == null
          ? 'Please select if this is your first pregnancy'
          : null;
      _highRiskError = _isHighRisk == null
          ? 'Please select if this is a high-risk pregnancy'
          : null;
    });

    if (_lmpError != null ||
        _dueDateError != null ||
        _firstPregnancyError != null ||
        _highRiskError != null) {
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
      await onboardingService.savePregnancyInfo(
        userId: user.id,
        lmpDate: _lmpDate!,
        dueDate: _dueDate,
        isFirstPregnancy: _isFirstPregnancy!,
        isHighRisk: _isHighRisk!,
        medicalConditions: _medicalConditionsController.text.trim().isEmpty
            ? null
            : _medicalConditionsController.text.trim(),
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
                title: "Pregnancy Details",
                subtitle: "Tell us about your pregnancy",
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LMP Date
                    const Text(
                      'Last Menstrual Period (LMP) Date *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectLmpDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _lmpError != null
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
                            Expanded(
                              child: Text(
                                _lmpDate != null
                                    ? DateFormat(
                                        'MMMM dd, yyyy',
                                      ).format(_lmpDate!)
                                    : 'Select LMP date',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _lmpDate != null
                                          ? Colors.black87
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_lmpError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _lmpError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (_lmpDate != null && _dueDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Due date: ${DateFormat('MMMM dd, yyyy').format(_dueDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.main600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Due Date (optional to override)
                    const Text(
                      'Due Date (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDueDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          boxShadow: AppColors.shadow1,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: AppColors.main600,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _dueDate != null
                                    ? DateFormat(
                                        'MMMM dd, yyyy',
                                      ).format(_dueDate!)
                                    : 'Select due date (auto-calculated from LMP)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _dueDate != null
                                          ? Colors.black87
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // First Pregnancy
                    const Text(
                      'Is this your first pregnancy? *',
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
                          child: _buildYesNoCard(
                            'Yes',
                            true,
                            _isFirstPregnancy == true,
                            (value) {
                              setState(() {
                                _isFirstPregnancy = value;
                                _firstPregnancyError = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildYesNoCard(
                            'No',
                            false,
                            _isFirstPregnancy == false,
                            (value) {
                              setState(() {
                                _isFirstPregnancy = value;
                                _firstPregnancyError = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_firstPregnancyError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _firstPregnancyError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // High Risk
                    const Text(
                      'Is this a high-risk pregnancy? *',
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
                          child: _buildYesNoCard(
                            'Yes',
                            true,
                            _isHighRisk == true,
                            (value) {
                              setState(() {
                                _isHighRisk = value;
                                _highRiskError = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildYesNoCard(
                            'No',
                            false,
                            _isHighRisk == false,
                            (value) {
                              setState(() {
                                _isHighRisk = value;
                                _highRiskError = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_highRiskError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _highRiskError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Medical Conditions
                    const Text(
                      'Medical Conditions (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _medicalConditionsController,
                      hintText: 'Enter any medical conditions',
                      prefixIcon: Icons.medical_services_outlined,
                      errorText: null,
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

  Widget _buildYesNoCard(
    String label,
    bool value,
    bool isSelected,
    Function(bool) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main300 : AppColors.white,
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
              color: isSelected ? AppColors.main600 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
