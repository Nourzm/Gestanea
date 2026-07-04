import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/preg_post.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class Personalize1 extends StatefulWidget {
  const Personalize1({super.key});

  @override
  State<Personalize1> createState() => _Personalize1State();
}

class _Personalize1State extends State<Personalize1> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(title: t.tellUsAboutYou, subtitle: t.helpPersonalize),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.02,
              ),
              child: PregnancySelectionScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
