import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/pregnancy_model.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancy/data/datasources/pregnancy_local_data_source.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_state.dart';

/// Healthy total weight-gain ranges (kg) by pre-pregnancy BMI category
/// (Institute of Medicine guidelines for a singleton pregnancy).
class _GainRange {
  final double min;
  final double max;
  const _GainRange(this.min, this.max);
}

class BMICard extends StatefulWidget {
  const BMICard({super.key});

  @override
  State<BMICard> createState() => _BMICardState();
}

class _BMICardState extends State<BMICard> {
  final PregnancyLocalDataSource _pregnancyDs = PregnancyLocalDataSourceImpl();

  String? _userId;
  PregnancyModel? _pregnancy;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userId == null) {
      final auth = context.read<AuthBloc>().state;
      _userId = auth is AuthAuthenticated ? auth.user.id : null;
      _load();
    }
  }

  Future<void> _load() async {
    if (_userId == null) {
      setState(() => _loading = false);
      return;
    }
    final preg = await _pregnancyDs.getActivePregnancyByStringId(_userId!);
    if (!mounted) return;
    setState(() {
      _pregnancy = preg;
      _loading = false;
    });
  }

  int? get _currentWeek {
    final p = _pregnancy;
    if (p == null) return null;
    final days = DateTime.now().difference(p.lmpDate).inDays;
    final w = (days ~/ 7) + 1;
    return w.clamp(1, 42);
  }

  _GainRange _rangeFor(double bmi) {
    if (bmi < 18.5) return const _GainRange(12.5, 18);
    if (bmi < 25) return const _GainRange(11.5, 16);
    if (bmi < 30) return const _GainRange(7, 11.5);
    return const _GainRange(5, 9);
  }

  String _categoryLabel(double bmi, AppLocalizations l10n) {
    if (bmi < 18.5) return l10n.bmiUnderweight;
    if (bmi < 25) return l10n.normalBMI;
    if (bmi < 30) return l10n.bmiOverweight;
    return l10n.bmiObese;
  }

  Future<void> _showSetupDialog() async {
    final p = _pregnancy;
    if (p == null) return;
    final l10n = AppLocalizations.of(context)!;
    final heightCtrl = TextEditingController(
      text: p.heightCm != null ? _trim(p.heightCm!) : '',
    );
    final weightCtrl = TextEditingController(
      text: p.prePregnancyWeight != null ? _trim(p.prePregnancyWeight!) : '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFAF0FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.setUpBmiTracking,
          style: AppTextStyles.headline2.copyWith(
            fontSize: 18,
            color: AppColors.textDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: heightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.heightCmLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.prePregnancyWeightLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.main500,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (saved != true) return;
    final h = double.tryParse(heightCtrl.text.replaceAll(',', '.'));
    final w = double.tryParse(weightCtrl.text.replaceAll(',', '.'));
    if (h == null || w == null || h < 120 || h > 220 || w < 30 || w > 200) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterValidNumber)));
      }
      return;
    }
    final updated = p.copyWith(
      heightCm: h,
      prePregnancyWeight: w,
      updatedAt: DateTime.now(),
    );
    await _pregnancyDs.updatePregnancy(updated);
    if (!mounted) return;
    setState(() => _pregnancy = updated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return _shell(
        child: const SizedBox(
          height: 60,
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    final p = _pregnancy;
    final hasSetup = p?.heightCm != null && p?.prePregnancyWeight != null;

    if (!hasSetup) {
      return _shell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.prePregnancyBMI,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.white,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bmiSetupPrompt,
              style: AppTextStyles.smallLabel.copyWith(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: p == null ? null : _showSetupDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.main600,
                ),
                child: Text(l10n.setUpBmiTracking),
              ),
            ),
          ],
        ),
      );
    }

    final heightM = p!.heightCm! / 100.0;
    final bmi = p.prePregnancyWeight! / (heightM * heightM);
    final range = _rangeFor(bmi);

    // Current gain from the latest logged weight, if any.
    final mState = context.watch<MeasurementsBloc>().state;
    final latestWeight = mState is MeasurementsLoaded
        ? mState.latest?.weight
        : null;
    final currentGain = latestWeight != null
        ? latestWeight - p.prePregnancyWeight!
        : null;

    // Expected gain so far for the current week (rough: scaled to the
    // mid-range across ~40 weeks). Educational, not a clinical figure.
    final week = _currentWeek ?? 0;
    final expected =
        ((range.min + range.max) / 2) * (week / 40).clamp(0.0, 1.0);

    final progress = currentGain != null && range.max > 0
        ? (currentGain / range.max).clamp(0.0, 1.0)
        : 0.0;

    return _shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.prePregnancyBMI,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.white,
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: _showSetupDialog,
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      l10n.edit,
                      style: AppTextStyles.smallLabel.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${bmi.toStringAsFixed(1)} (${_categoryLabel(bmi, l10n)})',
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          Text(
            '${l10n.currentGain}: ${currentGain != null ? '${_trim(currentGain)} kg' : '—'}',
            style: AppTextStyles.smallLabel.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.targetRange,
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '${_trim(range.min)} - ${_trim(range.max)} kg',
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${l10n.expected}: ${expected.toStringAsFixed(1)} kg',
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The shared purple gradient container around the card content.
  Widget _shell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.main500, Color(0xFFB388CC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  String _trim(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}
