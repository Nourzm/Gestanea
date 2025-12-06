// Updated EditProfileScreen to use AuthBloc for user data and to dispatch UpdateProfileRequested.
// Replaces existing lib/features/profile/presentation/pages/profile_edit.dart
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
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
        child: child,
      ),
    );
  }
}

// --- Custom Neumorphic Text Field Widget (Depressed/Sunken) ---
class NeumorphicTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const NeumorphicTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

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
            label,
            style: const TextStyle(
              color: AppColors.main400,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Edit Profile Screen Implementation ---
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameC;
  late TextEditingController _emailC;
  late TextEditingController _phoneC;
  late TextEditingController _countryC;
  late TextEditingController _languageC;
  late TextEditingController _themeC;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController();
    _emailC = TextEditingController();
    _phoneC = TextEditingController();
    _countryC = TextEditingController();
    _languageC = TextEditingController();
    _themeC = TextEditingController();

    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      final user = state.user;
      _userId = user.id;
      _nameC.text = user.name;
      _emailC.text = user.email;
      _phoneC.text = user.phone ?? '';
      _countryC.text = user.country ?? '';
      _languageC.text = user.language ?? '';
      _themeC.text = user.theme ?? '';
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _countryC.dispose();
    _languageC.dispose();
    _themeC.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    if (_userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not authenticated')));
      return;
    }

    context.read<AuthBloc>().add(
      UpdateProfileRequested(
        id: _userId!,
        name: _nameC.text.trim(),
        email: _emailC.text.trim(),
        phone: _phoneC.text.trim().isEmpty ? null : _phoneC.text.trim(),
        country: _countryC.text.trim().isEmpty ? null : _countryC.text.trim(),
        language: _languageC.text.trim().isEmpty
            ? null
            : _languageC.text.trim(),
        theme: _themeC.text.trim().isEmpty ? null : _themeC.text.trim(),
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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.edit_profile,
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
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(t.profile_updated)));
            Navigator.pop(context); // go back after successful save
          } else if (state is AuthFailure) {
            final msg = state.message.replaceAll('Exception: ', '');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          } else if (state is AuthUnauthenticated) {
            // logged out, go to login
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile picture section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: screenWidth * 0.30,
                            height: screenWidth * 0.30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.main500,
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: const AssetImage(
                                'assets/images/pfp.png',
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: NeumorphicContainer(
                              borderRadius: 20.0,
                              padding: const EdgeInsets.all(10),
                              baseColor: AppColors.background,
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.main500,
                                size: 20,
                              ),
                              onTap: () {
                                // pick image
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.change_profile_photo,
                        style: TextStyle(
                          color: AppColors.main500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Inputs
                NeumorphicTextField(label: t.full_name, controller: _nameC),
                const SizedBox(height: 15),
                NeumorphicTextField(
                  label: t.email,
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                NeumorphicTextField(
                  label: t.phone,
                  controller: _phoneC,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
                NeumorphicTextField(label: t.country, controller: _countryC),
                const SizedBox(height: 15),
                NeumorphicTextField(label: t.language, controller: _languageC),
                const SizedBox(height: 15),
                
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return Column(
                      children: [
                        isLoading
                            ? const SizedBox(
                                height: 48,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : NeumorphicButton(
                                screenWidth: screenWidth,
                                screenHeight: MediaQuery.of(
                                  context,
                                ).size.height,
                                text: t.save_changes,
                                onPressed: _onSave,
                                icon: const Icon(
                                  Icons.save,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                color: AppColors.main500,
                              ),
                        const SizedBox(height: 16),
                        NeumorphicButton(
                          screenWidth: screenWidth,
                          screenHeight: MediaQuery.of(context).size.height,
                          text: t.cancel,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.white,
                            size: 20,
                          ),
                          color: AppColors.main400,
                        ),
                      ],
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
