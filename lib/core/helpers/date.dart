import 'package:intl/intl.dart';

class WayaDateHelper {
  WayaDateHelper._();

  static bool isLeapYear(int year) {
    return year % 4 == 0 && year % 100 != 0;
  }

  static (DateTime, DateTime) getCurrentWeekBounds([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    final firstDay = now.subtract(Duration(days: now.weekday - DateTime.monday));
    final lastDay = firstDay.add(const Duration(days: 6));
    return (DateTime(firstDay.year, firstDay.month, firstDay.day), DateTime(lastDay.year, lastDay.month, lastDay.day));
  }

  static (DateTime, DateTime) getCurrentMonthBounds([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month, getNumberOfDaysInMonth(now.month, now.year));
    return (firstDay, lastDay);
  }

  static (DateTime, DateTime) getCurrentYearBounds([DateTime? reference]) {
    final now = reference ?? DateTime.now();
    final firstDay = DateTime(now.year, 1, 1);
    final lastDay = DateTime(now.year, 12, 31);
    return (firstDay, lastDay);
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

  static String getDailyTimestamp(DateTime timestamp, [bool alternateFormat = false]) {
    return DateFormat(alternateFormat ? "yyyy-MM-dd" : "dd MMM, yyyy").format(timestamp.toLocal());
  }

  static String getEffectiveTimestamp(DateTime timestamp) {
    return DateFormat("MMM dd, hh:mm a").format(timestamp.toLocal());
  }

  static String getMonthlyTimestamp(DateTime timestamp) {
    return DateFormat("MMMM yyyy").format(timestamp.toLocal());
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

  static String _longFormatDuration(Duration duration) {
    final hh = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '${duration.inHours == 0 ? '' : '$hh hours '}$mm minutes $ss seconds';
  }

  static String _shortFormatDuration(Duration duration) {
    final hh = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '${duration.inHours == 0 ? '' : '${hh}h '}${mm}m ${ss}s';
  }

  static String convertDurationToCountdown(Duration duration, [bool longFormat = false]) =>
      longFormat ? _longFormatDuration(duration) : _shortFormatDuration(duration);

  static String getSocialTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final gap = now.difference(timestamp);

    //? If this is less than a minute ago.
    if (gap.inSeconds.abs() < 60) {
      return "${gap.inSeconds.abs()}s ago";
    }

    //? If this is less than an hour ago...
    if (gap.inMinutes < 60) {
      return "${gap.inMinutes.abs()}m ago";
    }

    //? If this is less than a day ago....
    if (gap.inHours < 24) {
      return "${gap.inHours.abs()}h ago";
    }

    //? If this is today.
    if (gap.inDays.abs() == 0) {
      return getTimestamp(timestamp);
    }

    //? The time in days.
    final days = gap.inDays.abs();

    //? If this is yesterday...
    if (days < 2) {
      return "Yesterday";
    }

    //? If gap is
    if (days < 31) {
      return "${days}d ago";
    }

    //? Then just return the timestamp.
    return DateFormat("dd.MM.yyyy").format(timestamp);
  }

  static String getSocialTimestamp(DateTime timestamp, [bool extraPrecise = true]) {
    final now = DateTime.now();
    final gap = now.difference(timestamp);

    //? If this is less than a minute ago.
    if (gap.inSeconds.abs() < 60) {
      return "${gap.inSeconds.abs()}s";
    }

    //? If this is less than an hour ago...
    if (gap.inMinutes < 60) {
      return "${gap.inMinutes.abs()}m";
    }

    //? If this is less than a day ago....
    if (gap.inHours < 24) {
      return "${gap.inHours.abs()}h";
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
    if (!extraPrecise || gap.inDays.abs() < 10) {
      return "${gap.inDays.abs()} days ago, ${getTimestamp(timestamp)}";
    }

    //? Then just return the timestamp.
    return getFullTimestamp(timestamp);
  }

  static String getSocialDate(DateTime timestamp, [bool extraPrecise = true]) {
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
    if (!extraPrecise || gap.inDays.abs() < 10) {
      return "${gap.inDays.abs()} days ago";
    }

    //? Then just return the timestamp.
    return getFullTimestamp(timestamp);
  }
}
