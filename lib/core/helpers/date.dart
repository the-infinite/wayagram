import 'package:intl/intl.dart';

class WayaDateHelper {
  WayaDateHelper._();

  static bool isLeapYear(int year) {
    return year % 4 == 0 && year % 100 != 0;
  }

  static bool isSameDay(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month && first.day == second.day;
  }

  static DateTime pureDate(DateTime timestamp) {
    return DateTime(timestamp.year, timestamp.month, timestamp.day);
  }

  static int getNumberOfDaysInMonth(int month, int year) {
    return switch (month) {
      DateTime.february => isLeapYear(year) ? 29 : 28,
      DateTime.september || DateTime.april || DateTime.june || DateTime.november => 30,
      _ => 31,
    };
  }

  static String getFullTimestamp(DateTime timestamp) {
    return DateFormat("dd MMM, yyyy 'at' hh:mm a").format(timestamp.toLocal());
  }

  static String getTimestamp(DateTime timestamp) {
    return DateFormat("hh:mm a").format(timestamp.toLocal());
  }

  static String getDailyTimestamp(DateTime timestamp) {
    return DateFormat("dd MMM, yyyy").format(timestamp.toLocal());
  }

  static String getMonthlyTimestamp(DateTime timestamp) {
    return DateFormat("MMM, yyyy").format(timestamp.toLocal());
  }

  static String getYearlyTimestamp(DateTime timestamp) {
    return DateFormat("yyyy").format(timestamp.toLocal());
  }

  static String getWeekday(DateTime timestamp) {
    return DateFormat("EEEE").format(timestamp.toLocal());
  }

  static DateTime parseDate(String timestamp) {
    return DateTime.parse(timestamp).toLocal();
  }

  static DateTime getLocalTime(String time) {
    return DateTime.parse(time).toLocal();
  }

  static String convertDurationToTimestamp(Duration duration) {
    final hh = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '${duration.inHours == 0 ? '' : '$hh:'}$mm:$ss';
  }

  static String getSocialTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final gap = now.difference(timestamp);

    //? If this is less than a minute ago.
    if (gap.inSeconds.abs() < 60) {
      return "${gap.inSeconds.abs()} seconds ago";
    }

    //? If this is less than an hour ago...
    if (gap.inMinutes < 60) {
      return "${gap.inMinutes.abs()} minutes ago";
    }

    //? If this is less than a day ago....
    if (gap.inHours < 24) {
      return "${gap.inHours.abs()} hours ago";
    }

    //? If this is today.
    if (gap.inDays.abs() == 0) {
      return getTimestamp(timestamp);
    }

    //? If this is yesterday...
    if (gap.inDays.abs() < 2) {
      return "Yesterday, ${getTimestamp(timestamp)}";
    }

    //? If this is x days ago.
    if (gap.inDays.abs() < 10) {
      return "${gap.inDays.abs()} days ago, ${getTimestamp(timestamp)}";
    }

    //? Then just return the timestamp.
    return getFullTimestamp(timestamp);
  }

  static String getSocialDate(DateTime timestamp) {
    final now = pureDate(DateTime.now());
    final gap = now.difference(pureDate(timestamp));

    //? If this is yesterday...
    if (gap.inDays.abs() == 0) {
      return "Today";
    }

    //? If this is yesterday...
    if (gap.inDays.abs() == 1) {
      return "Yesterday";
    }

    //? If this is x days ago.
    if (gap.inDays.abs() < 10) {
      return "${gap.inDays.abs()} days ago";
    }

    //? Then just return the timestamp.
    return getFullTimestamp(timestamp);
  }
}
