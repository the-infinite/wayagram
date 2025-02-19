import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

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
    return httpClient.postHttp("$serviceUri/follow/$id", null);
  }
}
