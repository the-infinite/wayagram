import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class PageRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";
  static final instance = PageRepository._();
  PageRepository._();

  factory PageRepository() => instance;

  Future<WayaRequestResponse> createPost(String content, List<String> images, postType) {
    final payload = {"content": content, "type": "generic", "media": images, "privacy": postType};

    return post("$serviceUrl/posts", payload);
  }

  Future<WayaRequestResponse> createPagePost(String content, List<String> images, postType, postId) {
    final payload = {"content": content, "postId": postId, "type": "generic", "media": images, "privacy": postType};

    return post("$serviceUrl/posts", payload);
  }

  Future<WayaRequestResponse> getUploadImage(image) {
    return get("$serviceUrl/signed-url/$image");
  }

  Future<WayaRequestResponse> fetchSinglePagePost(pageId) {
    return get("$serviceUrl/posts?pageId=$pageId&status=active");
  }

  Future<WayaRequestResponse> putImage(url, image) {
    return put(
      "$url",
      image,
      contentType: 'image/jpeg',
      isBinary: true,
      isWgUrl: false,
      isAuth: false,
    );
  }

  Future<WayaRequestResponse> bookMarkPost(postId) {
    final payload = {};
    return post("$serviceUrl/posts/bookmarks/$postId", payload);
  }

  Future<WayaRequestResponse> removeBookMark(bookmarkId) {
    final payload = {};
    return post("$serviceUrl/posts/bookmarks/$bookmarkId", payload);
  }

  Future<WayaRequestResponse> sharePost(postId) {
    final payload = {"shareType": "external"};
    return post("$serviceUrl/posts/share/$postId", payload);
  }

  Future<WayaRequestResponse> likePost(postId) {
    final payload = {};
    return post("$serviceUrl/posts/likes/$postId", payload);
  }

  Future<WayaRequestResponse> unlikePost(postId) {
    final payload = {};
    return post("$serviceUrl/posts/likes/$postId", payload);
  }

  Future<WayaRequestResponse> repost(postId) {
    final payload = {};
    return post("$serviceUrl/posts/repost/$postId", payload);
  }

  Future<WayaRequestResponse> savePost(postId) {
    return delete("$serviceUrl/posts/$postId/archive");
  }

  Future<WayaRequestResponse> deletePost(postId) {
    return delete("$serviceUrl/posts/$postId");
  }

  Future<WayaRequestResponse> fetchPost(userId) {
    return get("$serviceUrl/posts?userId=$userId&status=active");
  }

  Future<WayaRequestResponse> fetchSinglePost(postId) {
    return get("$serviceUrl/posts?postId=$postId&status=active");
  }

  Future<WayaRequestResponse> commentOnPost(String postId, String content, String? parentCommentId) {
    final payload = {
      "content": content,
      if (parentCommentId != null) "parentCommentId": parentCommentId,
    };
    return post("$serviceUrl/posts/comments/$postId", payload);
  }

  Future<WayaRequestResponse> reportPage(String pageId, String reason) {
    final payload = {"pageId": pageId, "reason": reason};
    return post("$serviceUrl/moderation", payload);
  }

  Future<WayaRequestResponse> reportPost(String postId, String reason) {
    final payload = {"postId": postId, "reason": reason};
    return post("$serviceUrl/posts/report", payload);
  }

  // Future<WayaRequestResponse> likePost(postId) {
  //   return post("$serviceUrl/posts/$postId/likes");
  // }

  Future<WayaRequestResponse> removeRepost(String id) async {
    return delete("$serviceUrl/posts/$id/comment");
  }

  Future<WayaRequestResponse> editPost(String content, List<String> images, postType, String postId) {
    final payload = {"content": content, "media": images, "privacy": postType};

    return patch("$serviceUrl/posts/$postId", payload);
  }

  Future<WayaRequestResponse> reactOnPost(String postId, type) async {
    return post("$serviceUrl/posts/$postId/like", postId);
  }

  Future<WayaRequestResponse> removeReaction(String postId, String? reactionId) async {
    return delete("$serviceUrl/posts/$postId/like");
    // return getBooleanResponse(response);
  }

  Future<WayaRequestResponse> getComment(postId) {
    return get("$serviceUrl/posts/comments/$postId");
  }

  Future<WayaRequestResponse> deleteComment(String commentId) async {
    return delete("$serviceUrl/posts/comments/$commentId");
  }

  Future<WayaRequestResponse> likeComment(String commentId) async {
    return post("$serviceUrl/posts/comments/likes/$commentId", {});
  }

  Future<WayaRequestResponse> unlikeComment(String commentId) async {
    return delete("$serviceUrl/posts/comments/likes/$commentId");
  }

  Future<WayaRequestResponse> editComment(String commentId, String content) async {
    return patch("$serviceUrl/posts/comments/$commentId", {"content": content});
  }

  Future<WayaRequestResponse> getFollowing() {
    return get("$serviceUrl/follow/following");
  }

  Future<WayaRequestResponse> getFollowers() {
    return get("$serviceUrl/follow/followers");
  }

  Future<WayaRequestResponse> createPage(
      String pageName, String pageDesc, bool pageType, String coverImage, String profileImage) {
    final payload = {
      "name": pageName,
      "description": pageDesc,
      "isPublic": pageType, //Optional field, if you leave it blank it defaults to false
      //"isOpen": false, // this defaults to true if it is not inserted
      "coverImage": coverImage,
      "profileImage": profileImage
    };

    return post("$serviceUrl/pages", payload);
  }

  Future<WayaRequestResponse> getAllPosts({int? limit = 200}) async {
    return get(
        "$serviceUrl/posts/?status=active&&orderBy=popularityScore&orderDirection=DESC&privacy=public&limit=$limit");
  }

  Future<WayaRequestResponse> fetchPopularPost() {
    return get("$serviceUrl/pages/popular-posts");
  }

  Future<WayaRequestResponse> getAllPostsWithCategory(
      {required String category, required int page, int? limit = 5}) async {
    return get(
        "$serviceUrl/posts/?status=active&&orderBy=popularityScore&orderDirection=DESC&privacy=public&categories=$category&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getAllPages(String ownerId, [int page = 1, int limit = 500]) {
    return get("$serviceUrl/pages?page=$page&limit=$limit&ownerId=$ownerId&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> deletePage(String pageId) async {
    return delete("$serviceUrl/pages/$pageId");
  }

  Future<WayaRequestResponse> getPageMembers(String pageId) {
    return get("$serviceUrl/pages/team-members/$pageId");
  }

  Future<WayaRequestResponse> updateTeamMember(String role, String pageId, String memberId) {
    final payload = {"role": role};

    return put("$serviceUrl/pages/$pageId/team-members/$memberId", payload);
  }

  Future<WayaRequestResponse> editPage(
      String name, String desc, bool pageType, String coverImage, String profileImage, String pageId) {
    final payload = {
      "name": name,
      "description": desc,
      "isPublic": pageType,
      "coverImage": coverImage,
      "profileImage": profileImage
    };

    return put("$serviceUrl/pages/$pageId", payload);
  }

  Future<WayaRequestResponse> removePageTeamMember(String pageId, String memberId) async {
    return delete("$serviceUrl/pages/$pageId/team-members/$memberId");
  }

  Future<WayaRequestResponse> followPage(String pageId) async {
    final payload = {};
    return post("$serviceUrl/pages/follow/$pageId", payload);
  }

  Future<WayaRequestResponse> unFollowPage(String pageId) async {
    return delete("$serviceUrl/pages/follow/$pageId");
  }

  Future<WayaRequestResponse> getPagesAUserFollows([int page = 1, int limit = 15]) {
    return get("$serviceUrl/pages/user/followings?page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getRecommendedPages() {
    return get("$serviceUrl/pages/recommended");
  }
}
