import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/state/social_notification.dart';
import 'package:wayagram/features/general_settings/notifications/repo/default.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/models/notification_response.dart';

class SocialNotificationNotifier extends StateNotifier<SocialNotificationState> {
  final NotificationRepository _repo;
  // ignore: unused_field
  final Ref _ref;
  final Logger _logger;

  // This is fine.
  SocialNotificationNotifier(
    this._repo,
    this._ref,
    this._logger,
    super.state,
  );

  // Used to retrieve the notification state.
  SocialNotificationState get currentState {
    return state;
  }

  /// Helper function used to update the filters on this notification object.
  void setFilters(SocialNotificationFilters value) {
    state = state.copyWith(filters: value);
  }

  /// Helper function used to clear any filters on this notification view model.
  void clearFilters() {
    state = state.copyWith(filters: SocialNotificationFilters.initial);
  }

  /// Helper function used to set the search query.
  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value.trim().toLowerCase());
  }

  /// Helper function used to get all notifications.
  Future<List<NotificationModel>> getUserNotifications([int page = 1]) async {
    final result = <NotificationModel>[];

    //? First, notify this guy that we are loading.
    WayaPreloaderController.instance.show();

    //? Now, try to get the notifications and fall back when failed.
    try {
      final response = await _repo.getUserNotifications(state.page);

      //? If this has passed the first page, we should add more notifications.
      if (state.page > 1) {
        result.addAll(state.notifications);
      }

      //? If this went well...
      if (response.success) {
        final data = NotificationResponseModel.fromJson(response.data['data']);
        result.addAll(
          data.docs.where(
            (e) => ![
              NotificationMessageType.creditAlert,
              NotificationMessageType.debitAlert,
              NotificationMessageType.donation,
            ].contains(e.messageType),
          ),
        );
      }

      //? Since it failed, we should probably do failure cleanups in the future.
      else {}

      //? Notify our listeners that the game has been switched up.
      state = state.copyWith(
        notifications: result,
      );
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
      _logger.log(Level.error, e);
    }

    //? Now hide the preloader.
    WayaPreloaderController.instance.hide();

    // Return this.
    return result;
  }
}

final socialNotificationProvider = StateNotifierProvider<SocialNotificationNotifier, SocialNotificationState>(
  (ref) {
    return SocialNotificationNotifier(
      NotificationRepository.instance,
      ref,
      getLogger("socialNotificationProvider"),
      SocialNotificationState.initial,
    );
  },
);
