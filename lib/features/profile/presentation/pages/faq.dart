import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/profile/presentation/pages/contactus.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color baseColor;
  final List<BoxShadow> shadows;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.all(16.0),
    this.baseColor = AppColors.background,
    this.shadows = AppColors.shadow1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: child,
    );
  }
}

// --- Custom FAQ Tile Widget ---
class FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool initiallyExpanded;

  const FaqTile({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: NeumorphicContainer(
        borderRadius: 25.0,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.main600,
                  ),
                ],
              ),
            ),
            // The expansion content card
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 15.0,
                ),
                child: NeumorphicContainer(
                  borderRadius: 15.0,
                  baseColor: AppColors.bg_1,
                  shadows: [
                    BoxShadow(
                      color: Color(0x66AEAEC0),
                      blurRadius: 3,
                      offset: Offset(2, 2),
                      spreadRadius: 0,
                    ),
                  ],
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.answer,
                    style: TextStyle(
                      color: AppColors.main700.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Main FAQ Screen Implementation ---
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
          'FAQ',
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
          horizontal: screenWidth * 0.05, // Responsive padding
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FAQ Tiles
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Choose your preferred language",
                style: TextStyle(color: AppColors.textDark),
              ),
            ),

            const FaqTile(
              question: 'How do I set appointment reminders?',
              answer:
                  'You can set appointment reminders by navigating to the "Appointments" section, selecting your scheduled visit, and tapping the "Set Reminder" option. You will be able to choose a time interval (e.g., 1 day or 1 hour before).',
            ),
            const SizedBox(height: 15),
            const FaqTile(
              question: 'Is my health data secure?',
              answer:
                  'Yes. We use industry-leading encryption and follow HIPAA/GDPR compliance guidelines to ensure your personal health information remains private and secure. Data is stored anonymously on secure servers.',
            ),
            const SizedBox(height: 15),
            const FaqTile(
              question: 'How do I change my due date?',
              answer:
                  'If you are tracking a pregnancy, you can change your estimated due date (EDD) in the "Profile" or "Tracking" settings. Tap on the current due date field to manually enter a new date based on your latest ultrasound or doctor\'s recommendation.',
            ),
            const SizedBox(height: 15),
            const FaqTile(
              question: 'Can I export my health records?',
              answer:
                  'Yes! Go to Settings > Data & Privacy > Download My Data to export all your information in a readable format.',
              initiallyExpanded: true,
            ),
            const SizedBox(height: 15),
            const FaqTile(
              question: 'How do I contact support?',
              answer:
                  'You can contact support via the "Contact Support" button at the bottom of this screen, or you can email us directly at support@appname.com. We typically respond within 24 hours.',
            ),
            const SizedBox(height: 15),
            const FaqTile(
              question: 'What languages are supported?',
              answer:
                  'Currently, the app supports English, Spanish, French, and German. You can change your preferred language in the "App Settings" menu.',
            ),
            const SizedBox(height: 40),

            // --- Contact Support Section ---
            Center(
              child: Text(
                'Still have questions?',
                style: TextStyle(
                  color: AppColors.main400,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Contact Support Button
            NeumorphicButton(
              text: "Contact Support",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              },
              prefixIcon: const Icon(Icons.call, color: AppColors.white, size: 24),
              color: AppColors.main500,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
