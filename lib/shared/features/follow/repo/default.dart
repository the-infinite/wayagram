import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';

class FollowRepository extends BaseRepository {
  static const serviceUri = "wayagram-graph/api/v2";
  static final instance = FollowRepository._();

  // Construct.
  FollowRepository._();

  Future<WayaRequestResponse> getFollowers(String id, int page, int limit) {
    return httpClient.getHttp("$serviceUri/follow/followers/$id?page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getFollowing(String id, int page, int limit) {
    return httpClient.getHttp("$serviceUri/follow/following/$id?page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getFollowStatus(String id) {
    return httpClient.getHttp("$serviceUri/follow/status/$id");
  }

  Future<WayaRequestResponse> followUser(String id) {
    return httpClient.postHttp("$serviceUri/follow/$id", null);
  }

  Future<WayaRequestResponse> unFollowUser(String id) {
    return httpClient.postHttp("$serviceUri/follow/unfollow/$id", null);
  }
    Future<WayaRequestResponse> updateUserSettings(UserSettingsDto dto) {
    return patch("$serviceUri/user/settings", dto.toJson());
  }

    Future<WayaRequestResponse> getUserSettings() {
    return get("$serviceUri/user/settings");
  }
}
