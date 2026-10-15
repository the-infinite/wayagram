import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';

part 'notification_repository.g.dart';

class NotificationRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.notification;
  static const serviceUrlGraph = WayaServiceUri.graph;

  NotificationRepository(super.ref);

  Future<WayaRequestResponse> getUserNotifications(
      [int page = 0, int limit = 200]) {
    return get(
        "$serviceUrl/users/notifications?page=$page&offset=$page&limit=$limit");
  }

  Future<WayaRequestResponse> deleteDeviceToken() async {
    final token = await PushNotifications.requestDeviceToken();

    return delete(
      "$serviceUrl/users/tokens",
      body: {
        "deviceToken": token ?? "null",
      },
    );
  }

  Future<WayaRequestResponse> addDeviceToken(String deviceToken) {
    return post("$serviceUrl/users/tokens", {
      "tokens": [deviceToken],
    });
  }

  Future<WayaRequestResponse> updateSettings(
      List<Map<String, dynamic>> settings) {
    return put("$serviceUrl/users/preferences", {
      "preferences": settings,
    });
  }

  Future<WayaRequestResponse> getSettings() {
    return get("$serviceUrl/users/preferences");
  }
}

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository(ref);
}
