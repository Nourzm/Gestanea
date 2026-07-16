import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';

// --- Custom Neumorphic Container Widget (Reused) ---
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
          boxShadow: AppColors.shadow1,
        ),
        child: child,
      ),
    );
  }
}

// --- Custom Support Tile Widget ---
class SupportOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;

  const SupportOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor = AppColors.main500,
    this.titleColor = AppColors.textPrimary,
    this.subtitleColor = AppColors.main400,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.alerts.withAlpha(50),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: iconColor, size: 30),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Help & Support Screen Implementation ---
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          t.help_support,
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
                    t.weAreHereToHelp,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.chooseSupportOptionDescription,
                    style: TextStyle(
                      color: AppColors.main700.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Support Options List
            SupportOptionTile(
              icon: Icons.book_outlined,
              title: t.knowledgeBase,
              subtitle: t.browseArticlesAndGuides,
              onTap: () {},
              iconColor: AppColors.main500,
            ),
            const SizedBox(height: 15),
            SupportOptionTile(
              icon: Icons.chat_bubble_outline,
              title: t.liveChat,
              subtitle: t.chatWithSupportTeam,
              onTap: () {},
              iconColor: AppColors.main500,
            ),
            const SizedBox(height: 15),
            SupportOptionTile(
              icon: Icons.videocam_outlined,
              title: t.videoTutorials,
              subtitle: t.watchStepByStepGuides,
              onTap: () {},
              iconColor: AppColors.main500,
            ),
            const SizedBox(height: 15),
            SupportOptionTile(
              icon: Icons.email_outlined,
              title: t.emailSupport,
              subtitle: t.emailSupportAddress,
              onTap: () {},
              iconColor: AppColors.main500,
              subtitleColor:
                  AppColors.main600, // Make the email stand out slightly
            ),
            const SizedBox(height: 15),
            SupportOptionTile(
              icon: Icons.phone_outlined,
              title: t.phoneSupport,
              subtitle: t.phoneSupportNumber,
              onTap: () {},
              iconColor: AppColors.main500,
              subtitleColor:
                  AppColors.main600, // Make the number stand out slightly
            ),
            const SizedBox(height: 15),
            SupportOptionTile(
              icon: Icons.public_outlined,
              title: t.communityForum,
              subtitle: t.connectWithOtherUsers,
              onTap: () {},
              iconColor: AppColors.main500,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
