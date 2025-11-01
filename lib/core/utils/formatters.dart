import 'package:intl/intl.dart';

class Formatters {
  // Date formatters
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateLong(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatTime24(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Number formatters
  static String formatNumber(num number, {int decimalPlaces = 0}) {
    return NumberFormat('#,##0.${'0' * decimalPlaces}').format(number);
  }

  static String formatCurrency(num amount, {String symbol = '\$'}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(amount);
  }

  static String formatPercentage(num value, {int decimalPlaces = 0}) {
    return '${(value * 100).toStringAsFixed(decimalPlaces)}%';
  }

  static String formatDecimal(num value, {int decimalPlaces = 2}) {
    return value.toStringAsFixed(decimalPlaces);
  }

  // Phone number formatter
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // Format as (XXX) XXX-XXXX for 10-digit numbers
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    
    // For other lengths, just return cleaned number
    return cleaned;
  }

  // File size formatter
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  // Duration formatter
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Relative time formatter (e.g., "2 hours ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Title case
  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word.toLowerCase())).join(' ');
  }

  // Truncate text with ellipsis
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$suffix';
  }

  // Remove HTML tags
  static String stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Format pregnancy week (e.g., "Week 24" or "Week 24, Day 3")
  static String formatPregnancyWeek(int weeks, {int? days}) {
    if (days != null && days > 0) {
      return 'Week $weeks, Day $days';
    }
    return 'Week $weeks';
  }

  // Format baby age (e.g., "3 months, 2 weeks")
  static String formatBabyAge(int days) {
    if (days < 7) {
      return '$days ${days == 1 ? 'day' : 'days'}';
    } else if (days < 30) {
      final weeks = days ~/ 7;
      final remainingDays = days % 7;
      if (remainingDays > 0) {
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'}, $remainingDays ${remainingDays == 1 ? 'day' : 'days'}';
      }
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (days < 365) {
      final months = days ~/ 30;
      final remainingWeeks = (days % 30) ~/ 7;
      if (remainingWeeks > 0) {
        return '$months ${months == 1 ? 'month' : 'months'}, $remainingWeeks ${remainingWeeks == 1 ? 'week' : 'weeks'}';
      }
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = days ~/ 365;
      final remainingMonths = (days % 365) ~/ 30;
      if (remainingMonths > 0) {
        return '$years ${years == 1 ? 'year' : 'years'}, $remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}';
      }
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
  }
}
