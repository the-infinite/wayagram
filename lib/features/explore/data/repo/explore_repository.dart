import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class ExploreRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.graph;
  static final instance = ExploreRepository._();
  ExploreRepository._();

  Future<WayaRequestResponse> getFeeds(int page, [int limit = 20]) {
    return get("$serviceUrl/posts/users/feed?page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> fetchCommentedPost(String userId, int page, [int limit = 20]) {
    return get(
        "$serviceUrl/posts/users/feed?hasCommented=true&userId=$userId&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> fetchLikedPosts(String userId, int page, [int limit = 20]) {
    return get(
        "$serviceUrl/posts/users/feed?isLiked=true&userId=$userId&page=$page&limit=$limit");
  }

   Future<WayaRequestResponse> fetchReposts(String userId,int page, [int limit = 20]) {
    return get(
        "$serviceUrl/posts/users/feed?isReposted=true&userId=$userId&$page&limit=$limit");
  }
}
