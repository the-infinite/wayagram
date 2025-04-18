import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/chat/dto/default.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/state/default.dart';

class ChatRepository extends BaseRepository {
  static const serviceUrl = 'communication-service/api/v2';
  static const serviceUrlGraph = 'wayagram-graph/api/v2';

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

  Future<WayaRequestResponse> muteOrUnMuteUser(
      String chatId, bool mute, String? mutedUntil) {
    if (mutedUntil != null) {
      return post("$serviceUrl/client/chat/group/mute", {
        "chatId": chatId,
        "mute": mute,
        "mutedUntil": mutedUntil,
      });
    }
    return post("$serviceUrl/client/chat/group/mute", {
      "chatId": chatId,
      "mute": mute,
    });
  }

  Future<WayaRequestResponse> reportUser(String targetUserId, String reason) {
    return post("$serviceUrlGraph/moderation",
        {"targetUserId": targetUserId, "reason": reason});
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

  Future<WayaRequestResponse> getArchivedChats(
      [int limit = 100, int page = 1, bool archived = true]) {
    return get(
        "$serviceUrl/client/chat/user/all?limit=$limit&page=$page&archived=$archived");
  }
}
