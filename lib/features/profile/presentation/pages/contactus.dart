import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
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

  const NeumorphicTextField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.0),
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
            style: TextStyle(
              color: AppColors.main400,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextField(
            maxLines: maxLines,
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
    );
  }
}

// --- Contact Us Screen Implementation ---
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
          'Contacts',
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
                    "Get in Touch",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Have a question or feedback? We'd love to hear from you. Fill out the form below and we'll get back to you within 24 hours.",
                    style: TextStyle(
                      color: AppColors.main700.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Contact details
                  _buildContactDetail(
                    Icons.email_outlined,
                    'support@momcare.com',
                  ),
                  _buildContactDetail(
                    Icons.phone_outlined,
                    '+1 (800) 123-4567',
                  ),
                  _buildContactDetail(Icons.schedule, 'Mon-Fri, 9AM-6PM EST'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Contact Form Fields
            NeumorphicTextField(label: 'Your Name', hint: 'Enter your name'),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: 'Email Address',
              hint: 'your.email@example.com',
            ),
            const SizedBox(height: 15),
            NeumorphicTextField(label: 'Subject', hint: 'What is this about?'),
            const SizedBox(height: 15),
            NeumorphicTextField(
              label: 'Message',
              hint: 'Tell us how we can help...',
              maxLines: 6,
            ),
            const SizedBox(height: 30),

            // 3. Submit Button
            NeumorphicButton(
              text: "Send Message",
              onPressed: () {},
              prefixIcon: const Icon(
                Icons.send,
                color: AppColors.white,
                size: 24,
              ),
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

// --- Main App Setup (for demonstration) ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Us Neumorphism Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const ContactUsScreen(),
    );
  }
}
