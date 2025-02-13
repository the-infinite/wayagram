
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
      "isOpen": false, // this defaults to true if it is not inserted
      "coverImage":  coverImage,
      "profileImage":  profileImage
    };

    return post("$serviceUrl/groups", payload);
  }

  Future<WayaRequestResponse> editGroup(String groupName,
      String groupDesc, bool groupType,
      String coverImage, String profileImage, groupId) {
    final payload = {
      "name": groupName,
      "description": groupName,
      "isPrivate": groupType, //Optional field, if you leave it blank it defaults to false
      "isOpen": false, // this defaults to true if it is not inserted
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

  Future<WayaRequestResponse> getAllGroup(id) {
    return get("$serviceUrl/groups?id=$id");
  }

  Future<WayaRequestResponse> getGroupMember(image) {
    return get("$serviceUrl/groups/members");
  }

  Future<WayaRequestResponse> joinRequest(groupId) {
    return get("$serviceUrl/groups/join-requests/$groupId?rstatus=pending");
  }



/*  Future<WayaRequestResponse> getUploadImage(image) {
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
  }*/
}