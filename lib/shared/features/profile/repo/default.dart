import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class UserProfileRepository extends BaseRepository {
  static const serviceUri = "wayagram-graph/api/v2";
  static final instance = UserProfileRepository._();

  UserProfileRepository._();

  Future<WayaRequestResponse> getPostsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp(
      "$serviceUri/posts/?userId=$userId&orderBy=likeCount&orderDirection=DESC&limit=$limit&page=$page",
    );
  }

  Future<WayaRequestResponse> getEventsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp("$serviceUri/events/get-event?userId=$userId");
  }

  Future<WayaRequestResponse> getGroupsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp("$serviceUri/groups?ownerId=$userId&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getPagesForUser(String userId, int page, int limit) async {
    return httpClient.getHttp("$serviceUri/pages?ownerId=$userId&page=$page&limit=$limit");
  }
}
