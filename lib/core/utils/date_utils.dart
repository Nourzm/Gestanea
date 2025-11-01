class AppDateUtils {
  // Get current date time
  static DateTime now() {
    return DateTime.now();
  }

  // Get today's date at midnight
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  // Check if date is in the same week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  // Check if date is in the same month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Check if date is in the same year
  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  // Get difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  // Get difference in weeks between two dates
  static int weeksBetween(DateTime from, DateTime to) {
    return daysBetween(from, to) ~/ 7;
  }

  // Get difference in months between two dates
  static int monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  // Add days to a date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  // Add months to a date
  static DateTime addMonths(DateTime date, int months) {
    int newMonth = date.month + months;
    int newYear = date.year;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }

    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    int newDay = date.day;
    int daysInNewMonth = getDaysInMonth(newYear, newMonth);
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }

    return DateTime(newYear, newMonth, newDay, date.hour, date.minute, date.second);
  }

  // Add years to a date
  static DateTime addYears(DateTime date, int years) {
    return DateTime(date.year + years, date.month, date.day, date.hour, date.minute, date.second);
  }

  // Get number of days in a month
  static int getDaysInMonth(int year, int month) {
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }

  // Check if year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6));
  }

  // Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month, getDaysInMonth(date.year, date.month), 23, 59, 59, 999);
  }

  // Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  // Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  // Calculate pregnancy week and day from conception/LMP date
  static Map<String, int> calculatePregnancyWeek(DateTime startDate) {
    final now = DateTime.now();
    final days = daysBetween(startDate, now);
    final weeks = days ~/ 7;
    final remainingDays = days % 7;
    
    return {
      'weeks': weeks,
      'days': remainingDays,
      'totalDays': days,
    };
  }

  // Calculate due date (40 weeks from LMP)
  static DateTime calculateDueDate(DateTime lmpDate) {
    return addDays(lmpDate, 280); // 40 weeks = 280 days
  }

  // Calculate baby's age in days from birth date
  static int calculateBabyAgeDays(DateTime birthDate) {
    return daysBetween(birthDate, DateTime.now());
  }

  // Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Parse date string safely
  static DateTime? tryParse(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get age from birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
