import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'neumorphic_section.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.paymentMethod,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          PaymentOption(
            label: AppLocalizations.of(context)!.cashOnDelivery,
            value: 'cash',
            selectedValue: selectedPaymentMethod,
            onTap: () => onPaymentMethodChanged('cash'),
          ),
          const SizedBox(height: 12),
          PaymentOption(
            label: AppLocalizations.of(context)!.creditDebitCard,
            value: 'card',
            selectedValue: selectedPaymentMethod,
            onTap: () => onPaymentMethodChanged('card'),
          ),
          const SizedBox(height: 12),
          PaymentOption(
            label: AppLocalizations.of(context)!.digitalWallet,
            value: 'wallet',
            selectedValue: selectedPaymentMethod,
            onTap: () => onPaymentMethodChanged('wallet'),
          ),
        ],
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.main500
              : AppColors.bg_1.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.main500 : const Color(0xFFD0C0E0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFFD0C0E0),
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
