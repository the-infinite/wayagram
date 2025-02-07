import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';

class MessageRepository extends BaseRepository {
  static const serviceUrl = 'communication-service/api/v2';

  Future<WayaRequestResponse> sendMessage(
    SendMessageDto data,
  ) {
    return post("$serviceUrl/client/message", data.toJson(), formdata: true);
  }

  Future<WayaRequestResponse> getUnreadMessagesCount() {
    return get("$serviceUrl/client/message/unread/total");
  }

  Future<WayaRequestResponse> readAllInChat(String id) {
    return put("$serviceUrl/client/message/read-all", {
      "userId": ConversationState.self.id,
      "chatId": id,
    });
  }

  Future<WayaRequestResponse> updateMessageStatus(MessageStatusCode status, String id) {
    return put("$serviceUrl/client/message/status", {
      "status": status.name,
      "messageId": id,
      "userId": ConversationState.self.id,
    });
  }

  Future<WayaRequestResponse> getMessages(String chatId, [int limit = 100, int page = 100]) {
    return get("$serviceUrl/client/message?limit=$limit&page=$limit&chatId=$chatId");
  }

  Future<WayaRequestResponse> editMessage(String id, String content) {
    return put("$serviceUrl/client/message/edit", {
      "messageId": id,
      "newContent": content,
    });
  }

  Future<WayaRequestResponse> deleteMessage(List<String> ids, MessageDeleteAction action) {
    return delete("$serviceUrl/client/message", body: {
      'messageIds': ids,
      'action': action.value,
    });
  }

  Future<WayaRequestResponse> forwardAMessage(List<String> chats, String id) {
    return post("$serviceUrl/client/message/forward", {
      "targetChatIds": chats,
      "messageId": id,
    });
  }

  Future<WayaRequestResponse> reactToMessage(String id, String reaction) {
    return post("$serviceUrl/client/message/react", {
      "reaction": reaction,
      "messageId": id,
    });
  }
}
