import 'package:flutter/material.dart';

// String extensions
extension StringExtensions on String {
  // Check if string is email
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }

  // Check if string is phone number
  bool get isPhoneNumber {
    final cleaned = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^\+?[0-9]{8,15}$').hasMatch(cleaned);
  }

  // Check if string is URL
  bool get isUrl {
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    ).hasMatch(this);
  }

  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  // Title case
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Check if string is empty or whitespace
  bool get isBlank {
    return trim().isEmpty;
  }

  // Check if string is not empty and not whitespace
  bool get isNotBlank {
    return !isBlank;
  }

  // Reverse string
  String get reverse {
    return split('').reversed.join();
  }

  // Check if string is numeric
  bool get isNumeric {
    return num.tryParse(this) != null;
  }

  // Parse to int safely
  int? get toIntOrNull {
    return int.tryParse(this);
  }

  // Parse to double safely
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }

  // Parse to DateTime safely
  DateTime? get toDateTimeOrNull {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }

  // Truncate with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  // Remove HTML tags
  String get stripHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

// DateTime extensions
extension DateTimeExtensions on DateTime {
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  // Add days
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  // Subtract days
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  // Check if same day
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  // Check if same month
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  // Check if same year
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  // Get age from this date to now
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  // Media query shortcuts
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Navigation shortcuts
  NavigatorState get navigator => Navigator.of(this);
  
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
  
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  Future<T?> pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Snackbar shortcut
  void showSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }

  // Show error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Focus shortcuts
  void unfocus() => FocusScope.of(this).unfocus();
  
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);
}

// List extensions
extension ListExtensions<T> on List<T> {
  // Get first element or null
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  // Get last element or null
  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  // Check if list has elements
  bool get hasElements {
    return isNotEmpty;
  }

  // Get element at index or null
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}

// Num extensions
extension NumExtensions on num {
  // Check if number is positive
  bool get isPositive => this > 0;

  // Check if number is negative
  bool get isNegative => this < 0;

  // Check if number is zero
  bool get isZero => this == 0;

  // Clamp value between min and max
  num clampValue(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}
