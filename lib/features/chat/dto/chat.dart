import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'chat.g.dart';

@JsonSerializable()
class SendMessageDto {
  final MessageType type;
  final String chatId;
  final String? originalMessageId;
  final String? content;
  final MessageModel? originalMessage;
  final List<String>? media;
  final List<String>? contacts;

  SendMessageDto({
    required this.chatId,
    required this.type,
    required this.originalMessageId,
    required this.originalMessage,
    required this.content,
    required this.media,
    required this.contacts,
  });

  factory SendMessageDto.fromJson(Map<String, dynamic> json) => _$SendMessageDtoFromJson(json);

  Map<String, dynamic> toBrokenJson() => _$SendMessageDtoToJson(this);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    //? Also fine.
    map['media'] = [];
    map['chatId'] = chatId;
    if (originalMessageId?.isNotEmpty ?? false) map['originalMessageId'] = originalMessageId;
    if (content?.isNotEmpty ?? false) map['content'] = content;
    map['messageType'] = type.name;
    map['senderId'] = ConversationState.self.id;
    return map;
  }
}
