import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class NotificationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-notification/api/v1";

  Future<WayaRequestResponse> getUserNotifications() {
    return get("$serviceUrl/notifications");
  }
}
