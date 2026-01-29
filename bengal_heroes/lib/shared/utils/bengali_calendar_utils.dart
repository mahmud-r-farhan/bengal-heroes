import '../models/bengali_date_model.dart';

/// Bengali Calendar Utility
/// Converts Gregorian dates to Bengali (Bangla) dates
/// Using the standard Bengali calendar algorithm

class BengaliCalendarUtils {
  // Bengali month names in English
  static const List<String> bengaliMonthsEnglish = [
    'বৈশাখ',
    'জ্যৈষ্ঠ',
    'আষাঢ়',
    'শ্রাবণ',
    'ভাদ্র',
    'আশ্বিন',
    'কার্তিক',
    'অগ্রহায়ণ',
    'পৌষ',
    'মাঘ',
    'ফাল্গুন',
    'চৈত্র',
  ];

  // Bengali month names in Bengali script
  static const List<String> bengaliMonthsBengali = [
    'বৈশাখ',
    'জ্যৈষ্ঠ',
    'আষাঢ়',
    'শ্রাবণ',
    'ভাদ্র',
    'আশ্বিন',
    'কার্তিক',
    'অগ্রহায়ণ',
    'পৌষ',
    'মাঘ',
    'ফাল্গুন',
    'চৈত্র',
  ];

  // Bengali day names in English
  static const List<String> bengaliDaysEnglish = [
    'সোমবার',     // Monday
    'মঙ্গলবার',   // Tuesday
    'বুধবার',     // Wednesday
    'বৃহস্পতিবার', // Thursday
    'শুক্রবার',   // Friday
    'শনিবার',     // Saturday
    'রবিবার',     // Sunday
  ];

  // Bengali day names in Bengali script
  static const List<String> bengaliDaysBengali = [
    'সোমবার',     // Monday
    'মঙ্গলবার',   // Tuesday
    'বুধবার',     // Wednesday
    'বৃহস্পতিবার', // Thursday
    'শুক্রবার',   // Friday
    'শনিবার',     // Saturday
    'রবিবার',     // Sunday
  ];

  // Days in each Bengali month
  static const List<int> bengaliMonthDays = [
    31, // Boishakh
    31, // Jyoishtho
    31, // Ashar
    31, // Shraban
    31, // Bhadro
    30, // Ashwin
    30, // Kartik
    30, // Agrohayon
    30, // Poush
    30, // Magh
    30, // Phalgun
    30, // Choitro
  ];

  /// Get current Bengali date
  static BengaliDate now() {
    return fromGregorian(DateTime.now());
  }

  /// Convert Gregorian date to Bengali date
  /// Algorithm: Bengali year = Gregorian year - 593 (after April 14) or - 594 (before)
  /// Bengali year starts on Boishakh 1 (April 14 in Gregorian calendar)
  static BengaliDate fromGregorian(DateTime gregorianDate) {
    final year = gregorianDate.year;
    final month = gregorianDate.month;
    final day = gregorianDate.day;

    // Calculate Bengali year
    int bengaliYear;
    if (month > 4 || (month == 4 && day >= 14)) {
      // After April 14: subtract 593
      bengaliYear = year - 593;
    } else {
      // Before April 14: subtract 594
      bengaliYear = year - 594;
    }

    // Calculate day of year from April 14
    int dayOfYear = _getDayOfYearFromApril14(year, month, day);

    // Determine Bengali month and day
    int bengaliMonth = 0;
    int bengaliDay = 0;

    int remainingDays = dayOfYear;
    for (int i = 0; i < bengaliMonthDays.length; i++) {
      if (remainingDays <= bengaliMonthDays[i]) {
        bengaliMonth = i + 1; // 1-indexed
        bengaliDay = remainingDays;
        break;
      }
      remainingDays -= bengaliMonthDays[i];
    }

    // Get day name (weekday: 1=Monday, 7=Sunday in Dart)
    int weekday = gregorianDate.weekday;
    String dayName = bengaliDaysEnglish[weekday - 1];

    // Get month name
    String monthName = bengaliMonthsEnglish[bengaliMonth - 1];

    return BengaliDate(
      bengaliDayInt: bengaliDay,
      bengaliMonth: bengaliMonth,
      bengaliYear: bengaliYear,
      dayName: dayName,
      monthName: monthName,
      gregorianDate: gregorianDate,
    );
  }

  /// Calculate the day of year starting from April 14
  static int _getDayOfYearFromApril14(int year, int month, int day) {
    final daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // Check for leap year
    if (_isLeapYear(year)) {
      daysInMonths[1] = 29;
    }

    int dayOfYear = 0;

    if (month > 4 || (month == 4 && day >= 14)) {
      // Same year, after April 14
      // Days remaining in April from 14 onwards
      dayOfYear += (daysInMonths[3] - 14 + 1);

      // Full months between May and the given month
      for (int i = 4; i < month - 1; i++) {
        dayOfYear += daysInMonths[i];
      }

      // Days in the given month
      dayOfYear += day;
    } else {
      // Before April 14, calculate from previous year's April 14
      year--;
      if (_isLeapYear(year)) {
        daysInMonths[1] = 29;
      } else {
        daysInMonths[1] = 28;
      }

      // Days remaining in April of previous year from 14 onwards
      dayOfYear += (daysInMonths[3] - 14 + 1);

      // All months from May to December
      for (int i = 4; i < 12; i++) {
        dayOfYear += daysInMonths[i];
      }

      // Months from January to the given month in current year
      for (int i = 0; i < month - 1; i++) {
        dayOfYear += daysInMonths[i];
      }

      // Days in the given month
      dayOfYear += day;
    }

    return dayOfYear;
  }

  /// Check if a year is a leap year
  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Convert English numerals to Bengali numerals
  static String englishToBengali(String englishNumber) {
    const bengaliNumerals = [
      '০',
      '১',
      '২',
      '৩',
      '৪',
      '৫',
      '৬',
      '৭',
      '৮',
      '৯'
    ];
    String result = '';
    for (int i = 0; i < englishNumber.length; i++) {
      int digit = int.parse(englishNumber[i]);
      result += bengaliNumerals[digit];
    }
    return result;
  }
}
