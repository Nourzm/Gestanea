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

// --- Custom Notification Switch Tile Widget ---
class NotificationSwitchTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool initialValue;

  const NotificationSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initialValue,
  });

  @override
  State<NotificationSwitchTile> createState() => _NotificationSwitchTileState();
}

class _NotificationSwitchTileState extends State<NotificationSwitchTile> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialValue;
  }

  void _onChanged(bool value) {
    setState(() {
      _isEnabled = value;
    });
    // In a real app, you would save this preference here.
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Row(
        children: <Widget>[
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: AppColors.main400.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Customizing the Switch for the neumorphic look
          Switch(
            value: _isEnabled,
            onChanged: _onChanged,
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              return AppColors.main500; // Greyish thumb when inactive
            }),
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

// --- Notifications Screen Implementation ---
class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
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
          t.notifications,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                t.manageNotificationPreferences,
                style: TextStyle(
                  color: AppColors.main700.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Notification Toggles List
            NotificationSwitchTile(
              title: t.pushNotifications,
              subtitle: t.receiveNotificationsOnDevice,
              initialValue: true,
            ),
            const SizedBox(height: 15),
            NotificationSwitchTile(
              title: t.emailNotifications,
              subtitle: t.getUpdatesViaEmail,
              initialValue: true,
            ),
            const SizedBox(height: 15),
            NotificationSwitchTile(
              title: t.appointmentReminders,
              subtitle: t.neverMissAppointment,
              initialValue: true,
            ),
            const SizedBox(height: 15),
            NotificationSwitchTile(
              title: t.healthTips,
              subtitle: t.dailyWellnessRecommendations,
              initialValue: true,
            ),
            const SizedBox(height: 15),
            NotificationSwitchTile(
              title: t.weeklyReports,
              subtitle: t.healthProgressSummary,
              initialValue: false, // Defaulting to off based on image state
            ),
            const SizedBox(height: 15),
            NotificationSwitchTile(
              title: t.vitaminReminders,
              subtitle: t.dontForgetSupplements,
              initialValue: true,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
