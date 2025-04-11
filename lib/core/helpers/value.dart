import 'dart:math';
import 'package:intl/intl.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

class WayaValueHelper {
  WayaValueHelper._();

  /// Creates a unique identifier string.
  ///
  /// Returns a randomly generated string that can be used as a unique identifier.
  /// The generated string is suitable for use as IDs in databases, file names,
  /// or any other context where a unique string identifier is needed.
  ///
  /// Returns a [String] containing the generated unique identifier.
  static String createUid() {
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final random = List.generate(16, (index) {
      return (Random().nextDouble() * 16).floor().toRadixString(16);
    }).join();

    // This is fine.
    return '${now.toRadixString(16)}$random';
  }

  /// Formats a number into a human-readable string with K/M/B suffixes.
  ///
  /// Takes a [number] and returns a formatted string representation.
  /// For example:
  /// - 1320 becomes "1.32K"
  /// - 1500000 becomes "1.5M"
  /// - 2700000000 becomes "2.7B"
  ///
  /// Returns a [String] containing the formatted value.
  static String formatNumber(num number, [bool price = false]) {
    //? If this number is less than 1000, just return it.
    if (number < 1000) return number.toString();

    //? Our units..
    final units = ['', 'K', 'M', 'B'];
    final exp = (log(number) / log(1000)).floor();

    //? Divide this by the amount of thousands herein.
    final value = number / pow(1000, exp);

    //? Return a match for our unit.
    return '${price ? '₦' : ''}${value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')}${units[exp]}';
  }

  /// Formats a numerical value into a price string representation.
  ///
  /// Takes a number and formats it with specified decimal digits (defaults to 2).
  ///
  /// Example:
  /// ```dart
  /// Value.formatPrice(1234.5678) // Returns "1,234.57"
  /// Value.formatPrice(1234.5678, 3) // Returns "1,234.568"
  /// ```
  ///
  /// Parameters:
  /// - [number] The numerical value to format
  /// - [decimalDigits] Optional number of decimal places (defaults to 2)
  ///
  /// Returns a formatted string with thousands separators and specified decimal places.
  static String formatPrice(num number, [int decimalDigits = 2]) {
    final format = NumberFormat.currency(decimalDigits: decimalDigits, symbol: "₦");
    return format.format(number);
  }

  /// Returns a human-readable string representation of a [WayaDebugEventModule].
  ///
  /// Takes a [module] enum value and returns its corresponding display name.
  static String getModuleName(WayaDebugEventModule module) {
    return switch (module) {
      WayaDebugEventModule.chats => 'Chats and Socials',
      WayaDebugEventModule.disputes => 'Disputes',
      WayaDebugEventModule.donations => 'Donations',
      WayaDebugEventModule.events => 'Events',
      WayaDebugEventModule.feed => 'Feed',
      WayaDebugEventModule.groups => 'Groups',
      WayaDebugEventModule.moments => "Moments",
      WayaDebugEventModule.notifications => "Notifications",
      WayaDebugEventModule.pages => 'Pages',
      WayaDebugEventModule.polls => 'Polls',
      WayaDebugEventModule.posts => 'Posts',
      WayaDebugEventModule.promotion => 'Promotions',
      WayaDebugEventModule.quotations => 'Get Quotation',
      WayaDebugEventModule.relationships => 'Followers and Following',
      WayaDebugEventModule.shops => 'Shops',
      WayaDebugEventModule.support => 'Support',
      WayaDebugEventModule.ugt => 'University Got Talent',
      WayaDebugEventModule.wallets => 'Wallets',
      WayaDebugEventModule.unknown => 'Unknown',
    };
  }

  /// Returns a human-readable string representation of a [WayaDebugEventType].
  ///
  /// Takes a [type] enum value and returns its corresponding display name.
  static String getEventTypeName(WayaDebugEventType type) {
    return switch (type) {
      WayaDebugEventType.exception => 'Exception',
      WayaDebugEventType.flutter => 'Flutter Error',
      WayaDebugEventType.http => 'HTTP',
      WayaDebugEventType.logical => 'Logical',
      WayaDebugEventType.runtime => 'Runtime',
    };
  }

  /// Returns a shareable URL based on the provided route.
  /// The URL format depends on whether the application is in production mode.
  ///
  /// [route] The route path to be transformed into a shareable URL
  ///
  /// Returns a [String] containing the complete shareable URL
  static String getShareableUrl(String route) => switch (WayaConstants.isProduction) {
        true => "https://wayagram.ng$route",
        false => "https://staging.wayagram.ng$route",
      };

  /// Checks if a given string contains only emoji characters.
  ///
  /// Takes a [String] input and determines if it consists solely of emoji characters.
  /// Returns true if the input is a single emoji or a sequence of emojis,
  /// false otherwise.
  ///
  /// Example:
  /// ```dart
  /// print(isEmoji('😀')); // true
  /// print(isEmoji('Hello')); // false
  /// print(isEmoji('😀😊')); // true
  /// ```
  static bool isEmoji(String text) {
    if (text.isEmpty) return false;
    final emojiRegex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    final matches = emojiRegex.allMatches(text);
    return matches.length == text.runes.length;
  }
}
