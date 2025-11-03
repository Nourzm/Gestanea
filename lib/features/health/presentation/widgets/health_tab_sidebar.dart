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
        return localizations.labResults.replaceAll(' ', '\n'); // Add line break
      case 'riskAlerts':
        return localizations.riskAlerts.replaceAll(' ', '\n'); // Add line break
      case 'mood':
        return localizations.mood;
      default:
        return labelKey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
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
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(
              color: isSelected ? AppColors.main500 : AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 6,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: 6,
                  offset: Offset(-2, -2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.main500,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getLocalizedLabel(context, labelKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.main500 : AppColors.textSecondary,
              fontSize: 9,
              fontFamily: 'Lato',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}