// Updated EditProfileScreen to use AuthBloc for user data and to dispatch UpdateProfileRequested.
// Replaces existing lib/features/profile/presentation/pages/profile_edit.dart
import 'dart:io';
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/core/widgets/profile_avatar.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController _themeC;
  String? _userId;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController();
    _emailC = TextEditingController();
    _phoneC = TextEditingController();
    _countryC = TextEditingController();
    _themeC = TextEditingController();

    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      final user = state.user;
      _userId = user.id;
      _nameC.text = user.name;
      _emailC.text = user.email;
      _phoneC.text = user.phone ?? '';
      _countryC.text = user.country ?? '';
      _themeC.text = user.theme ?? '';
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _countryC.dispose();
    _themeC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final t = AppLocalizations.of(context)!;
    
    // Show dialog to choose image source
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.change_profile_photo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85, // Compress for better performance
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error1,
          ),
        );
      }
    }
  }

  Future<void> _uploadProfilePicture(String userId) async {
    if (_selectedImage == null || !await _selectedImage!.exists()) {
      return;
    }

    try {
      context.read<AuthBloc>().add(
            UpdateProfilePictureRequested(
              userId: userId,
              imageFilePath: _selectedImage!.path,
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload profile picture: $e'),
            backgroundColor: AppColors.error1,
          ),
        );
      }
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not authenticated')));
      return;
    }

    // Upload profile picture first if selected
    if (_selectedImage != null) {
      await _uploadProfilePicture(_userId!);
      // Wait a bit for the upload to complete and state to update
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Get current state to preserve profile picture URL if not uploading new one
    final authState = context.read<AuthBloc>().state;
    String? profilePictureUrl;
    if (authState is AuthAuthenticated) {
      profilePictureUrl = authState.user.profilePictureUrl;
    }

    context.read<AuthBloc>().add(
      UpdateProfileRequested(
        id: _userId!,
        name: _nameC.text.trim(),
        email: _emailC.text.trim(),
        phone: _phoneC.text.trim().isEmpty ? null : _phoneC.text.trim(),
        country: _countryC.text.trim().isEmpty ? null : _countryC.text.trim(),
        theme: _themeC.text.trim().isEmpty ? null : _themeC.text.trim(),
        profilePictureUrl: profilePictureUrl, // Preserve existing or newly uploaded URL
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
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (_selectedImage != null) {
                                // Show selected image
                                return Container(
                                  width: screenWidth * 0.30,
                                  height: screenWidth * 0.30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.main500,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }

                              // Show existing profile picture or placeholder
                              if (state is AuthAuthenticated) {
                                return Container(
                                  width: screenWidth * 0.30,
                                  height: screenWidth * 0.30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.main500,
                                      width: 3,
                                    ),
                                  ),
                                  child: ProfileAvatar(
                                    imageUrl: state.user.profilePictureUrl,
                                    userId: state.user.id,
                                    radius: screenWidth * 0.15,
                                  ),
                                );
                              }

                              return Container(
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
                              );
                            },
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
                              onTap: _pickImage,
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
                                text: t.save_changes,
                                onPressed: _onSave,
                                prefixIcon: Icons.save,
                                color: AppColors.main500,
                              ),
                        const SizedBox(height: 16),
                        NeumorphicButton(
                          text: t.cancel,
                          onPressed: () => Navigator.pop(context),
                          prefixIcon: Icons.close,
                          color: AppColors.error2,
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
