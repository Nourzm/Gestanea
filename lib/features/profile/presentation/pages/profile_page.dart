import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/profile/presentation/pages/about_app.dart';
import 'package:gestanea/features/profile/presentation/pages/contactus.dart';
import 'package:gestanea/features/profile/presentation/pages/faq.dart';
import 'package:gestanea/features/profile/presentation/pages/languages.dart';
import 'package:gestanea/features/profile/presentation/pages/notifications_settings.dart';
import 'package:gestanea/features/profile/presentation/pages/privacy.dart';
import 'package:gestanea/features/profile/presentation/pages/profile_edit.dart';
import 'package:gestanea/features/profile/presentation/pages/security.dart';
import 'package:gestanea/features/profile/presentation/pages/support.dart';
import 'package:gestanea/features/profile/presentation/widgets/logout_dia.dart';
import 'package:gestanea/l10n/app_localizations.dart';

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
      size.width * 0.6967,
      curvePeakHeight,
      size.width * 0.4974,
      curvePeakHeight,
      size.width * 0.4974,
      curvePeakHeight,
    );

    path.cubicTo(
      size.width * 0.3001,
      curvePeakHeight,
      size.width * 0.0,
      curveStartHeight,
      size.width * 0.0,
      curveStartHeight,
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section (Curved Background and Profile Info)
          _buildHeader(context),
          // Settings List (Responsiveness handled by ListView)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 16), // Padding after the header curve
                  // --- Settings Group 1 ---
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: "assets/icons/notifications.svg",
                        title: t.notifications,
                        destination: const NotificationsSettings(),
                      ),
                      _SettingsTile(
                        icon: "assets/icons/Global.svg",
                        title: t.language,
                        destination: const LanguagesPage(),
                      ),
                      _SettingsTile(
                        icon: "assets/icons/privacy.svg",
                        title: t.security,
                        destination: const SecurityPage(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // --- Status Group 2 (Actions) ---
                  _SettingsGroup(
                    children: [
                      _ActionTile(
                        title: t.i_gave_birth,
                        color: AppColors.alerts,
                      ),
                      _ActionTile(
                        title: t.no_longer_pregnant,
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
                        title: t.help_support,
                        destination: HelpSupportScreen(),
                      ),
                      _SettingsTile(
                        icon: "assets/icons/contactus.svg",
                        title: t.contact_us,
                        destination: ContactUsScreen(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: "assets/icons/lock.svg",
                        title: t.privacy_policy,
                        destination: PrivacyPolicyScreen(),
                      ),
                      _SettingsTile(
                        icon: "assets/icons/info.svg",
                        title: t.about_app,
                        destination: const AboutScreen(),
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
                  AppColors.bg_1,
                  const Color(0xFFBAA0D2),
                  const Color(0xFFB599CE),
                ],
                stops: [0.0, 0.5529, 1.0],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_ProfileHeaderContent()],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String displayName = t.unknown;
        String email = '';
        if (state is AuthAuthenticated) {
          displayName = state.user.name;
          email = state.user.email;
        }

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage("assets/images/pfp.png"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    margin: const EdgeInsets.only(right: 4, bottom: 4),
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
            const SizedBox(height: 6),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                email,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ],
        );
      },
    );
  }
}

// --- List Item Widgets ---

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.main300,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0x3F000000),
              blurRadius: 4,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: const Color(0xFFFFFFFF),
              blurRadius: 10,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: Column(
          children: children.map((item) {
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
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.black.withOpacity(0.04),
        splashColor: AppColors.main500.withOpacity(0.2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6,
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
        // Implement action flows as needed
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  Future<void> _confirmLogout(BuildContext context) async {
    final t = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => NeumorphicAlertDialog(
        context: ctx,
        title: t.logout,
        content: t.logout_confirmation,
        actionsRow: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Cancel Button
            Expanded(
              child: buildDialogButton(
                text: t.cancel,
                color: AppColors.main400,
                onPressed: () => Navigator.pop(ctx, false),
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 15),
            // Logout Button (Using AppColors.error1 for a distinct warning look)
            Expanded(
              child: buildDialogButton(
                text: t.logout,
                color: AppColors
                    .error1, // Assuming error1 is the primary error/warning color
                onPressed: () => Navigator.pop(ctx, true),
                isPrimary: true,
              ),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      // Original logic remains the same
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // route to login page
          Navigator.pushReplacementNamed(context, AppRoutes.auth);
        } else if (state is AuthFailure) {
          final msg = state.message.replaceAll('Exception: ', '');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0x3F000000),
              blurRadius: 4,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: const Color(0x7FFFFFFF),
              blurRadius: 10,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _confirmLogout(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.error2,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFDFE2E8), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/Logout.svg"),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.logout,
                  style: const TextStyle(
                    color: Color(0xFF191B23),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
