
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_model.dart';

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
    // final payload = {
    //   "fileName": image
    // };
    //
    // return post("$serviceUrl/signed-url/url", payload);
    return get("$serviceUrl/signed-url/$image");
  }

  Future<WayaRequestResponse> putImage(url, image) {
    return put("$url", {"image": image}, contentType: 'image/jpeg' );
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

  Future<WayaRequestResponse> commentOnPost(postId, content) {
    final payload = {
      "content": content
    };
    return post("$serviceUrl/posts/$postId/comment", payload);
  }

  Future<WayaRequestResponse> removeRepost(String id) async{
    return delete("$serviceUrl/posts/$id/comment");
  }

  Future<WayaRequestResponse> reactOnPost(String postId, type) async{
   return post("$serviceUrl/posts/:postId/like", postId);
  }

  Future<WayaRequestResponse> removeReaction(String postId, String? reactionId) async{
    return delete("$serviceUrl/posts/:postId/like");
    // return getBooleanResponse(response);
  }

  Future<WayaRequestResponse> getComment(postId) {
    return get("$serviceUrl/posts/$postId/comments");
  }

  Future<WayaRequestResponse> deleteComment(String commentId) async{
    return delete("$serviceUrl/posts/$commentId/comment");
  }

  Future<WayaRequestResponse> getFollowing() {
    return get("$serviceUrl/follow/following");
  }

  Future<WayaRequestResponse> getFollowers() {
    return get("$serviceUrl/follow/followers");
  }





}