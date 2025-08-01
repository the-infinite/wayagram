import 'package:intl/intl.dart';

/// Extension for string-based date formatting
///
/// Usage examples:
/// ```dart
/// final formatted1 = "2023-12-25".formatDt();     // "25th Dec 2023"
/// final formatted2 = "2023-12-25T10:30:00".formatDt1(); // "25th December, 2023"
/// final formatted3 = "2023-12-25T10:30:00".formatDt2(); // "Dec 25th, 2023"
/// final amount = "1234.56".formatAm();             // "1,234.56"
/// ```
extension StringDateFormattingExtension on String {
  /// Format date string (YYYY-MM-DD) to "DDth MMM YYYY" format
  /// Example: "2023-12-25" -> "25th Dec 2023"
  String formatDt() {
    if (isEmpty) return '';

    if (contains('-')) {
      final parts = split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '${day._getDayAbbreviation()} ${month._getMonthNameMini()} $year';
      }
    }
    return this;
  }

  /// Format date string to "DDth of Month, YYYY" format
  /// Example: "2023-12-25T10:30:00" -> "25th of December, 2023"
  String formatDate() {
    if (isEmpty) return '';

    try {
      // Handle both ISO format and simple date format
      String dateString = this;
      if (contains('T')) {
        dateString = split('T')[0];
      }

      if (!dateString.contains('-')) {
        return this; // Return original if not a valid date format
      }

      final parts = dateString.split('-');
      if (parts.length != 3) return this;

      final monthNum = parts[1];
      final year = parts[0];

      // Get ordinal suffix using existing helper
      final dayWithSuffix = parts[2]._getDayAbbreviation();

      // Get full month name (without comma) using existing helper
      final monthName = monthNum._getMonthName().replaceAll(',', '');

      return '$dayWithSuffix of $monthName, $year';
    } catch (e) {
      return this; // Return original string if parsing fails
    }
  }

  /// Format ISO date string to "DDth Month, YYYY" format
  /// Example: "2023-12-25T10:30:00" -> "25th December, 2023"
  String formatDt1() {
    if (isEmpty) return '';

    String dateString = this;
    if (contains('T')) {
      dateString = split('T')[0];
    }

    if (dateString.contains('-')) {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '${day._getDayAbbreviation()} ${month._getMonthName()} $year';
      }
    }
    return this;
  }

  /// Format ISO date string to "MMM DDth, YYYY" format
  /// Example: "2023-12-25T10:30:00" -> "Dec 25th, 2023"
  String formatDt2() {
    if (isEmpty) return '';

    String dateString = this;
    if (contains('T')) {
      dateString = split('T')[0];
    }

    if (dateString.contains('-')) {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '${month._getMonthNameMini()} ${day._getDayAbbreviation()}, $year';
      }
    }
    return this;
  }

  /// Format donation date string to "DDth Month\nYYYY" format (with newline)
  /// Example: "2023-12-25T10:30:00" -> "25th December,\n2023"
  String formatDonationDate() {
    if (isEmpty) return '';

    try {
      // Handle both ISO format and simple date format
      String dateString = this;
      if (contains('T')) {
        dateString = split('T')[0];
      }

      if (!dateString.contains('-')) {
        return this; // Return original if not a valid date format
      }

      final parts = dateString.split('-');
      if (parts.length != 3) return this;

      final year = parts[0];
      final monthNum = parts[1];
      final dayNum = parts[2];

      // Get ordinal suffix and month name using existing helpers
      final dayWithSuffix = dayNum._getDayAbbreviation();
      final monthName = monthNum._getMonthName(); // Already includes comma

      return '$dayWithSuffix $monthName\n$year';
    } catch (e) {
      return this; // Return original string if parsing fails
    }
  }

  /// Format amount string with proper comma separators
  /// Example: "1234.56" -> "1,234.56"
  String formatAm() {
    if (isEmpty || this == '0') return this;

    String cleaned = replaceAll(' ', '').replaceAll(',', '');
    if (cleaned.isEmpty) return this;

    try {
      // Use NumberFormat for better performance and consistency
      if (cleaned.contains('.')) {
        final double value = double.parse(cleaned);
        return NumberFormat('#,##0.00').format(value);
      } else {
        final int value = int.parse(cleaned);
        return NumberFormat('#,###').format(value);
      }
    } catch (e) {
      return this;
    }
  }

  // Private helper methods
  String _getDayAbbreviation() {
    return switch (this) {
      '01' || '1' => '1st',
      '02' || '2' => '2nd',
      '03' || '3' => '3rd',
      '21' => '21st',
      '22' => '22nd',
      '23' => '23rd',
      '31' => '31st',
      _ => '${this}th',
    };
  }

  String _getMonthName() {
    return switch (this) {
      '01' || '1' => 'January,',
      '02' || '2' => 'February,',
      '03' || '3' => 'March,',
      '04' || '4' => 'April,',
      '05' || '5' => 'May,',
      '06' || '6' => 'June,',
      '07' || '7' => 'July,',
      '08' || '8' => 'August,',
      '09' || '9' => 'September,',
      '10' => 'October,',
      '11' => 'November,',
      '12' => 'December,',
      _ => '',
    };
  }

  String _getMonthNameMini() {
    return switch (this) {
      '01' || '1' => 'Jan',
      '02' || '2' => 'Feb',
      '03' || '3' => 'Mar',
      '04' || '4' => 'Apr',
      '05' || '5' => 'May',
      '06' || '6' => 'Jun',
      '07' || '7' => 'Jul',
      '08' || '8' => 'Aug',
      '09' || '9' => 'Sep',
      '10' => 'Oct',
      '11' => 'Nov',
      '12' => 'Dec',
      _ => '',
    };
  }
}
