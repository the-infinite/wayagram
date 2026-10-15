abstract class Environment {
  // Get environment from dart defines, default to development
  static const String _environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  static String get current => _environment;

  static bool get isDevelopment => _environment == 'development';
  static bool get isProduction => _environment == 'production';
}

class AppEnvironment {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://services.wayagram.ng/',
  );

  // App Configuration
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Wayagram',
  );

  static const String bundleId = String.fromEnvironment(
    'BUNDLE_ID',
    defaultValue: 'ng.wayagram',
  );

  static const String webUrl = String.fromEnvironment(
    'APP_WEB_URL',
    defaultValue: 'https://wayagram.ng/',
  );

  static const String firebaseIOSAppId =
      String.fromEnvironment('FIREBASE_IOS_APP_ID');

  static const String firebaseAndroidAppId =
      String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
}
