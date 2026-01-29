/// Bengali Date Model
/// Represents a date in the Bengali (Bangla) calendar system

class BengaliDate {
  final int bengaliDayInt;
  final int bengaliMonth;
  final int bengaliYear;
  final String dayName;
  final String monthName;
  final DateTime gregorianDate;

  BengaliDate({
    required this.bengaliDayInt,
    required this.bengaliMonth,
    required this.bengaliYear,
    required this.dayName,
    required this.monthName,
    required this.gregorianDate,
  });

  /// Get Bengali day as Bengali numerals (০-९)
  String get bengaliDay => _englishToBengali(bengaliDayInt.toString());

  /// Get Bengali year as Bengali numerals (०-९)
  String get bengaliYearString => _englishToBengali(bengaliYear.toString());

  /// Convert English numerals to Bengali numerals
  String _englishToBengali(String number) {
    const bengaliNumerals = [
      '०',
      '१',
      '२',
      '३',
      '४',
      '५',
      '६',
      '७',
      '८',
      '९'
    ];
    String result = '';
    for (int i = 0; i < number.length; i++) {
      int digit = int.parse(number[i]);
      result += bengaliNumerals[digit];
    }
    return result;
  }

  @override
  String toString() =>
      '$bengaliDay $monthName $bengaliYearString ($dayName)';
}
