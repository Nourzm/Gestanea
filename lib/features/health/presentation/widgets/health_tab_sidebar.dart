import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class HealthTabSidebar extends StatelessWidget {
  final List<Map<String, dynamic>> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const HealthTabSidebar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  String _getLocalizedLabel(BuildContext context, String labelKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (labelKey) {
      case 'vitals':
        return localizations.vitals;
      case 'symptoms':
        return localizations.symptoms;
      case 'labResults':
        return localizations.labResults.replaceAll(' ', '\n');
      case 'riskAlerts':
        return localizations.riskAlerts.replaceAll(' ', '\n');
      case 'mood':
        return localizations.mood;
      default:
        return labelKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 247, 240, 254), // Slightly whiter purple
 // Whiter purple - same as header
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          tabs.length,
          (index) {
            final tab = tabs[index];
            final isSelected = selectedIndex == index;
            return _buildTabItem(
              context: context,
              icon: tab['icon'],
              labelKey: tab['labelKey'],
              isSelected: isSelected,
              onTap: () => onTabSelected(index),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required IconData icon,
    required String labelKey,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.main500 : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.main500,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getLocalizedLabel(context, labelKey),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.main500 : AppColors.textDark,
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}