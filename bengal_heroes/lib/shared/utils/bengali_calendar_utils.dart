/// Bengali Calendar Utility
/// Converts Gregorian dates to Bengali (Bangla) dates
/// Based on the Bengali calendar (Bangla Saal) used in West Bengal and Bangladesh

class BengaliDate {
  final int year; // Bengali year
  final int month; // Bengali month (1-12)
  final int day; // Bengali day (1-30/31)
  final String monthName;
  final String dayName;
  final String bengaliYear;
  final String bengaliMonth;
  final String bengaliDay;

  BengaliDate({
    required this.year,
    required this.month,
    required this.day,
    required this.monthName,
    required this.dayName,
    required this.bengaliYear,
    required this.bengaliMonth,
    required this.bengaliDay,
  });

  @override
  String toString() =>
      '$bengaliDay $monthName $bengaliYear ($dayName)';
}

class BengaliCalendarUtils {
  static const List<String> bengaliMonths = [
    'Boishakh',
    'Jyoishtho',
    'Ashar',
    'Shraban',
    'Bhadro',
    'Ashwin',
    'Kartik',
    'Agrohayon',
    'Poush',
    'Magh',
    'Phalgun',
    'Choitro',
  ];

  static const List<String> bengaliMonthsBangla = [
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

  static const List<String> bengaliDays = [
    'Shombar',
    'Shunibor',
    'Robibar',
    'Sombar',
    'Budhbar',
    'Brihospatibor',
    'Shukrobor',
  ];

  static const List<String> bengaliDaysBangla = [
    'সোমবার',
    'শনিবার',
    'রবিবার',
    'সোমবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
  ];

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

  /// Convert English (Gregorian) date to Bengali date
  static BengaliDate fromGregorian(DateTime gregorianDate) {
    // The Bengali year starts on April 14 (Gregorian)
    // Bengali year 1 = Gregorian 1582
    // Reference: April 14, 1582 = 1 Boishakh 1

    int year = gregorianDate.year;
    int month = gregorianDate.month;
    int day = gregorianDate.day;

    // Calculate Bengali year
    int bengaliYear;
    if (month >= 4 && day >= 14) {
      bengaliYear = year - 1582 + 1;
    } else {
      bengaliYear = year - 1582;
    }

    // If before April 14, we're in the previous Bengali year
    if (month < 4 || (month == 4 && day < 14)) {
      bengaliYear--;
    }

    // Calculate Bengali month and day
    int bengaliMonth = 0;
    int bengaliDay = 0;

    // Days from April 14 to the given date
    int daysFromYearStart = _getDaysFromBoishakh14(year, month, day);

    // Calculate month and day in Bengali calendar
    int remainingDays = daysFromYearStart;
    for (int i = 0; i < bengaliMonthDays.length; i++) {
      if (remainingDays <= bengaliMonthDays[i]) {
        bengaliMonth = i;
        bengaliDay = remainingDays;
        break;
      }
      remainingDays -= bengaliMonthDays[i];
    }

    // Ensure month and day are 1-indexed
    if (bengaliDay == 0) {
      bengaliMonth--;
      bengaliDay = bengaliMonthDays[bengaliMonth];
    }

    bengaliMonth++; // Convert to 1-indexed

    String monthName = bengaliMonths[bengaliMonth - 1];
    String monthNameBangla = bengaliMonthsBangla[bengaliMonth - 1];
    int weekday = gregorianDate.weekday;
    String dayName = bengaliDays[weekday - 1];
    String dayNameBangla = bengaliDaysBangla[weekday - 1];
    String bengaliYearStr = _convertTobengaliNumerals(bengaliYear.toString());
    String bengaliMonthStr = _convertTobengaliNumerals(bengaliMonth.toString());
    String bengaliDayStr = _convertTobengaliNumerals(bengaliDay.toString());

    return BengaliDate(
      year: bengaliYear,
      month: bengaliMonth,
      day: bengaliDay,
      monthName: monthName,
      dayName: dayName,
      bengaliYear: bengaliYearStr,
      bengaliMonth: bengaliMonthStr,
      bengaliDay: bengaliDayStr,
    );
  }

  /// Get current Bengali date
  static BengaliDate now() {
    return fromGregorian(DateTime.now());
  }

  /// Get Bengali date string in Bangla
  static String getBengaliDateStringBangla(DateTime date) {
    final bengaliDate = fromGregorian(date);
    return '${bengaliDate.bengaliDay} ${bengaliMonthsBangla[bengaliDate.month - 1]} ${bengaliDate.bengaliYear}';
  }

  /// Get Bengali date string in English
  static String getBengaliDateString(DateTime date) {
    final bengaliDate = fromGregorian(date);
    return '${bengaliDate.day} ${bengaliDate.monthName} ${bengaliDate.year}';
  }

  /// Calculate days from April 14 of the given year to the given date
  static int _getDaysFromBoishakh14(int year, int month, int day) {
    if (month < 4 || (month == 4 && day < 14)) {
      // Before April 14, calculate from previous year's April 14
      year--;
    }

    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // Check for leap year
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
      daysInMonth[1] = 29;
    }

    int totalDays = 0;

    // If same year, calculate from April 14 to the date
    if (month >= 4) {
      // Days remaining in April (from 14 to 30)
      totalDays += daysInMonth[3] - 14 + 1;

      // Add days from May to the month before given month
      for (int i = 4; i < month - 1; i++) {
        totalDays += daysInMonth[i];
      }

      // Add days in the given month
      totalDays += day;
    } else {
      // Same year but month is before April - shouldn't happen in our calculation
      totalDays = day;
    }

    return totalDays;
  }

  /// Convert English numerals to Bengali numerals
  static String _convertTobengaliNumerals(String englishNumber) {
    const bengaliNumerals = [
      '০', '১', '২', '৩', '४', '५', '६', '७', '८', '९'
    ];
    String result = '';
    for (int i = 0; i < englishNumber.length; i++) {
      int digit = int.parse(englishNumber[i]);
      result += bengaliNumerals[digit];
    }
    return result;
  }
}
