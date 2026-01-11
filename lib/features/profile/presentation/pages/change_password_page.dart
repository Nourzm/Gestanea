import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/l10n/app_localizations.dart';

// --- Custom Neumorphic Password Text Field Widget ---
class NeumorphicPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const NeumorphicPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  State<NeumorphicPasswordField> createState() =>
      _NeumorphicPasswordFieldState();
}

class _NeumorphicPasswordFieldState extends State<NeumorphicPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(25.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.main400,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            textAlignVertical: TextAlignVertical.center,
            obscureText: _obscureText,
            validator: widget.validator,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              errorText: null,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.main400,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Change Password Screen Implementation ---
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(() {
      if (_autoValidate) setState(() {});
    });
    _newPasswordController.addListener(() {
      if (_autoValidate) setState(() {});
    });
    _confirmPasswordController.addListener(() {
      if (_autoValidate) setState(() {});
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Current password is required';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value == _currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onChangePassword() {
    setState(() {
      _autoValidate = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          ChangePasswordRequested(
            currentPassword: _currentPasswordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
          ),
        );
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.main500,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Change Password',
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordChangedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password changed successfully!'),
                backgroundColor: AppColors.alerts,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            final msg = state.message.replaceAll('Exception: ', '');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: AppColors.error1,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20.0,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.main300,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.shadow1
                        .map(
                          (s) => BoxShadow(
                            color: s.color,
                            offset: s.offset,
                            blurRadius: s.blurRadius,
                            spreadRadius: s.spreadRadius,
                          ),
                        )
                        .toList(),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.main500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password Requirements',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'At least 6 characters long',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Current Password
                NeumorphicPasswordField(
                  label: 'Current Password',
                  controller: _currentPasswordController,
                  validator: _validateCurrentPassword,
                ),
                if (_autoValidate &&
                    _validateCurrentPassword(_currentPasswordController.text) !=
                        null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                    child: Text(
                      _validateCurrentPassword(
                              _currentPasswordController.text) ??
                          '',
                      style: const TextStyle(
                        color: AppColors.error1,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 15),

                // New Password
                NeumorphicPasswordField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  validator: _validateNewPassword,
                ),
                if (_autoValidate &&
                    _validateNewPassword(_newPasswordController.text) != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                    child: Text(
                      _validateNewPassword(_newPasswordController.text) ?? '',
                      style: const TextStyle(
                        color: AppColors.error1,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 15),

                // Confirm Password
                NeumorphicPasswordField(
                  label: 'Confirm New Password',
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                ),
                if (_autoValidate &&
                    _validateConfirmPassword(
                            _confirmPasswordController.text) !=
                        null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                    child: Text(
                      _validateConfirmPassword(_confirmPasswordController.text) ??
                          '',
                      style: const TextStyle(
                        color: AppColors.error1,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),

                // Save Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return isLoading
                        ? const SizedBox(
                            height: 48,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : NeumorphicButton(
                            text: 'Change Password',
                            onPressed: _onChangePassword,
                            prefixIcon: Icons.lock,
                            color: AppColors.main500,
                          );
                  },
                ),
                const SizedBox(height: 16),

                // Cancel Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return NeumorphicButton(
                      text: 'Cancel',
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      prefixIcon: Icons.close,
                      color: AppColors.error2,
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
