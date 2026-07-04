import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/profile/presentation/pages/contactus.dart';
import 'package:gestanea/l10n/app_localizations.dart';

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
    final t = AppLocalizations.of(context)!;
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
          t.faq,
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
            FaqTile(question: t.faqQ1, answer: t.faqA1),
            const SizedBox(height: 15),
            FaqTile(question: t.faqQ2, answer: t.faqA2),
            const SizedBox(height: 15),
            FaqTile(question: t.faqQ3, answer: t.faqA3),
            const SizedBox(height: 15),
            FaqTile(
              question: t.faqQ4,
              answer: t.faqA4,
              initiallyExpanded: true,
            ),
            const SizedBox(height: 15),
            FaqTile(question: t.faqQ5, answer: t.faqA5),
            const SizedBox(height: 15),
            FaqTile(question: t.faqQ6, answer: t.faqA6),
            const SizedBox(height: 40),

            // --- Contact Support Section ---
            Center(
              child: Text(
                t.stillHaveQuestions,
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
              text: t.contactSupport,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              },
              prefixIcon: const Icon(
                Icons.call,
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
}
