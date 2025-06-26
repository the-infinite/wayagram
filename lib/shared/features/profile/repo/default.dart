import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class UserProfileRepository extends BaseRepository {
  static const serviceUri = WayaServiceUri.graph;
  static final instance = UserProfileRepository._();

  UserProfileRepository._();

  Future<WayaRequestResponse> getPostsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp(
      "$serviceUri/posts/users/posts?userId=$userId&orderBy=createdAt&orderDirection=DESC&limit=$limit&page=$page",
    );
  }

  Future<WayaRequestResponse> getRepostsForUser(String userId, int page, int limit) async {
    return httpClient
        .getHttp("$serviceUri/posts/?isRepost=true&userId=$userId&orderBy=createdAt&orderDirection=DESC&limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> getBookmarksForUser(String userId, int page, int limit) async {
    return httpClient.getHttp("$serviceUri/posts/users/feed?isBookmarked=true&limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> bookMarkPost(String postId) {
    final payload = {};
    return post("$serviceUri/posts/bookmarks/$postId", payload);
  }

  Future<WayaRequestResponse> removeBookMark(String bookmarkId) {
    return delete("$serviceUri/posts/bookmarks/$bookmarkId");
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
