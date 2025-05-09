import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/helpers/debug.dart';
import 'package:wayagram/features/general_settings/notifications/controller/default.dart';
import 'package:wayagram/features/general_settings/notifications/dto/default.dart';
import 'package:wayagram/features/general_settings/notifications/repo/default.dart';
import 'package:wayagram/features/general_settings/notifications/state/default.dart';

class NotificationSettingsVm extends StateNotifier<NotificationSettings> {
  NotificationSettingsVm(super.state);
  final repo = NotificationRepository.instance;

  /// Update the settings to something that we are actually probably going to be
  /// interested in seeing.
  Future<bool> updateSettings(NotificationSettingsController controller) async {
    try {
      final response = await repo.updateSettings(controller.toJson);

      //? If this is fine.
      if (response.success) {
        await getSettings();
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? The
    return false;
  }

  /// Get settings
  Future<bool> getSettings([NotificationSettingsController? initial]) async {
    try {
      final response = await repo.getSettings();

      //? If this is fine.
      if (response.success) {
        final docs = response.data['data'] as List;

        //? If this is empty...
        if (docs.isEmpty) {
          if (initial != null) {
            updateSettings(initial);
          }
          return false;
        }

        //? This is fine.
        final settings = docs.map((setting) => NotificationSetting.fromJson(setting));

        //? Then we use this as need.
        state = state.copyWith(
          isLoading: false,
          showCall: settings.firstWhere((setting) => setting.notificationType == NotificationType.calls).enabled,
          showChat: settings.firstWhere((setting) => setting.notificationType == NotificationType.chat).enabled,
          showComments: settings.firstWhere((setting) => setting.notificationType == NotificationType.comments).enabled,
          showCredit: settings.firstWhere((setting) => setting.notificationType == NotificationType.creditAlert).enabled,
          showDebit: settings.firstWhere((setting) => setting.notificationType == NotificationType.debitAlert).enabled,
          showEvents: settings.firstWhere((setting) => setting.notificationType == NotificationType.events).enabled,
          showFollowRequest: settings.firstWhere((setting) => setting.notificationType == NotificationType.followRequest).enabled,
          showLikes: settings.firstWhere((setting) => setting.notificationType == NotificationType.likes).enabled,
          showLivestream: settings.firstWhere((setting) => setting.notificationType == NotificationType.livestream).enabled,
          showShares: settings.firstWhere((setting) => setting.notificationType == NotificationType.shares).enabled,
          showViews: settings.firstWhere((setting) => setting.notificationType == NotificationType.views).enabled,
        );
      }

      // This is fine.
      return response.success;
    } on TypeError {
      //? Update the settings to the currently allocated value if all fails.
      if (initial != null) {
        updateSettings(initial);
      }
    } catch (e) {
      //? Then we just move along.
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? The
    return false;
  }
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsVm, NotificationSettings>(
  (ref) {
    return NotificationSettingsVm(NotificationSettings.initial);
  },
);
