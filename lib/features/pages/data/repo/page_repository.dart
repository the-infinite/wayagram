import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class PageRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.graph;
  static final instance = PageRepository._();
  PageRepository._();

  factory PageRepository() => instance;

  Future<WayaRequestResponse> createPost(String content, List<String> images, postType, [String? originalPostId]) {
    final payload = {
      "content": content,
      "type": "generic",
      "media": images,
      "privacy": postType,
    };

    return post("$serviceUrl/posts", payload);
  }

  Future<WayaRequestResponse> createPagePost(
    String content,
    List<String> images,
    String postType,
    String pageId,
  ) {
    final payload = {"content": content, "pageId": pageId, "type": "generic", "media": images, "privacy": postType};

    return post("$serviceUrl/posts", payload);
  }

  Future<WayaRequestResponse> getUploadImage(image) {
    return get("$serviceUrl/signed-url/$image");
  }

  Future<WayaRequestResponse> fetchSinglePagePost(
    String pageId, [
    int page = 1,
    int limit = 15,
  ]) {
    return get(
        "$serviceUrl/posts?pageId=$pageId&status=active&page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC");
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
    return delete("$serviceUrl/posts/likes/$postId");
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
    return get("$serviceUrl/posts?id=$postId");
  }

  Future<WayaRequestResponse> fetchAPost(postId) {
    return get("$serviceUrl/posts/$postId");
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
    return post("$serviceUrl/reports/create", payload, showErrors: true);
  }

  Future<WayaRequestResponse> reportPost(String postId, String reason, String? comment) {
    final payload = {"postId": postId, "reason": reason, "comment": comment};
    // return post("$serviceUrl/posts/report", payload, showErrors: true);
    return post("$serviceUrl/reports/create", payload, showErrors: true);
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

  Future<WayaRequestResponse> getComments(
    String postId, [
    String? parentId,
    int page = 1,
    int limit = 15,
  ]) {
    return get(
      "$serviceUrl/posts/comments/$postId?${parentId != null ? 'parentCommentId=$parentId&' : ''}page=$page&limit=$limit",
    );
  }

  Future<WayaRequestResponse> getSingleComment(String postId, String commentId) {
    return get(
      "$serviceUrl/posts/comments/$postId?id=$commentId",
    );
  }

  Future<WayaRequestResponse> deleteComment(String commentId) async {
    return delete("$serviceUrl/posts/comments/$commentId", showErrors: true);
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

  Future<WayaRequestResponse> getFollowers(String pageId) {
    return get("$serviceUrl/pages/followers/$pageId");
  }

  Future<WayaRequestResponse> createPage(
    String pageName,
    String pageDesc,
    bool pageType,
    String coverImage,
    String profileImage,
    String category,
  ) {
    final payload = {
      "name": pageName,
      "description": pageDesc,
      "isPublic": pageType, //Optional field, if you leave it blank it defaults to false
      "coverImage": coverImage,
      // "isOpen": isOpen,
      "profileImage": profileImage,
      "categories": [category]
    };

    return post("$serviceUrl/pages", payload, showErrors: true);
  }

  Future<WayaRequestResponse> getPageMedia(String pageId, [int page = 1, int limit = 15]) {
    return get("$serviceUrl/posts/posts/media?status=active&orderBy=popularityScore&orderDirection=DESC&privacy=public&pageId=$pageId");
  }

  Future<WayaRequestResponse> getUserCategory() {
    return get("$serviceUrl/interests/categories");
  }

  Future<WayaRequestResponse> getAllPosts({int? limit = 200}) async {
    return get(
      "$serviceUrl/posts/?status=active&orderBy=popularityScore&orderDirection=DESC&privacy=public&limit=$limit",
    );
  }

  Future<WayaRequestResponse> fetchPopularPost() {
    return get("$serviceUrl/pages/popular-posts");
  }

  Future<WayaRequestResponse> getAllPostsWithCategory(
      {required String category, required int page, int? limit = 5}) async {
    return get(
      "$serviceUrl/posts/?status=active&orderBy=popularityScore&orderDirection=DESC&privacy=public&categories=$category&page=$page&limit=$limit",
    );
  }

  Future<WayaRequestResponse> getAllPages(String ownerId, [int page = 1, int limit = 500]) {
    return get("$serviceUrl/pages?page=$page&limit=$limit&ownerId=$ownerId&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getAllManagedPages([int page = 1, int limit = 500]) {
    return get("$serviceUrl/pages/my-managed-pages?limit=$limit&page=1&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getAllPagesSearch([int page = 1, int limit = 500]) {
    return get("$serviceUrl/pages?page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getSinglePage(String pageId) {
    return get("$serviceUrl/pages?id=$pageId");
  }

  Future<WayaRequestResponse> deletePage(String pageId) async {
    return delete("$serviceUrl/pages/$pageId", showErrors: true);
  }

  Future<WayaRequestResponse> getPageMembers(String pageId) {
    return get("$serviceUrl/pages/team-members/$pageId");
  }

  Future<WayaRequestResponse> getPageInvitation() {
    return get("$serviceUrl/pages/user/invitations");
  }

  Future<WayaRequestResponse> acceptPageInvitation(String invitationId) {
    final payload = {};

    return post("$serviceUrl/pages/invitations/$invitationId/accept", payload, showErrors: true);
  }

  Future<WayaRequestResponse> rejectPageInvitation(String invitationId) {
    final payload = {};

    return post("$serviceUrl/pages/invitations/$invitationId/reject", payload, showErrors: true);
  }

  Future<WayaRequestResponse> inviteUserToPage(String role, String pageId, String memberId) {
    final payload = {"role": role};

    return post("$serviceUrl/pages/$pageId/team-members/$memberId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> updateTeamMember(String role, String pageId, String memberId) {
    final payload = {"role": role};

    return put("$serviceUrl/pages/$pageId/team-members/$memberId", payload, showErrors: true);
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

    return put("$serviceUrl/pages/$pageId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> removePageTeamMember(String pageId, String memberId) async {
    return delete("$serviceUrl/pages/$pageId/team-members/$memberId", showErrors: true);
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

  Future<WayaRequestResponse> getRecommendedPages([int page = 1, int limit = 1500]) {
    return get("$serviceUrl/pages/recommended?page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> updatePageSetting(bool isPublic, bool everyoneCanComment, pageId) {
    final payload = {"isPublic": isPublic, "everyoneCanComment": everyoneCanComment};
    return patch("$serviceUrl/pages/update-setting/$pageId", payload);
  }

//Post general settings
  Future<WayaRequestResponse> getPostSettings() {
    return get("$serviceUrl/post-settings/");
  }

  Future<WayaRequestResponse> updatePostSettings(bool oldPostPrivacy, bool newPostPrivacy) async {
    return patch("$serviceUrl/post-settings/update", {
      "oldPostprivacy": oldPostPrivacy ? "public" : "private",
      "newPostprivacy": newPostPrivacy ? "public" : "private"
    });
  }

  //Page general settings
  Future<WayaRequestResponse> updatePageGeneralSettings(bool isEveryOneAllowFollow, bool isEveryOneAllowComment) async {
    return patch("$serviceUrl/user/page-settings", {
      "allowFollow": isEveryOneAllowFollow ,
      "allowComments": isEveryOneAllowComment 
    });
  }

  Future<WayaRequestResponse> getPageGeneralSettings() {
    return get("$serviceUrl/user/page-settings");
  }
}
