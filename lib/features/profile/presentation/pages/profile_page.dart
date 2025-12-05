import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/features/profile/presentation/pages/about_app.dart';
import 'package:gestanea/features/profile/presentation/pages/contactus.dart';
import 'package:gestanea/features/profile/presentation/pages/faq.dart';
import 'package:gestanea/features/profile/presentation/pages/languages.dart';
import 'package:gestanea/features/profile/presentation/pages/notifications_settings.dart';
import 'package:gestanea/features/profile/presentation/pages/privacy.dart';
import 'package:gestanea/features/profile/presentation/pages/profile_edit.dart';
import 'package:gestanea/features/profile/presentation/pages/security.dart';
import 'package:gestanea/features/profile/presentation/pages/support.dart';

class HeaderCurveClipper extends CustomClipper<Path> {
  final double curveStartRatio = 0.8824;
  final double curvePeakRatio = 1.0;

  @override
  Path getClip(Size size) {
    Path path = Path();

    double curveStartHeight = size.height * curveStartRatio;
    double curvePeakHeight = size.height * curvePeakRatio;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, curveStartHeight); // P3

    path.cubicTo(
      size.width * 0.6967, // C1 X (271.719/390)
      curvePeakHeight, // C1 Y (263.122/263 -> approximated to curvePeakHeight)
      size.width *
          0.4974, // C2 X - We treat P4 (Center Peak) as the second control point in this segment
      curvePeakHeight, // C2 Y - P4 Y (263/263)
      size.width * 0.4974, // End X - This should be the center peak P4
      curvePeakHeight, // End Y - P4
    );

    path.cubicTo(
      size.width * 0.3001, // C1 X (117.05/390)
      curvePeakHeight, // C1 Y (262.878/263 -> approximated to curvePeakHeight)
      size.width *
          0.0, // C2 X - We use the left edge as the second control point for a smooth transition
      curveStartHeight, // C2 Y - P5 Y
      size.width * 0.0, // End X - P5
      curveStartHeight, // End Y - P5
    );
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

const Color kLightPurple = Color(0xFFEFE8F5);
const Color kDangerRed = Color(0xFFD62A2A);
const Color kInactiveText = Color(0xFFAC5DCC);

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section (Curved Background and Profile Info)
          _buildHeader(context),

          // Settings List (Responsiveness handled by ListView)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16), // Padding after the header curve
                // --- Settings Group 1 ---
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: "assets/icons/notifications.svg",
                      title: 'Notifications',
                      destination: NotificationsSettings(),
                    ),
                    _SettingsTile(
                      icon: "assets/icons/Global.svg",
                      title: 'Language',
                      destination: LanguagesPage(),
                    ),
                    _SettingsTile(
                      icon: "assets/icons/privacy.svg",
                      title: 'Security',
                      destination: SecurityPage(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Status Group 2 (Actions) ---
                _SettingsGroup(
                  children: [
                    _ActionTile(title: 'I gave birth', color: AppColors.alerts),
                    _ActionTile(
                      title: 'No longer pregnant',
                      color: AppColors.error1,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Support Group 3 ---
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: "assets/icons/question.svg",
                      title: 'FAQ',
                      destination: FaqScreen(),
                    ),
                    _SettingsTile(
                      icon: "assets/icons/help.svg",
                      title: 'Help & Support',
                      destination: HelpSupportScreen(),
                    ),
                    _SettingsTile(
                      icon: "assets/icons/contactus.svg",
                      title: 'Contact us',
                      destination: ContactUsScreen(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: "assets/icons/lock.svg",
                      title: 'Privacy policy',
                      destination: PrivacyPolicyScreen(),
                    ),
                    _SettingsTile(
                      icon: "assets/icons/info.svg",
                      title: 'About App',
                      destination: AboutScreen(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Logout Button ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _LogoutButton(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // Determines the appropriate header height based on screen size for responsiveness
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.3;

    return ClipPath(
      clipper: HeaderCurveClipper(),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        height: headerHeight,
        width: double.infinity,
        child: SafeArea(
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFBAA0D2),
                  Color(0xFFB599CE),
                ],
                stops: [0.0, 0.5529, 1.0],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Top spacing
                _buildProfileAvatar(context),
                const SizedBox(height: 10),
                const Text(
                  'Puerto Rico',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Profile Image
          Container(
            width: 100, // radius * 2
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white, // your border color
                width: 3, // border thickness
              ),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/profile.png"),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Edit Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.edit, color: AppColors.main500, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// --- List Item Widgets ---

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    // Container to hold the list group with subtle elevation/spacing
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.main300,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(4, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0xFFFFFFFF),
              blurRadius: 10,
              offset: Offset(-6, -6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: children.map((item) {
            // Add a divider after every item except the last one
            int index = children.indexOf(item);
            return Column(
              children: [
                item,
                if (index < children.length - 1)
                  Divider(height: 1, thickness: 1, color: AppColors.purpleGrey),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final Widget destination;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Needed for ripple + preserve UI
      child: InkWell(
        hoverColor: Colors.black.withOpacity(0.04), // subtle hover
        splashColor: AppColors.main500.withOpacity(0.2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          leading: SizedBox(
            height: 30,
            width: 30,
            child: SvgPicture.asset(
              icon,
              color: AppColors.main500,
              width: 20,
              height: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final Color color;

  const _ActionTile({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
      onTap: () {
        // Handle action (e.g., reset pregnancy status)
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Color(0x7FFFFFFF),
            blurRadius: 10,
            offset: Offset(-6, -6),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.error2,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(0xFFDFE2E8), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/Logout.svg"),
              const SizedBox(width: 16),
              const Text(
                'Log out',
                style: TextStyle(
                  color: Color(0xFF191B23),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
