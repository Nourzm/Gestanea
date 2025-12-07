import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/features/profile/presentation/pages/notifications_settings.dart';
import 'package:gestanea/features/profile/presentation/pages/languages.dart';
import 'package:gestanea/features/profile/presentation/pages/security.dart';
import 'package:gestanea/features/profile/presentation/pages/about_app.dart';
import 'package:gestanea/features/profile/presentation/pages/contactus.dart';
import 'package:gestanea/features/profile/presentation/pages/faq.dart';
import 'package:gestanea/features/profile/presentation/pages/privacy.dart';
import 'package:gestanea/features/profile/presentation/pages/support.dart';
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
    path.lineTo(size.width, curveStartHeight);

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

class BabySettingsPage extends StatefulWidget {
  const BabySettingsPage({super.key});

  @override
  State<BabySettingsPage> createState() => _BabySettingsPageState();
}

class _BabySettingsPageState extends State<BabySettingsPage> {
  Color _getGenderColor(String? gender) {
    if (gender == null) return AppColors.main500;
    final isGirl = gender.toLowerCase() == 'girl' || 
                   gender.toLowerCase() == 'female';
    return isGirl 
      ? const Color(0xFFFF9EC9)  // Pink for girls
      : const Color(0xFF87CEEB); // Blue for boys
  }

  void _showEditBabyInfoDialog(BuildContext context, BabyLoaded state) {
    late TextEditingController nameController;
    String? selectedGender;

    nameController = TextEditingController(text: state.baby.name);
    selectedGender = state.baby.gender;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final genderColor = _getGenderColor(selectedGender);

            return AlertDialog(
              title: const Text(
                'Change Baby Info',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baby Name Field
                    Text(
                      'Baby Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: genderColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: genderColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    // Baby Gender Field
                    Text(
                      'Baby Gender',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: genderColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedGender = 'boy';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedGender == 'boy'
                                    ? const Color(0xFF87CEEB).withValues(alpha: 0.2)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedGender == 'boy'
                                      ? const Color(0xFF87CEEB)
                                      : Colors.grey.shade300,
                                  width: selectedGender == 'boy' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.male,
                                    color: selectedGender == 'boy'
                                        ? const Color(0xFF87CEEB)
                                        : Colors.grey.shade400,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Boy',
                                    style: TextStyle(
                                      color: selectedGender == 'boy'
                                          ? const Color(0xFF87CEEB)
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedGender = 'girl';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedGender == 'girl'
                                    ? const Color(0xFFFF9EC9).withValues(alpha: 0.2)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedGender == 'girl'
                                      ? const Color(0xFFFF9EC9)
                                      : Colors.grey.shade300,
                                  width: selectedGender == 'girl' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.female,
                                    color: selectedGender == 'girl'
                                        ? const Color(0xFFFF9EC9)
                                        : Colors.grey.shade400,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Girl',
                                    style: TextStyle(
                                      color: selectedGender == 'girl'
                                          ? const Color(0xFFFF9EC9)
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nameController.dispose();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Please enter baby name')),
                      );
                      return;
                    }

                    try {
                      final updatedBaby = BabyModel(
                        id: state.baby.id,
                        userId: state.baby.userId,
                        name: nameController.text.trim(),
                        gender: selectedGender,
                        dateOfBirth: state.baby.dateOfBirth,
                        birthWeight: state.baby.birthWeight,
                        birthHeight: state.baby.birthHeight,
                        themeColor: state.baby.themeColor,
                        isActive: state.baby.isActive,
                        createdAt: state.baby.createdAt,
                        updatedAt: DateTime.now(),
                      );

                      // ignore: use_build_context_synchronously
                      await context.read<BabyCubit>().updateBabyProfile(updatedBaby);

                      if (mounted) {
                        nameController.dispose();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(dialogContext);
                        // Reload baby profile to reflect changes
                        // ignore: use_build_context_synchronously
                        context.read<BabyCubit>().loadBabyProfile();
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Baby information updated successfully!'),
                            backgroundColor: AppColors.alerts,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: AppColors.error1,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<BabyCubit, BabyState>(
      builder: (context, state) {
        if (state is BabyLoading) {
          return Scaffold(
            backgroundColor: AppColors.bg_1,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.main500),
            ),
          );
        }

        if (state is! BabyLoaded) {
          return Scaffold(
            backgroundColor: AppColors.bg_1,
            appBar: AppBar(
              backgroundColor: AppColors.bg_1,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, 
                  color: AppColors.main500, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0,
            ),
            body: const Center(
              child: Text('Error loading baby information'),
            ),
          );
        }

        final genderColor = _getGenderColor(state.baby.gender);

        return Scaffold(
          backgroundColor: AppColors.bg_1,
          body: Column(
            children: [
              // Header Section (Curved Background and Baby Info)
              _buildHeader(context, state, genderColor),
              // Settings List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 16),
                      // --- Change Baby Info Button ---
                      Padding(
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showEditBabyInfoDialog(context, state),
                              borderRadius: BorderRadius.circular(15),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                leading: Icon(
                                  Icons.edit,
                                  color: genderColor,
                                  size: 24,
                                ),
                                title: Text(
                                  'Change Baby Info',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: genderColor,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: genderColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      // --- Support Group ---
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, BabyLoaded state, Color genderColor) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.38;

    return ClipPath(
      clipper: HeaderCurveClipper(),
      child: Container(
        height: headerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              genderColor.withValues(alpha: 0.3),
              genderColor.withValues(alpha: 0.15),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: genderColor,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: genderColor,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/baby.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.child_care,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.baby.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        hoverColor: Colors.black.withValues(alpha: 0.04),
        splashColor: AppColors.main500.withValues(alpha: 0.2),
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
