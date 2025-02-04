import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/models/notification_response.dart';
import 'package:wayagram/features/notifications/repo/default.dart';
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

  /// Helper function used to send the generated device token to the back-end.
  Future<bool> sendDeviceToken() async {
    final token = await PushNotifications.requestDeviceToken();

    //? If no token was retrieved, this failed.
    if (token == null) return false;

    //? Next, try to make the request.
    final response = await _repo.addDeviceToken(token);

    // Return whether or not this was fine.
    return response.success;
  }

  /// Helper function used to get all notifications.
  Future<List<NotificationModel>> getUserNotifications([int page = 0]) async {
    final result = <NotificationModel>[];

    //? First, notify this guy that we are loading.
    state = state.copyWith(isLoading: true);

    //? Now, try to get the notifications and fall back when failed.
    try {
      final response = await _repo.getUserNotifications();

      //? If this went well...
      if (response.success) {
        // final data = NotificationResponseModel.fromJson(response.data['data']);
        // result.addAll(data.notifications);
      }

      //? Since it failed, we should probably do failure cleanups in the future.
      else {}

      //? Notify our listeners that the game has been switched up.
      state = state.copyWith(
        isLoading: false,
        notifications: result.isEmpty ? NotificationState.initial.notifications : [...result],
      );
    } catch (e) {
      _logger.log(Level.error, e);
      state = state.copyWith(isLoading: false);
    }

    // Return this.
    return result;
  }

  /// Configure whether or not we are only looking at requests at the moment.
  /// This is an extremely local use-case so it probably should not even exist.
  void setIsRequestsOnly(bool value) {
    state = state.copyWith(requestsOnly: value);
  }
}

final notificationProvider = StateNotifierProvider<NotificationVm, NotificationState>(
  (ref) {
    return NotificationVm(
      NotificationRepository(),
      ref,
      getLogger("NotificationVm"),
      NotificationState.initial,
    );
  },
);
