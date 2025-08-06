import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';

part 'user_profile_repository.g.dart';

class UserProfileRepository extends BaseRepositoryRiverpod {
  static const serviceUri = WayaServiceUri.graph;

  UserProfileRepository(super.ref);

  Future<WayaRequestResponse> getPostsForUser(
      String userId, int page, int limit) async {
    return get(
      "$serviceUri/posts/users/posts?userId=$userId&orderBy=createdAt&orderDirection=DESC&limit=$limit&page=$page",
    );
  }

  Future<WayaRequestResponse> getRepostsForUser(
      String userId, int page, int limit) async {
    return get(
        "$serviceUri/posts/?isRepost=true&userId=$userId&orderBy=createdAt&orderDirection=DESC&limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> getBookmarksForUser(
      String userId, int page, int limit) async {
    return get(
        "$serviceUri/posts/users/feed?isBookmarked=true&limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> bookMarkPost(String postId) {
    final payload = {};
    return post("$serviceUri/posts/bookmarks/$postId", payload);
  }

  Future<WayaRequestResponse> removeBookMark(String bookmarkId) {
    return delete("$serviceUri/posts/bookmarks/$bookmarkId");
  }

  Future<WayaRequestResponse> getEventsForUser(
      String userId, int page, int limit) async {
    return get("$serviceUri/events/get-event?userId=$userId");
  }

  Future<WayaRequestResponse> getGroupsForUser(
      String userId, int page, int limit) async {
    return get("$serviceUri/groups?ownerId=$userId&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getPagesForUser(
      String userId, int page, int limit) async {
    return get("$serviceUri/pages?ownerId=$userId&page=$page&limit=$limit");
  }
}

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepository(ref);
}
