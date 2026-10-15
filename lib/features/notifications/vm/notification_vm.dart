import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/notifications/repo/notification_repository.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/models/notification_response.dart';
import 'package:wayagram/features/notifications/state/default.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';

class NotificationVm extends StateNotifier<NotificationState> {
  final NotificationRepository _repo;
  // ignore: unused_field
  final Ref _ref;
  final Logger _logger;

  // This is fine.
  NotificationVm(
    this._repo,
    this._ref,
    this._logger,
    super.state,
  );

  // Used to retrieve the notification state.
  NotificationState get currentState {
    return state;
  }

  /// Helper function used to update the filters on this notification object.
  void setFilters(FilterNotificationState value) {
    state = state.copyWith(filters: value);
  }

  /// Helper function used to clear any filters on this notification view model.
  void clearFilters() {
    state = state.copyWith(filters: FilterNotificationState.initial);
  }

  /// Helper function used to set the search query.
  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value.trim().toLowerCase());
  }

  /// Helper function used to send the generated device token to the back-end.
  Future<bool> sendDeviceToken() async {
    try {
      final token = await PushNotifications.requestDeviceToken();

      //? This is fine.
      if (kDebugMode) {
        debugPrint("Device Token: $token");
      }

      //? If no token was retrieved, this failed.
      if (token == null) return false;

      //? Next, try to make the request.
      final response = await _repo.addDeviceToken(token);

      // Return whether or not this was fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return false;
  }

  /// Helper function used to send the generated device token to the back-end.
  Future<bool> deleteDeviceToken() async {
    try {
      //? Next, try to make the request.
      final response = await _repo.deleteDeviceToken();

      // Return whether or not this was fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return false;
  }

  /// Helper function used to get all notifications.
  Future<List<NotificationModel>> getUserNotifications(
      [bool reset = true]) async {
    final result = <NotificationModel>[];

    //? First, notify this guy that we are loading.
    WayaPreloaderController.instance.show();

    //? Set the page.
    if (reset) {
      state = state.copyWith(page: 1);
    }

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
        result.addAll(data
            .docs); //? Notify our listeners that the game has been switched up.
        state = state.copyWith(
          notifications: result,
          page: data.nextPage,
        );
      }

      //? Since it failed, we should probably do failure cleanups in the future.
      else {
        //? Notify our listeners that the game has been switched up.
        state = state.copyWith(
          notifications: result,
        );
      }
    } catch (e) {
      _logger.e(e, stackTrace: WayaDebugHelpers.getStackTrace(e));
    }

    //? Now hide the preloader.
    WayaPreloaderController.instance.hide();

    // Return this.
    return result;
  }

  /// Configure whether or not we are only looking at requests at the moment.
  /// This is an extremely local use-case so it probably should not even exist.
  void setIsRequestsOnly(bool value) {
    state = state.copyWith(requestsOnly: value);
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationVm, NotificationState>(
  (ref) {
    final notificationRepo = ref.watch(notificationRepositoryProvider);

    return NotificationVm(
      notificationRepo,
      ref,
      getLogger("NotificationVm"),
      NotificationState.initial,
    );
  },
);
