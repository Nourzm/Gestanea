import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/core/constants/app_text_styles.dart';
import 'package:pregnancy_baby_app/core/widgets/custom_button.dart';

class AppDialog {
  /// Show a simple information dialog
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.headline2),
          content: Text(message, style: AppTextStyles.body1),
          actions: [
            CustomButton(
              text: buttonText ?? 'OK',
              onPressed: () {
                Navigator.of(context).pop();
                onPressed?.call();
              },
              type: ButtonType.primary,
            ),
          ],
        );
      },
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.headline2),
          content: Text(message, style: AppTextStyles.body1),
          actions: [
            CustomButton(
              text: cancelText ?? 'Cancel',
              onPressed: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
              type: ButtonType.text,
            ),
            const SizedBox(width: 8),
            CustomButton(
              text: confirmText ?? 'Confirm',
              onPressed: () {
                Navigator.of(context).pop(true);
                onConfirm?.call();
              },
              type: ButtonType.primary,
            ),
          ],
        );
      },
    );
  }

  /// Show an error dialog
  static Future<void> showError({
    required BuildContext context,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? 'Error',
            style: AppTextStyles.headline2.copyWith(color: Colors.red),
          ),
          content: Text(message, style: AppTextStyles.body1),
          actions: [
            CustomButton(
              text: buttonText ?? 'OK',
              onPressed: () {
                Navigator.of(context).pop();
                onPressed?.call();
              },
              type: ButtonType.primary,
              backgroundColor: Colors.red,
            ),
          ],
        );
      },
    );
  }

  /// Show a success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? 'Success',
            style: AppTextStyles.headline2.copyWith(color: Colors.green),
          ),
          content: Text(message, style: AppTextStyles.body1),
          actions: [
            CustomButton(
              text: buttonText ?? 'OK',
              onPressed: () {
                Navigator.of(context).pop();
                onPressed?.call();
              },
              type: ButtonType.primary,
              backgroundColor: Colors.green,
            ),
          ],
        );
      },
    );
  }

  /// Show a loading dialog
  static void showLoading({
    required BuildContext context,
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.main600),
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(message, style: AppTextStyles.body1),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show a custom dialog
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        );
      },
    );
  }

  /// Show a bottom sheet dialog
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  /// Show a date picker dialog
  static Future<DateTime?> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDatePickerDialog(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );
  }

  /// Show a time picker dialog
  static Future<TimeOfDay?> showTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) async {
    return await showTimePickerDialog(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
  }

  /// Show a list selection dialog
  static Future<T?> showListSelection<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    T? selectedItem,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.headline2),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedItem;
                return ListTile(
                  title: Text(
                    itemBuilder(item),
                    style: AppTextStyles.body1.copyWith(
                      color: isSelected ? AppColors.main600 : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.main600)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(item);
                  },
                );
              },
            ),
          ),
          actions: [
            CustomButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }
}

// Helper function for date picker
Future<DateTime?> showDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.main600,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      );
    },
  );
}

// Helper function for time picker
Future<TimeOfDay?> showTimePickerDialog({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  return await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.main600,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      );
    },
  );
}
