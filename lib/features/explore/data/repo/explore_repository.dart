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

  Future<WayaRequestResponse> fetchCommentedPost(int page, [int limit = 20]) {
    return get(
        "$serviceUrl/posts/users/feed?hasCommented=true&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> fetchLikedPosts(int page, [int limit = 20]) {
    return get(
        "$serviceUrl/posts/users/feed?isLiked=true&page=$page&limit=$limit");
  }

   Future<WayaRequestResponse> fetchreposts(int page, [int limit = 20]) {
    return get(
        "$serviceUrl/posts/users/feed?isReposted=true&page=$page&limit=$limit");
  }
}
