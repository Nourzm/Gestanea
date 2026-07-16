import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color baseColor;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.all(16.0),
    this.baseColor = AppColors.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: (AppColors.shadow1 as List).map((dynamic s) {
            return BoxShadow(
              color: s.color,
              offset: s.offset,
              blurRadius: s.blurRadius,
              spreadRadius: s.spreadRadius,
            );
          }).toList(),
        ),
        child: child,
      ),
    );
  }
}

// --- Custom Neumorphic Text Field Widget ---
class NeumorphicTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;

  const NeumorphicTextField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: errorText != null
                      ? Colors.red.withOpacity(0.8)
                      : AppColors.main400,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: controller,
                maxLines: maxLines,
                keyboardType: keyboardType,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: AppColors.main400.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none, // Removes the default underline
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              errorText!,
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
}

// --- Contact Us Screen Implementation ---
class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  final EmailJSService _emailService = EmailJSService();
  bool _isLoading = false;
  bool _autoValidate = false;

  // Error text for each field
  String? _nameError;
  String? _emailError;
  String? _subjectError;
  String? _messageError;

  @override
  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _subjectController.addListener(_onFieldChanged);
    _messageController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _subjectController.removeListener(_onFieldChanged);
    _messageController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _emailService.dispose();
    super.dispose();
  }

  /// Validate form inputs
  bool _validateForm() {
    setState(() {
      _autoValidate = true;
      _nameError = _validateName(_nameController.text);
      _emailError = _validateEmail(_emailController.text);
      _subjectError = _validateSubject(_subjectController.text);
      _messageError = _validateMessage(_messageController.text);
    });

    return _nameError == null &&
        _emailError == null &&
        _subjectError == null &&
        _messageError == null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Subject is required';
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message is required';
    }
    return null;
  }

  /// Handle real-time validation on text change
  void _onFieldChanged() {
    if (_autoValidate) {
      setState(() {
        _nameError = _validateName(_nameController.text);
        _emailError = _validateEmail(_emailController.text);
        _subjectError = _validateSubject(_subjectController.text);
        _messageError = _validateMessage(_messageController.text);
      });
    }
  }

  /// Send email via EmailJS
  Future<void> _sendEmail() async {
    // Validate form
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _emailService.sendEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Message sent successfully! We\'ll get back to you soon.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.alerts,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        setState(() {
          _autoValidate = false;
          _nameError = null;
          _emailError = null;
          _subjectError = null;
          _messageError = null;
        });
      }
    } on EmailJSException catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    e.message,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error1,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'An unexpected error occurred. Please try again later.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error1,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          t.contact_us,
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. "Get in Touch" Header Card
            NeumorphicContainer(
              borderRadius: 30.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.getInTouch,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.contactFormDescription,
                    style: TextStyle(
                      color: AppColors.main700.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Contact details
                  _buildContactDetail(Icons.email_outlined, t.supportEmail),
                  _buildContactDetail(Icons.phone_outlined, t.supportPhone),
                  _buildContactDetail(Icons.schedule, t.supportHours),
                ],
              ),
              const SizedBox(height: 20),

            // 2. Contact Form Fields
            NeumorphicTextField(label: t.yourNameLabel, hint: t.enterYourName),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: t.emailAddressLabel,
              hint: t.emailPlaceholder,
            ),
            const SizedBox(height: 15),
            NeumorphicTextField(label: t.subjectLabel, hint: t.whatIsThisAbout),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: t.messageLabel,
              hint: t.tellUsHowWeCanHelp,
              maxLines: 6,
            ),
            const SizedBox(height: 30),

            // 3. Submit Button
            NeumorphicButton(
              text: t.sendMessage,
              onPressed: () {},
              prefixIcon: Icons.send,
              color: AppColors.main500,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method for the contact details in the header card
  Widget _buildContactDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.main400, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
