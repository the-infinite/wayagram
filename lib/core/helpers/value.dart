import 'dart:math';

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
  static String formatNumber(num number) {
    //? If this number is less than 1000, just return it.
    if (number < 1000) return number.toString();

    //? Our units..
    final units = ['', 'K', 'M', 'B'];
    final exp = (log(number) / log(1000)).floor();

    //? Divide this by the amount of thousands herein.
    final value = number / pow(1000, exp);

    //? Return a match for our unit.
    return '${value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')}${units[exp]}';
  }
}
