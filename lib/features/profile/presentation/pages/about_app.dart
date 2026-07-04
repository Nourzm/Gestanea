import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';

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
    this.baseColor = AppColors.background,
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

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          t.about_app,
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
            // 1. App Logo and Version Info (Top Center)
            Center(
              child: Column(
                children: [
                  NeumorphicContainer(
                    borderRadius: 90.0,
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      "assets/images/fetus.png",
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'MomCare',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Version 2.1.0',
                    style: TextStyle(color: AppColors.main400, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. App Description Box
            NeumorphicContainer(
              borderRadius: 30.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30.0,
              ),
              child: Text(
                t.aboutDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. User Stats Row
            Row(
              children: <Widget>[
                // Active Users Card
                Expanded(
                  child: NeumorphicContainer(
                    borderRadius: 20.0,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Icon(Icons.group, color: AppColors.main500, size: 30),
                        const SizedBox(height: 8),
                        Text(
                          '100K+',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          t.activeUsers,
                          style: TextStyle(
                            color: AppColors.main400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // App Rating Card
                Expanded(
                  child: NeumorphicContainer(
                    borderRadius: 20.0,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Icon(Icons.star, color: AppColors.main500, size: 30),
                        const SizedBox(height: 8),
                        Text(
                          '4.8\u2605',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          t.appRating,
                          style: TextStyle(
                            color: AppColors.main400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Version Info Tile
            _buildInfoTile(
              icon: Icons.code,
              title: t.versionInfo,
              subtitle: 'Build 2.1.0 (245)',
              onTap: () {},
            ),
            const SizedBox(height: 15),

            // 5. Made with Love Tile
            _buildInfoTile(
              icon: Icons.favorite_border,
              title: t.madeWithLove,
              subtitle: t.madeWithLoveSub,
              onTap: () {},
            ),
            const SizedBox(height: 40),

            // 6. Footer Copyright
            Center(
              child: Text(
                t.copyrightNotice,
                style: TextStyle(color: AppColors.main400, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method for the bottom list tiles
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return NeumorphicContainer(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.main500),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.main400, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
