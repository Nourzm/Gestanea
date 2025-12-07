import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
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
  late TextEditingController _nameController;
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _getGenderColor(String? gender) {
    if (gender == null) return AppColors.main500;
    final isGirl = gender.toLowerCase() == 'girl' || 
                   gender.toLowerCase() == 'female';
    return isGirl 
      ? const Color(0xFFFF9EC9)  // Pink for girls
      : const Color(0xFF87CEEB); // Blue for boys
  }

  void _initializeForm(BabyLoaded state) {
    _nameController.text = state.baby.name;
    _selectedGender = state.baby.gender;
  }

  Future<void> _saveBabySettings(BabyLoaded state) async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter baby name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedBaby = BabyModel(
        id: state.baby.id,
        userId: state.baby.userId,
        name: _nameController.text.trim(),
        gender: _selectedGender,
        dateOfBirth: state.baby.dateOfBirth,
        birthWeight: state.baby.birthWeight,
        birthHeight: state.baby.birthHeight,
        themeColor: state.baby.themeColor,
        isActive: state.baby.isActive,
        createdAt: state.baby.createdAt,
        updatedAt: DateTime.now(),
      );

      await context.read<BabyCubit>().updateBabyProfile(updatedBaby);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Baby information updated successfully!'),
            backgroundColor: AppColors.alerts,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error1,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

        // Initialize form on first build
        if (_nameController.text.isEmpty) {
          _initializeForm(state);
        }

        final genderColor = _getGenderColor(_selectedGender);

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
                      // --- Edit Baby Info Group ---
                      _EditBabyGroup(
                        nameController: _nameController,
                        selectedGender: _selectedGender,
                        onGenderChanged: (gender) {
                          setState(() => _selectedGender = gender);
                        },
                        genderColor: genderColor,
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
                      const SizedBox(height: 24),
                      // --- Save Button ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: genderColor,
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: genderColor.withOpacity(0.3),
                                offset: const Offset(0, 8),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isLoading ? null : () => _saveBabySettings(state),
                              borderRadius: BorderRadius.circular(25.0),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
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
              genderColor.withOpacity(0.3),
              genderColor.withOpacity(0.15),
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
                      style: TextStyle(
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

class _EditBabyGroup extends StatefulWidget {
  final TextEditingController nameController;
  final String? selectedGender;
  final Function(String) onGenderChanged;
  final Color genderColor;

  const _EditBabyGroup({
    required this.nameController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.genderColor,
  });

  @override
  State<_EditBabyGroup> createState() => _EditBabyGroupState();
}

class _EditBabyGroupState extends State<_EditBabyGroup> {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baby Name Field
              Text(
                'Baby Name',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: widget.genderColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: widget.nameController,
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
                    borderSide: BorderSide(color: widget.genderColor, width: 2),
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
                  color: widget.genderColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {});
                        widget.onGenderChanged('boy');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: widget.selectedGender == 'boy'
                              ? const Color(0xFF87CEEB).withOpacity(0.2)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.selectedGender == 'boy'
                                ? const Color(0xFF87CEEB)
                                : Colors.grey.shade300,
                            width: widget.selectedGender == 'boy' ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.male,
                              color: widget.selectedGender == 'boy'
                                  ? const Color(0xFF87CEEB)
                                  : Colors.grey.shade400,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Boy',
                              style: TextStyle(
                                color: widget.selectedGender == 'boy'
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
                        setState(() {});
                        widget.onGenderChanged('girl');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: widget.selectedGender == 'girl'
                              ? const Color(0xFFFF9EC9).withOpacity(0.2)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.selectedGender == 'girl'
                                ? const Color(0xFFFF9EC9)
                                : Colors.grey.shade300,
                            width: widget.selectedGender == 'girl' ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.female,
                              color: widget.selectedGender == 'girl'
                                  ? const Color(0xFFFF9EC9)
                                  : Colors.grey.shade400,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Girl',
                              style: TextStyle(
                                color: widget.selectedGender == 'girl'
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
