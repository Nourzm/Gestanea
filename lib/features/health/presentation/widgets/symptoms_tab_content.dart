import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'dialogs/add_symptom_dialog.dart';

class SymptomsTabContent extends StatelessWidget {
  const SymptomsTabContent({super.key});

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
                // Recent Symptoms
                Text(
                  'Recent Symptoms',
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Symptom Cards - realistic for week 24
                _buildSymptomCard(
                  icon: Icons.airline_seat_flat,
                  symptom: 'Back Pain',
                  severity: 'Mild',
                  severityColor: const Color(0xFFFFF3CD),
                  time: '3 hours ago',
                ),
                const SizedBox(height: 12),
                _buildSymptomCard(
                  icon: Icons.nights_stay,
                  symptom: 'Trouble Sleeping',
                  severity: 'Moderate',
                  severityColor: const Color(0xFFFFE0B2),
                  time: 'Today, 2:00 AM',
                ),
                const SizedBox(height: 12),
                _buildSymptomCard(
                  icon: Icons.water_drop,
                  symptom: 'Swollen Feet',
                  severity: 'Mild',
                  severityColor: const Color(0xFFFFF3CD),
                  time: 'Yesterday',
                ),
                const SizedBox(height: 12),
                _buildSymptomCard(
                  icon: Icons.food_bank,
                  symptom: 'Heartburn',
                  severity: 'Mild',
                  severityColor: const Color(0xFFFFF3CD),
                  time: '2 days ago',
                ),

const SizedBox(height: 20),

// Add Symptom Button
_buildAddSymptomButton(context),

const SizedBox(height: 20),

                // Symptom Frequency Chart - updated for week 24
                _buildFrequencyChart(),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(
                  'Common symptoms at 24 weeks include back pain, swelling, and sleep difficulties. Stay hydrated and rest when possible.',
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

  Widget _buildSymptomCard({
    required IconData icon,
    required String symptom,
    required String severity,
    required Color severityColor,
    required String time,
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
                  symptom,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
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
              color: severityColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              severity,
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 11,
                color: const Color(0xFF856404),
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildAddSymptomButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddSymptomDialog(),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.pink600, AppColors.pink500],
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, color: AppColors. white, size: 24),
          const SizedBox(width: 8),
          Text(
            'Log New Symptom',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildFrequencyChart() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Symptom Frequency (Last 7 Days)',
            style: AppTextStyles.subtitle1.copyWith(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildFrequencyBar('Back Pain', 0.85),
          const SizedBox(height: 10),
          _buildFrequencyBar('Swollen Feet', 0.6),
          const SizedBox(height: 10),
          _buildFrequencyBar('Heartburn', 0.5),
          const SizedBox(height: 10),
          _buildFrequencyBar('Sleep Issues', 0.7),
        ],
      ),
    );
  }

  Widget _buildFrequencyBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 12,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '${(value * 7).toInt()} times',
              style: AppTextStyles.smallLabel.copyWith(
                fontSize: 11,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.main300,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.main500),
            ),
          ),
        ),
      ],
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