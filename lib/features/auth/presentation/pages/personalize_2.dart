import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/pregnancy_model.dart';
import 'package:gestanea/core/widgets/gradient_pill_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/pregnancy/data/datasources/pregnancy_local_data_source.dart';
import 'package:uuid/uuid.dart';

/// Onboarding step "How Far Along?" — week + extra-days picker, then writes an
/// active pregnancy row for the current user. Matches Figma frame 960:2789.
class Personalize2 extends StatefulWidget {
  const Personalize2({super.key});

  @override
  State<Personalize2> createState() => _Personalize2State();
}

class _Personalize2State extends State<Personalize2> {
  static const int _maxWeeks = 42;
  int _selectedWeek = 12;
  int _selectedExtraDays = 0;
  bool _byWeeks = true;
  DateTime? _byDateValue;
  bool _saving = false;

  String _trimesterFor(int week) {
    if (week <= 12) return '1st Trimester';
    if (week <= 27) return '2nd Trimester';
    return '3rd Trimester';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _byDateValue ?? now.subtract(const Duration(days: 84)),
      firstDate: now.subtract(const Duration(days: _maxWeeks * 7)),
      lastDate: now,
    );
    if (picked != null) {
      final daysSince = now.difference(picked).inDays;
      setState(() {
        _byDateValue = picked;
        _selectedWeek = (daysSince ~/ 7) + 1;
        _selectedExtraDays = daysSince % 7;
      });
    }
  }

  Future<void> _completeSetup() async {
    final auth = context.read<AuthBloc>().state;
    if (auth is! AuthAuthenticated) return;
    setState(() => _saving = true);

    final now = DateTime.now();
    final daysSinceLmp = (_selectedWeek - 1) * 7 + _selectedExtraDays;
    final lmp = now.subtract(Duration(days: daysSinceLmp));
    final due = lmp.add(const Duration(days: 280));

    final pregnancy = PregnancyModel(
      id: const Uuid().v4(),
      userId: auth.user.id,
      lmpDate: lmp,
      dueDate: due,
      currentWeek: _selectedWeek,
      currentTrimester: _trimesterFor(_selectedWeek),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final ds = PregnancyLocalDataSourceImpl(dbHelper: DatabaseHelper.instance);
      await ds.createPregnancy(pregnancy);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save pregnancy: $e')),
      );
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(
              title: 'How Far Along?',
              subtitle: "We'll calculate your due date",
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggle(),
                  const SizedBox(height: 20),
                  _buildTrimesterCard(),
                  const SizedBox(height: 20),
                  _byWeeks ? _buildWeekSlider() : _buildDatePicker(),
                  const SizedBox(height: 20),
                  _buildDayChips(),
                  const SizedBox(height: 28),
                  GradientPillButton(
                    label: 'Complete Setup',
                    isLoading: _saving,
                    onPressed: _saving ? null : _completeSetup,
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'You can update this information anytime',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
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

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        children: [
          _toggleOption('By Weeks', _byWeeks, () => setState(() => _byWeeks = true)),
          _toggleOption('By Date', !_byWeeks, () => setState(() => _byWeeks = false)),
        ],
      ),
    );
  }

  Widget _toggleOption(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.main500, AppColors.main600],
                  )
                : null,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.main500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrimesterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.main500, AppColors.main600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                _trimesterFor(_selectedWeek),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'You are',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_selectedWeek',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'weeks',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              if (_selectedExtraDays > 0) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '+$_selectedExtraDays day${_selectedExtraDays == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Weeks',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.main500,
              inactiveTrackColor: AppColors.main300,
              thumbColor: AppColors.main600,
              overlayColor: AppColors.main500.withValues(alpha: 0.2),
            ),
            child: Slider(
              min: 1,
              max: _maxWeeks.toDouble(),
              divisions: _maxWeeks - 1,
              value: _selectedWeek.toDouble(),
              onChanged: (v) => setState(() => _selectedWeek = v.round()),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Week 1', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text('Week 42', style: TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final label = _byDateValue == null
        ? 'Pick the first day of your last period'
        : '${_byDateValue!.year}-${_byDateValue!.month.toString().padLeft(2, '0')}-${_byDateValue!.day.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.shadow1,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.main500),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.main500),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Days',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(7, (i) {
              final selected = _selectedExtraDays == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedExtraDays = i),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: selected
                        ? const LinearGradient(
                            colors: [AppColors.main500, AppColors.main600],
                          )
                        : null,
                    border: selected
                        ? null
                        : Border.all(color: AppColors.main300, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$i',
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.main600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
