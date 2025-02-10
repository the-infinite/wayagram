import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

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
    map['media'] = media ?? [];
    map['chatId'] = chatId;
    if (originalMessageId?.isNotEmpty ?? false) map['originalMessageId'] = originalMessageId;
    if (content?.isNotEmpty ?? false) map['content'] = content;
    map['messageType'] = type.name;
    map['senderId'] = ConversationState.self.id;
    return map;
  }

  Future<SendMessageDto> uploadFiles() async {
    final files = <String>[];

    //? This is fine.
    for (final file in media ?? []) {
      //? Get the result.
      final entity = File(file);
      final name = type != MessageType.voiceNote ? WayaFileHelper.generateFilename(chatId, entity) : null;
      final result = await WayaFileRepository.instance.uploadFile(entity, name);

      //? If this did not fail...
      if (result != null) files.add(result);
    }

    //? This is fine.
    return SendMessageDto(
      chatId: chatId,
      type: type,
      originalMessageId: originalMessageId,
      originalMessage: originalMessage,
      content: content,
      media: files,
      contacts: contacts,
    );
  }
}
