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
}
