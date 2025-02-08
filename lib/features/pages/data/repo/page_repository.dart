import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class PageRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createPost(String content, List<String> images, postType) {
    final payload = {
      "content": content,
      "type": "generic",
      "media": images,
      //"linkedServiceId": "123e4567-e89b-12d3-a456-426614174000",
      "privacy": postType
    };

    return post("$serviceUrl/posts", payload);
  }

  Future<WayaRequestResponse> getUploadImage(image) {
    return get("$serviceUrl/signed-url/$image");
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
    final payload = {
      "shareType": "external"
    };
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

  Future<WayaRequestResponse> commentOnPost(postId, content) {
    final payload = {
      "content": content,
      "parentCommentId": postId // this is optional and is only required for child comment.
    };
    return post("$serviceUrl/posts/comments/$postId", payload);
  }

  // Future<WayaRequestResponse> likePost(postId) {
  //   return post("$serviceUrl/posts/$postId/likes");
  // }

  Future<WayaRequestResponse> removeRepost(String id) async {
    return delete("$serviceUrl/posts/$id/comment");

  }

  Future<WayaRequestResponse> editPost(String content, List<String> images, postType, String postId) {
    final payload = {
      "content": content,
      "media": images,
      "privacy": postType
    };

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
    return get("$serviceUrl/posts/$postId/comments");
  }

  Future<WayaRequestResponse> deleteComment(String commentId) async {
    return delete("$serviceUrl/posts/$commentId/comment");
  }

  Future<WayaRequestResponse> getFollowing() {
    return get("$serviceUrl/follow/following");
  }

  Future<WayaRequestResponse> getFollowers() {
    return get("$serviceUrl/follow/followers");
  }
}
