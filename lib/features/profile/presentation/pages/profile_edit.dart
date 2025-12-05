import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';

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
  final String initialValue;
  final TextInputType keyboardType;

  const NeumorphicTextField({
    super.key,
    required this.label,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
        ], // Use sunken shadows for the input field itself
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The label/title text (e.g., "Full Name")
          Text(
            label,
            style: TextStyle(
              color: AppColors.main400,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none, // Hide default border
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
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Edit Profile',
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
          vertical: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Profile Picture Section
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

                          // image: const DecorationImage(
                          //   image: AssetImage('assets/images/profile.png'),
                          //   fit: BoxFit.cover,
                          // ),
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
                            // Handle image picking logic
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Change Profile Photo',
                    style: TextStyle(color: AppColors.main500, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Input Fields
            NeumorphicTextField(
              label: 'Full Name',
              initialValue: 'Puerto Rico',
            ),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: 'Email',
              initialValue: 'puerto@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: 'Phone Number',
              initialValue: '+1 234 567 8900',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: 'Location',
              initialValue: 'San Juan, Puerto Rico',
            ),
            const SizedBox(height: 40),

            // 3. Save Changes Button
            NeumorphicButton(
              screenWidth: MediaQuery.of(context).size.width,
              screenHeight: MediaQuery.of(context).size.height,
              text: "Save Changes",
              onPressed: () {},
              icon: const Icon(Icons.save, color: AppColors.white, size: 24),
              color: AppColors.main500,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
