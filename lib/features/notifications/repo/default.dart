import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class NotificationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-notification/api/v1";

  Future<WayaRequestResponse> getUserNotifications([int page = 0, int limit = 20]) {
    return get("$serviceUrl/users/notifications?page=$page&offset=$page&limit=$limit");
  }

  Future<WayaRequestResponse> addDeviceToken(String deviceToken) {
    return post("$serviceUrl/users/tokens", {
      "tokens": [deviceToken]
    },);
  }
}
