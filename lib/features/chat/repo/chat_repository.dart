import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/dto/create_conversation_dto.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'chat_repository.g.dart';

class ChatRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.communication;
  static const serviceUrlGraph = WayaServiceUri.graph;

  ChatRepository(super.ref);

  Future<WayaRequestResponse> startConversation(
    ChatType type,
    List<String> members, [
    String? name,
    String? description,
    String? image,
  ]) {
    return post(
      "$serviceUrl/client/chat/init",
      {
        "createdBy": ConversationState.self.id,
        "otherUsers": members,
        "chatType": type.name,
        if (name != null) "name": name,
        if (description != null) "description": description,
        if (image != null) "groupImage": image,
      },
    );
  }

  Future<WayaRequestResponse> getConversation(String id) {
    return get("$serviceUrl/client/chat/retrieve/$id");
  }

  Future<WayaRequestResponse> getBlockedUsers() {
    return get("$serviceUrl/client/chat-user/block");
  }

  Future<WayaRequestResponse> getMutedUsers([int limit = 100, int page = 1]) {
    return get("$serviceUrlGraph/mute?limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> updateChatSettings(PrivacySettingsDto dto) {
    return patch("$serviceUrl/client/chat-user/settings", dto.toJson());
  }

  Future<WayaRequestResponse> getChatSettings(String userId) {
    return get("$serviceUrl/client/chat-user/user/$userId");
  }

  Future<WayaRequestResponse> getAllConversations(
      [int limit = 100, int page = 1]) {
    return get("$serviceUrl/client/chat/user/all?limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> blockOrUnblockUser(String id) {
    return post("$serviceUrl/client/chat/block-unblock", {"blockedId": id});
  }

  Future<WayaRequestResponse> muteOrUnmuteUser(String id) {
    return post("$serviceUrl/client/chat/group/mute", {
      "targetUserId": id,
    });
  }

  Future<WayaRequestResponse> reportUser(String targetUserId, String reason,
      [String? comment]) {
    return post("$serviceUrlGraph/reports/create", {
      "targetUserId": targetUserId,
      "reason": reason,
      if (comment?.isNotEmpty ?? false) "comment": comment,
    });
  }

  Future<WayaRequestResponse> archiveOrUnarchiveChat(String id) {
    return put("$serviceUrl/client/chat/archive-unarchive", {"chatId": id});
  }

  Future<WayaRequestResponse> pinOrUnpinChat(String id) {
    return put("$serviceUrl/client/chat/pin", {"chatId": id});
  }

  Future<WayaRequestResponse> deleteConversation(String id) {
    return delete("$serviceUrl/client/chat/delete/$id");
  }

  Future<WayaRequestResponse> deleteMessages(String chatId) {
    return delete("$serviceUrl/client/message/all/$chatId");
  }

  Future<WayaRequestResponse> getArchivedChats(
      [int limit = 100, int page = 1, bool archived = true]) {
    return get(
        "$serviceUrl/client/chat/user/all?limit=$limit&page=$page&archived=$archived");
  }

  // THE APIs for group chats.
  Future<WayaRequestResponse> updateGroupImage(String id, String image) {
    return put("$serviceUrl/client/chat/group/photo",
        {"chatId": id, "groupImage": image});
  }

  Future<WayaRequestResponse> reportChatGroup(String id, String reason) {
    return post("$serviceUrl/client/chat/group/report",
        {"chatId": id, "reason": reason});
  }

  Future<WayaRequestResponse> leaveGroup(String id) {
    return post("$serviceUrl/client/chat/group/leave", {"chatId": id});
  }

  Future<WayaRequestResponse> removeUserFromGroup(String id, String userId) {
    return post("$serviceUrl/client/chat/group/remove-user",
        {"chatId": id, "userId": userId});
  }

  Future<WayaRequestResponse> addUserToGroup(String id, String userId) {
    return post("$serviceUrl/client/chat/group/add-user",
        {"chatId": id, "userId": userId});
  }

  Future<WayaRequestResponse> updateGroupInfo(String id, String name,
      [String? description]) {
    return put("$serviceUrl/client/chat/group/name", {
      "chatId": id,
      "name": name,
      if (description != null) "description": description
    });
  }

  Future<WayaRequestResponse> muteOrUnmuteGroup(
      String chatId, DateTime? mutedUntil) {
    if (mutedUntil != null) {
      return post("$serviceUrl/client/chat/group/mute", {
        "chatId": chatId,
        "mute": true,
        "mutedUntil": mutedUntil.toIso8601String()
      });
    }
    return post("$serviceUrl/client/chat/group/mute",
        {"chatId": chatId, "mute": false});
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(ref);
}
