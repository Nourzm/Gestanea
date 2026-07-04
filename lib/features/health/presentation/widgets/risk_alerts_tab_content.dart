import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/measurement_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_state.dart';

/// Local emergency number dialed from the risk tab. Algeria SAMU (medical
/// emergencies). Kept as a single constant so it's trivial to change per region.
const String kEmergencyNumber = '115';

/// A computed risk level. [rank] orders severity: -1 unknown, 0 low, 1
/// moderate, 2 high — used to roll factors up into an overall level.
class _RiskLevel {
  final int rank;
  final String label;
  final Color bg;
  final Color fg;
  const _RiskLevel(this.rank, this.label, this.bg, this.fg);
}

class RiskAlertsTabContent extends StatefulWidget {
  const RiskAlertsTabContent({super.key});

  @override
  State<RiskAlertsTabContent> createState() => _RiskAlertsTabContentState();
}

class _RiskAlertsTabContentState extends State<RiskAlertsTabContent> {
  _RiskLevel _unknown(AppLocalizations l10n) =>
      _RiskLevel(-1, '—', const Color(0xFFE0E0E0), const Color(0xFF616161));
  _RiskLevel _low(AppLocalizations l10n) => _RiskLevel(
    0,
    l10n.lowRisk,
    const Color(0xFFB8E6B8),
    const Color(0xFF2D5F2D),
  );
  _RiskLevel _moderate(AppLocalizations l10n) => _RiskLevel(
    1,
    l10n.moderateRisk,
    const Color(0xFFFFE0B2),
    const Color(0xFF8A5A00),
  );
  _RiskLevel _high(AppLocalizations l10n) => _RiskLevel(
    2,
    l10n.highRisk,
    const Color(0xFFFFCDD2),
    const Color(0xFFB71C1C),
  );

  _RiskLevel _bpRisk(MeasurementModel? m, AppLocalizations l10n) {
    if (m?.systolic == null || m?.diastolic == null) return _unknown(l10n);
    final s = m!.systolic!;
    final d = m.diastolic!;
    if (s >= 140 || d >= 90) return _high(l10n);
    if (s >= 120 || d >= 80) return _moderate(l10n);
    return _low(l10n);
  }

  _RiskLevel _hrRisk(MeasurementModel? m, AppLocalizations l10n) {
    if (m?.heartRate == null) return _unknown(l10n);
    final hr = m!.heartRate!;
    if (hr < 50 || hr > 110) return _high(l10n);
    if (hr < 60 || hr > 100) return _moderate(l10n);
    return _low(l10n);
  }

  /// Guidance line shown under each factor, by severity.
  String _guidance(int rank, AppLocalizations l10n) {
    switch (rank) {
      case 0:
        return l10n.withinNormalRange;
      case 1:
        return l10n.monitorWithProvider;
      case 2:
        return l10n.contactProviderSoon;
      default:
        return l10n.addMeasurementToAssess;
    }
  }

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF0FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              l10n.emergencyCall,
              style: AppTextStyles.headline2.copyWith(
                color: AppColors.textDark,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.areYouSureCall911,
          style: AppTextStyles.body1.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              l10n.callNow,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final Uri phoneUri = Uri(scheme: 'tel', path: kEmergencyNumber);
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.couldNotMakeEmergencyCall),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppLocalizations.of(context)!.error}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mState = context.watch<MeasurementsBloc>().state;
    final MeasurementModel? latest = mState is MeasurementsLoaded
        ? mState.latest
        : null;

    final bp = _bpRisk(latest, l10n);
    final hr = _hrRisk(latest, l10n);

    // Overall = worst of the known factors.
    final knownRanks = [bp.rank, hr.rank].where((r) => r >= 0).toList();
    final overallRank = knownRanks.isEmpty
        ? -1
        : knownRanks.reduce((a, b) => a > b ? a : b);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Risk Status
                _buildOverallRiskCard(context, overallRank),

                const SizedBox(height: 20),

                // Risk Factors
                Text(
                  l10n.riskFactorsToMonitor,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                _buildRiskFactorCard(
                  context,
                  icon: Icons.favorite,
                  factor: l10n.bloodPressure,
                  level: bp,
                  description: latest?.systolic != null
                      ? '${latest!.bloodPressure} — ${_guidance(bp.rank, l10n)}'
                      : _guidance(bp.rank, l10n),
                ),
                const SizedBox(height: 12),
                _buildRiskFactorCard(
                  context,
                  icon: Icons.monitor_heart,
                  factor: l10n.heartRate,
                  level: hr,
                  description: latest?.heartRate != null
                      ? '${latest!.heartRate} ${l10n.bpm} — ${_guidance(hr.rank, l10n)}'
                      : _guidance(hr.rank, l10n),
                ),

                const SizedBox(height: 20),

                // Warning Signs (static reference content)
                _buildWarningSignsCard(context),

                const SizedBox(height: 16),

                // Emergency Contact
                _buildEmergencyContactCard(context),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(l10n.ifYouExperienceWarnings),
              ],
            ),
          ),
        ),

        // TOP inset shadow
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // LEFT inset shadow
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallRiskCard(BuildContext context, int rank) {
    final l10n = AppLocalizations.of(context)!;

    late final List<Color> gradient;
    late final IconData icon;
    late final String label;
    late final String desc;
    switch (rank) {
      case 0:
        gradient = const [Color(0xFF4CAF50), Color(0xFF66BB6A)];
        icon = Icons.check_circle;
        label = l10n.lowRisk;
        desc = l10n.allIndicatorsNormal;
        break;
      case 1:
        gradient = const [Color(0xFFFFA726), Color(0xFFFFB74D)];
        icon = Icons.warning_amber;
        label = l10n.moderateRisk;
        desc = l10n.someIndicatorsElevated;
        break;
      case 2:
        gradient = const [Color(0xFFE53935), Color(0xFFEF5350)];
        icon = Icons.error;
        label = l10n.highRisk;
        desc = l10n.someIndicatorsHigh;
        break;
      default:
        gradient = const [Color(0xFF9E9E9E), Color(0xFFBDBDBD)];
        icon = Icons.help_outline;
        label = '—';
        desc = l10n.addMeasurementToAssess;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.overallRiskLevel,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFactorCard(
    BuildContext context, {
    required IconData icon,
    required String factor,
    required _RiskLevel level,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.main300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.main500, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.smallLabel.copyWith(
                    fontSize: 11,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: level.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              level.label,
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 11,
                color: level.fg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSignsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber,
                color: Color(0xFF856404),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.warningSignsToWatch,
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF856404),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWarningSignItem(l10n.severeHeadache),
          _buildWarningSignItem(l10n.blurredVision),
          _buildWarningSignItem(l10n.severeAbdominalPain),
          _buildWarningSignItem(l10n.decreasedFetalMovement),
          _buildWarningSignItem(l10n.vaginalBleeding),
        ],
      ),
    );
  }

  Widget _buildWarningSignItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFF856404)),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.body1.copyWith(
              fontSize: 12,
              color: const Color(0xFF856404),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _makeEmergencyCall(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFEF5350)],
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone, color: AppColors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.emergencyContact,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.call911OrProvider,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: AppColors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5F2),
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
      child: Text(
        message,
        style: AppTextStyles.body1.copyWith(
          color: const Color(0xFF7B4BA6),
          fontSize: 12,
        ),
      ),
    );
  }
}
