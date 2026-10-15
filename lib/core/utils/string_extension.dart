extension WayaString on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Validates if the string is a valid image URL
  bool get validImageUrl {
    if (isEmpty) return false;

    try {
      final uri = Uri.parse(this);

      // Check basic URL structure
      if (!uri.hasScheme || !uri.hasAuthority || uri.host.isEmpty) {
        return false;
      }

      // Only allow http and https schemes
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return false;
      }

      // Block known placeholder domains
      final blockedDomains = [
        'example.com',
        'placeholder.com',
        'test.com',
        'localhost',
        ".svg"
      ];

      if (blockedDomains.any((domain) => uri.host.contains(domain))) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
