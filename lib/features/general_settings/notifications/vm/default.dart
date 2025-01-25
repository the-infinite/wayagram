import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/general_settings/notifications/state/default.dart';

class NotificationSettingsVm extends StateNotifier<NotificationSettings> {
  NotificationSettingsVm(super.state);
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsVm, NotificationSettings>(
  (ref) {
    return NotificationSettingsVm(NotificationSettings.initial);
  },
);
