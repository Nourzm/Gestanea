import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/profile/presentation/pages/change_password_page.dart';
import 'package:gestanea/features/profile/presentation/widgets/neuo_container.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _autoLockEnabled = false;

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
          t.security,
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
          horizontal: screenWidth * 0.04,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeumorphicContainer(
              color: AppColors.main300,
              padding: EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.main500,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.security,
                      color: AppColors.white,
                      size: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t.secureYourAccount,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.enableSecurityFeaturesDescription,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 2. Security Options List
            _buildOptionTile(
              icon: Icons.vpn_key_outlined,
              title: t.changePassword,
              subtitle: t.lastChangedDaysAgo,
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.main600,
                size: 30,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            _buildSwitchTile(
              icon: Icons.fingerprint,
              title: t.biometricAuthentication,
              subtitle: t.useFingerprintOrFaceId,
              value: _biometricEnabled,
              onChanged: (val) {
                setState(() {
                  _biometricEnabled = val;
                });
              },
            ),
            const SizedBox(height: 15),

            _buildSwitchTile(
              icon: Icons.phonelink_lock_outlined,
              title: t.twoFactorAuthentication,
              subtitle: t.addExtraLayerSecurity,
              value: _twoFactorEnabled,
              onChanged: (val) {
                setState(() {
                  _twoFactorEnabled = val;
                });
              },
            ),
            const SizedBox(height: 15),

            _buildSwitchTile(
              icon: Icons.lock_outline,
              title: t.autoLock,
              subtitle: t.lockAppAfterInactivity,
              value: _autoLockEnabled,
              onChanged: (val) {
                setState(() {
                  _autoLockEnabled = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return NeumorphicContainer(
      color: AppColors.main300,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: AppColors.main600, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 13),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  // Helper method for switch list tiles
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return NeumorphicContainer(
      color: AppColors.main300,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
      child: Row(
        children: [
          Icon(icon, color: AppColors.main600, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              return AppColors.main500; // Greyish thumb when inactive
            }),
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.main500,
            inactiveTrackColor: AppColors.white,
            thumbColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white; // White thumb when active
              }
              return AppColors.main500; // Greyish thumb when inactive
            }),
          ),
        ],
      ),
    );
  }
}
