import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class PostRepository extends BaseRepository {
  static const serviceUri = "wayagram-graph/api/v2";
  static final instance = PostRepository._();

  PostRepository._();

  Future<WayaRequestResponse> getPostsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp(
      "$serviceUri/posts/?userId=$userId&orderBy=likeCount&orderDirection=DESC&limit=$limit&page=$page",
    );
  }

  Future<WayaRequestResponse> getEventsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp("$serviceUri/events/get-event?userId=$userId");
  }
}
