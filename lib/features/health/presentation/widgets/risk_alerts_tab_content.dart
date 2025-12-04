import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'dialogs/alert_details_dialog.dart';

class RiskAlertsTabContent extends StatelessWidget {
  const RiskAlertsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                _buildOverallRiskCard(),

                const SizedBox(height: 20),

                // Risk Factors
                Text(
                  'Risk Factors to Monitor',
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                _buildRiskFactorCard(
                  icon: Icons.favorite,
                  factor: 'Blood Pressure',
                  level: 'Low Risk',
                  levelColor: const Color(0xFFB8E6B8),
                  description: 'Within normal range',
                ),
                const SizedBox(height: 12),
                _buildRiskFactorCard(
                  icon: Icons.science,
                  factor: 'Gestational Diabetes',
                  level: 'Low Risk',
                  levelColor: const Color(0xFFB8E6B8),
                  description: 'Glucose levels normal',
                ),
                const SizedBox(height: 12),
                _buildRiskFactorCard(
                  icon: Icons.water_drop,
                  factor: 'Preeclampsia',
                  level: 'Low Risk',
                  levelColor: const Color(0xFFB8E6B8),
                  description: 'No protein in urine',
                ),

                const SizedBox(height: 20),

                // Warning Signs
                _buildWarningSignsCard(),

                const SizedBox(height: 16),

                // Emergency Contact
                _buildEmergencyContactCard(),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(
                  'If you experience any warning signs, contact your healthcare provider immediately.',
                ),
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

  Widget _buildOverallRiskCard() {
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
                  'Overall Risk Level',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Low Risk',
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All indicators within normal range',
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

  Widget _buildRiskFactorCard({
    required IconData icon,
    required String factor,
    required String level,
    required Color levelColor,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        showAlertDetailsDialog(
          context,
          title: factor,
          icon: icon,
          severity: level.replaceAll(' Risk', ''),
          description: description,
          recommendedActions: [
            'Continue monitoring regularly',
            'Maintain a healthy lifestyle',
            'Keep attending prenatal appointments',
            'Report any unusual changes to your doctor',
          ],
        );
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildWarningSignsCard() {
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
              const Icon(Icons.warning_amber, color: Color(0xFF856404), size: 24),
              const SizedBox(width: 8),
              Text(
                'Warning Signs to Watch',
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF856404),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWarningSignItem('Severe headache'),
          _buildWarningSignItem('Blurred vision'),
          _buildWarningSignItem('Severe abdominal pain'),
          _buildWarningSignItem('Decreased fetal movement'),
          _buildWarningSignItem('Vaginal bleeding'),
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

  Widget _buildEmergencyContactCard() {
    return Container(
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
                  'Emergency Contact',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Call 911 or your provider',
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