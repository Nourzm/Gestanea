import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class RiskAlertsTabContent extends StatefulWidget {
  const RiskAlertsTabContent({super.key});
  
  @override
  State<RiskAlertsTabContent> createState() => _RiskAlertsTabContentState();
}

class _RiskAlertsTabContentState extends State<RiskAlertsTabContent> {

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final l10n = AppLocalizations. of(context)!;
    
    // Show confirmation dialog first
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
            color: Colors.grey. shade600,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: Colors.grey. shade600),
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
              l10n. callNow,
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
      final Uri phoneUri = Uri(scheme: 'tel', path: '911');
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
              content: Text('Error: $e'),
              backgroundColor: Colors. red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations. of(context)!;

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
                _buildOverallRiskCard(context),

                const SizedBox(height: 20),

                // Risk Factors
                Text(
                  l10n. riskFactorsToMonitor,
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
                  level: l10n.lowRisk,
                  levelColor: const Color(0xFFB8E6B8),
                  description: l10n.withinNormalRange,
                ),
                const SizedBox(height: 12),
                _buildRiskFactorCard(
                  context,
                  icon: Icons.science,
                  factor: l10n.gestationalDiabetes,
                  level: l10n.lowRisk,
                  levelColor: const Color(0xFFB8E6B8),
                  description: l10n.glucoseLevelsNormal,
                ),
                const SizedBox(height: 12),
                _buildRiskFactorCard(
                  context,
                  icon: Icons.water_drop,
                  factor: l10n.preeclampsia,
                  level: l10n.lowRisk,
                  levelColor: const Color(0xFFB8E6B8),
                  description: l10n.noProteinInUrine,
                ),

                const SizedBox(height: 20),

                // Warning Signs
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment. centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors. black.withValues(alpha: 0.12),
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

  Widget _buildOverallRiskCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)! ;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: AppColors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n. overallRiskLevel,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.lowRisk,
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.allIndicatorsNormal,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: Colors.white. withValues(alpha: 0.9),
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
    required String level,
    required Color levelColor,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius. circular(16),
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
              color: levelColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              level,
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 11,
                color: const Color(0xFF2D5F2D),
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
            color: AppColors. white,
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
              const Icon(Icons.warning_amber, color: Color(0xFF856404), size: 24),
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
              color: AppColors. white,
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
                    l10n. call911OrProvider,
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