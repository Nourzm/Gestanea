import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/widgets/gradient_pill_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

/// Onboarding step "Tell Us About Your Baby" — gender, birth date, weight,
/// height. Writes an active baby row for the current user. Matches Figma
/// frame 1028:2677.
class Personalize3 extends StatefulWidget {
  const Personalize3({super.key});

  @override
  State<Personalize3> createState() => _Personalize3State();
}

class _Personalize3State extends State<Personalize3> {
  String _gender = 'girl';
  DateTime? _birthDate;
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _continue() async {
    final auth = context.read<AuthBloc>().state;
    if (auth is! AuthAuthenticated) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleasePickBirthDate),
        ),
      );
      return;
    }
    setState(() => _saving = true);

    final now = DateTime.now();
    final baby = BabyModel(
      id: const Uuid().v4(),
      userId: auth.user.id,
      name: _nameController.text.trim().isEmpty
          ? AppLocalizations.of(context)!.babyDefault
          : _nameController.text.trim(),
      gender: _gender,
      dateOfBirth: _birthDate!,
      birthWeight: double.tryParse(_weightController.text.replaceAll(',', '.')),
      birthHeight: double.tryParse(_heightController.text.replaceAll(',', '.')),
      themeColor: _gender == 'girl' ? 'pink' : 'blue',
      createdAt: now,
      updatedAt: now,
    );

    try {
      final ds = BabyLocalDataSource(DatabaseHelper.instance);
      await ds.createBaby(baby);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.couldNotSaveBaby('$e')),
        ),
      );
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(
              title: t.tellAboutBabyMultiline,
              subtitle: t.helpPersonalizedCare,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(t.babysName),
                  _fieldShell(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. Emma',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _label(t.babysGender),
                  Row(
                    children: [
                      Expanded(child: _genderTile('girl', '👧', t.girlLabel)),
                      const SizedBox(width: 12),
                      Expanded(child: _genderTile('boy', '👦', t.boyLabel)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _label(t.babysBirthDate),
                  GestureDetector(
                    onTap: _pickBirthDate,
                    child: _fieldShell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.main500,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _birthDate == null
                                ? t.pickADate
                                : '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(t.weight),
                            _fieldShell(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.monitor_weight_outlined,
                                    size: 18,
                                    color: AppColors.main500,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _weightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '0.0',
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'kg',
                                    style: TextStyle(
                                      color: AppColors.main500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(t.heightLabel),
                            _fieldShell(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.straighten,
                                    size: 18,
                                    color: AppColors.main500,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _heightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '0',
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'cm',
                                    style: TextStyle(
                                      color: AppColors.main500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  GradientPillButton(
                    label: t.continueToDashboard,
                    isLoading: _saving,
                    onPressed: _saving ? null : _continue,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      t.infoKeptPrivate,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
  );

  Widget _fieldShell({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: AppColors.shadow1,
    ),
    child: child,
  );

  Widget _genderTile(String value, String emoji, String label) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [AppColors.main500, AppColors.main600],
                )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.main600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
