import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';

class GroupRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.graph;
  static final instance = GroupRepository._();

  factory GroupRepository() => instance;
  GroupRepository._();

  Future<WayaRequestResponse> createGroup(
      String groupName, String groupDesc, bool groupType, String coverImage, String profileImage, String category) {
    final payload = {
      "name": groupName,
      "description": groupDesc,
      "isPrivate": groupType, //Optional field, if you leave it blank it defaults to false
      //"isOpen": false, // this defaults to true if it is not inserted
      "coverImage": coverImage,
      "profileImage": profileImage,
      "categories": [category]
    };

    return post("$serviceUrl/groups", payload, showErrors: true);
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

  Future<WayaRequestResponse> createGroupPost(String content, List<String> images, String postType, String groupId) {
    final payload = {"content": content, "groupId": groupId, "type": "generic", "media": images, "privacy": postType};

    return post("$serviceUrl/posts", payload, showErrors: true);
  }

  Future<WayaRequestResponse> getUserCategory() {
    return get("$serviceUrl/interests/categories");
  }

  Future<WayaRequestResponse> editGroup(
      String groupName, String groupDesc, bool groupType, String coverImage, String profileImage, groupId) {
    final payload = {
      "name": groupName,
      "description": groupDesc,
      "isPrivate": groupType, //Optional field, if you leave it blank it defaults to false
      //"isOpen": false, // this defaults to true if it is not inserted
      "coverImage": coverImage,
      "profileImage": profileImage
    };

    return put("$serviceUrl/groups/$groupId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> getGroupsForUser(String userId, int page, int limit) async {
    return httpClient.getHttp("$serviceUrl/groups?ownerId=$userId&page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC");
  }


  Future<WayaRequestResponse> leaveGroup(String groupId) {
    final payload = {};
    return post("$serviceUrl/groups/leave/$groupId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> joinGroup(String groupId) {
    final payload = {};
    return post("$serviceUrl/groups/join/$groupId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> deleteGroup(groupId) {
    return delete("$serviceUrl/groups/$groupId", showErrors: true);
  }

  Future<WayaRequestResponse> removeTeamMember(groupId, memberId) {
    return delete("$serviceUrl/groups/$groupId/members/$memberId", showErrors: true);
  }

  Future<WayaRequestResponse> getSingleGroup(id) {
    return get("$serviceUrl/groups?id=$id");
  }

  Future<WayaRequestResponse> fetchSingleGroupPost(String groupId, [int page = 1, int limit = 15]) {
    return get("$serviceUrl/posts?groupId=$groupId&page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getMyGroups([int page = 1, int limit = 15]) {
    return get("$serviceUrl/groups/user-groups?page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getAllGroups([int page = 1, int limit = 500]) {
    return get("$serviceUrl/groups?page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getGroupPost(String groupId, [int page = 1, int limit = 15]) {
    return get("$serviceUrl/groups/popular-post?groupId=$groupId&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getGroupMember(String groupId) {
    return get("$serviceUrl/groups/members?groupId=$groupId");
  }

  Future<WayaRequestResponse> fetchPopularPost() {
    return get("$serviceUrl/groups/popular-post");
  }

  Future<WayaRequestResponse> getEvent() {
    return get("$serviceUrl/events/get-event");
  }

  Future<WayaRequestResponse> joinRequest(String groupId) {
    return get("$serviceUrl/groups/join-requests/$groupId?rstatus=pending&userId=${ConversationState.self.id}", showErrors: true);
  }

  Future<WayaRequestResponse> getJoinedGroup([int page = 1, int limit = 15]) {
    return get("$serviceUrl/groups/joined-groups?page=$page&orderBy=createdAt&orderDirection=DESC&limit=$limit");
  }

  Future<WayaRequestResponse> reportGroup(String groupId, String reason) {
    final payload = {"groupId": groupId, "reason": reason};
    return post("$serviceUrl/reports/create", payload);
  }

  Future<WayaRequestResponse> approveJoinRequest(String requestId) {
    final payload = {"targetUserId": "", "role": "member"};
    return post("$serviceUrl/groups/join-requests/approve/$requestId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> rejectJoinRequest(String requestId) {
    final payload = {};
    return post("$serviceUrl/groups/join-requests/reject/$requestId", payload, showErrors: true);
  }

  Future<WayaRequestResponse> inviteUserToGroup(String groupId, String role, targetId) {
    final payload = {"targetUserId": targetId, "role": role};
    return post("$serviceUrl/groups/invitations/$groupId", payload, showErrors: true);
  }


  // recommended groups
  Future<WayaRequestResponse> recommendedGroup({int? page = 1, int? limit = 40}) {
    return get("$serviceUrl/groups/recommended?page=$page&limit=$limit");
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

  Future<WayaRequestResponse> removeReaction(String postId, String? reactionId) async {
    return delete("$serviceUrl/posts/$postId/like");
  }

  Future<WayaRequestResponse> getComment(postId) {
    return get("$serviceUrl/posts/comments/$postId");
  }

  Future<WayaRequestResponse> deleteComment(String commentId) async {
    return delete("$serviceUrl/posts/$commentId/comment");
  }

  Future<WayaRequestResponse> updateGroupSetting(bool isPrivate, groupId) {
    final payload = { "isPrivate": isPrivate};
    return patch("$serviceUrl/groups/update-setting/$groupId", payload);
  }

  Future<WayaRequestResponse> checkJoinGroupRequest(groupId) {
    return get("$serviceUrl/groups/check-join/$groupId");
  }
}
