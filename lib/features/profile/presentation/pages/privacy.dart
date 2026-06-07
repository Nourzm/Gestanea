import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color baseColor;
  final List<BoxShadow> shadows;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.all(16.0),
    this.baseColor = AppColors.main300,
    this.shadows = AppColors.shadow1,
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
          boxShadow: shadows,
        ),
        child: child,
      ),
    );
  }
}

// --- Custom Privacy Policy Section Card ---
class PrivacySectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const PrivacySectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.main500, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            content,
            style: TextStyle(
              color: AppColors.main700.withValues(alpha: 0.8),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Privacy Policy Screen Implementation ---
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
          children: [
            SizedBox(height: 10,),
            // 1. Your Privacy Matters (Header Card)
            NeumorphicContainer(
              borderRadius: 30.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: AppColors.main500,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We are committed to protecting your personal information and ensuring transparency about how we use your data.',
                    style: TextStyle(
                      color: AppColors.main700.withValues(alpha: 0.7),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Last Updated: December 4, 2025',
                    style: TextStyle(
                      color: AppColors.main400,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Data Collection
            PrivacySectionCard(
              icon: Icons.storage_outlined,
              title: 'Data Collection',
              content:
                  'We collect only essential information needed to provide you with the best health tracking experience. This includes your profile information, health metrics, and app usage data.',
            ),
            const SizedBox(height: 15),

            // 3. Data Security
            PrivacySectionCard(
              icon: Icons.lock_outline,
              title: 'Data Security',
              content:
                  'Your data is encrypted using industry-standard protocols. We employ multiple layers of security to protect your personal health information from unauthorized access.',
            ),
            const SizedBox(height: 15),

            // 4. Data Usage
            PrivacySectionCard(
              icon: Icons.bar_chart_outlined,
              title: 'Data Usage',
              content:
                  'We use your data to personalize your app experience, provide relevant health insights, and improve. We do not sell personal data to third parties.',
            ),
            const SizedBox(height: 15),

            // 5. Your Rights
            PrivacySectionCard(
              icon: Icons.assignment_turned_in_outlined,
              title: 'Your Rights',
              content:
                  'You have the right to access, or update, or request deletion of your data. You can manage privacy settings within the app or contact support.',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
