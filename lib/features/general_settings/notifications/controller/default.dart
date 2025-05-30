import 'package:wayagram/features/general_settings/notifications/dto/default.dart';

class NotificationSettingsController {
  final _settings = <String, NotificationSetting>{};
  static final instance = NotificationSettingsController._();

  NotificationSettingsController._();

  factory NotificationSettingsController() {
    return instance;
  }

  void addSetting(String key, NotificationSetting setting) {
    if (!_settings.containsKey(key)) {
      _settings[key] = setting;
    }
  }

  void updateSetting(String key, bool value) {
    if (_settings.containsKey(key)) {
      _settings[key] = _settings[key]!.copyWith(enabled: value);
    }
  }

  void resetSettings() {
    _settings.clear();
  }

  List<Map<String, dynamic>> get toJson => _settings.values.map((setting) => setting.toJson()).toList();
}
