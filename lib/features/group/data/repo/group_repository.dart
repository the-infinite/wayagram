
import 'package:wayagram/core/service/repos/base_repository.dart';

import '../../../../core/service/api_service/request_model.dart';

class GroupRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createGroup(String groupName,
      String groupDesc, bool groupType,
      String coverImage, String profileImage ) {
    final payload = {
      "name": groupName,
      "description": groupName,
      "isPrivate": groupType, //Optional field, if you leave it blank it defaults to false
      //"isOpen": false, // this defaults to true if it is not inserted
      "coverImage":  coverImage,
      "profileImage":  profileImage
    };

    return post("$serviceUrl/groups", payload);
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

  Future<WayaRequestResponse> createGroupPost(
      String content, List<String> images, postType, String groupId) {
    final payload = {
      "content": content,
      "groupId": groupId,
      "type": "generic",
      "media": images,
      "privacy": postType
    };

    return post("$serviceUrl/posts", payload);
  }

  Future<WayaRequestResponse> editGroup(String groupName,
      String groupDesc, bool groupType,
      String coverImage, String profileImage, groupId) {
    final payload = {
      "name": groupName,
      "description": groupDesc,
      "isPrivate": groupType, //Optional field, if you leave it blank it defaults to false
      //"isOpen": false, // this defaults to true if it is not inserted
      "coverImage":  coverImage,
      "profileImage":  profileImage
    };

    return put("$serviceUrl/groups/$groupId", payload);
  }

  Future<WayaRequestResponse> leaveGroup(String groupId ) {
    final payload = {};
    return post("$serviceUrl/groups/leave/$groupId", payload);
  }

  Future<WayaRequestResponse> joinGroup(String groupId ) {
    final payload = {};
    return post("$serviceUrl/groups/join/$groupId", payload);
  }

  Future<WayaRequestResponse> deleteGroup(groupId) {
    return delete("$serviceUrl/groups/$groupId");
  }

  Future<WayaRequestResponse> removeTeamMember(groupId, memberId) {
    return delete("$serviceUrl/groups/$groupId/members/$memberId");
  }

  Future<WayaRequestResponse> getSingleGroup(id) {
    return get("$serviceUrl/groups?id=$id");
  }

  Future<WayaRequestResponse> fetchSingleGroupPost(groupId) {
    return get("$serviceUrl/posts?groupId=$groupId&status=active");
  }

  // all the group filter by id
  Future<WayaRequestResponse> getMyGroups() {
    return get("$serviceUrl/groups/user-groups?limit=100");
  }


  Future<WayaRequestResponse> getAllGroups() {
    return get("$serviceUrl/groups?limit=500");
  }

  Future<WayaRequestResponse> getGroupPost(groupId) {
    return get("$serviceUrl/posts?groupId=$groupId&status=active");
  }

  Future<WayaRequestResponse> getGroupMember(groupId) {
    return get("$serviceUrl/groups/members?groupId=$groupId");
  }

  Future<WayaRequestResponse> fetchPopularPost() {
    return get("$serviceUrl/groups/popular-post");
  }

  Future<WayaRequestResponse> getEvent() {
    return get("$serviceUrl/events/get-event");
  }

  Future<WayaRequestResponse> joinRequest(groupId) {
    return get("$serviceUrl/groups/join-requests/$groupId?rstatus=pending");
  }
  // groups i joinrd
  Future<WayaRequestResponse> getJoinedGroup() {
    return get("$serviceUrl/groups/joined-groups");
  }

  Future<WayaRequestResponse> reportGroup(String groupId, String reason) {
    final payload = {
      "groupId": groupId,
      "reason": reason
    };
    return post("$serviceUrl/moderation", payload);
  }

  Future<WayaRequestResponse> approveJoinRequest(String requestId ) {
    final payload = {
      "targetUserId": "",
      "role": "member"
    };
    return post("$serviceUrl/groups/join-requests/approve/$requestId", payload);
  }

  Future<WayaRequestResponse> rejectJoinRequest(String requestId ) {
    final payload = {};
    return post("$serviceUrl/groups/join-requests/reject/$requestId", payload);
  }

  Future<WayaRequestResponse> inviteUserToGroup(String groupId, String role, targetId) {
    final payload = {
    "targetUserId": targetId,
    "role": role
    };
    return post("$serviceUrl/groups/invitations/$groupId", payload);
  }

  // recommended groups
  Future<WayaRequestResponse> recommendedGroup() {
    return get("$serviceUrl/groups/recommended");
  }

  Future<WayaRequestResponse> followUser(String followingId) {
    final payload = {};
    return post("$serviceUrl/follow/$followingId", payload);
  }

  Future<WayaRequestResponse> commentOnPost(postId, content) {
    final payload = {
      "content": content,
      //"parentCommentId": postId // this is optional and is only required for child comment.
    };
    return post("$serviceUrl/posts/comments/$postId", payload);
  }

  Future<WayaRequestResponse> reactOnPost(String postId, type) async {
    return post("$serviceUrl/posts/$postId/like", postId);
  }

  Future<WayaRequestResponse> removeReaction(
      String postId, String? reactionId) async {
    return delete("$serviceUrl/posts/$postId/like");
    // return getBooleanResponse(response);
  }

  Future<WayaRequestResponse> getComment(postId) {
    return get("$serviceUrl/posts/comments/$postId");
  }

  Future<WayaRequestResponse> deleteComment(String commentId) async {
    return delete("$serviceUrl/posts/$commentId/comment");
  }




}