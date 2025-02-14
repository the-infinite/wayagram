import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/helpers/value.dart';
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

  List<File>? get asFilesList => media?.map((file) => File(file)).toList();

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

  //? This is fine.
  MessageModel buildMessage(String messageId) => MessageModel(
        id: messageId,
        isDeleted: false,
        isDeletedBySender: false,
        chatId: chatId,
        content: content,
        media: media
            ?.map(
              (file) => MessageMedia(
                id: WayaValueHelper.createUid(),
                messageId: messageId,
                mediaType: type,
                mediaUrl: file,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            )
            .toList(),
        originalMessage: originalMessage,
        contacts: contacts,
        senderId: ConversationState.self.id,
        messageType: type,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        mediaUrl: media?.firstOrNull,
        edited: false,
        originalMessageId: originalMessageId,
        forwardedFrom: null,
        isReply: originalMessageId != null,
        status: [],
        messageReaction: [],
        dto: this,
      );

  Future<SendMessageDto> uploadFiles() async {
    final files = <String>[];

    //? This is fine.
    for (final file in media ?? <String>[]) {
      //? Get the result.
      final entity = File(file);
      final name = type != MessageType.voiceNote ? WayaFileHelper.generateFilename(chatId, entity) : null;
      final result = await WayaFileRepository.instance.uploadFile(entity, name);

      //? If this did not fail...
      if (result == null) continue;

      //? Since this worked fine...
      files.add(result);

      //? We do not need to do this for voice notes.
      if (type == MessageType.voiceNote) continue;

      //? This is fine.
      final messageId = WayaValueHelper.createUid();

      //? Next, we copy the file from its source location to where it would be
      //? when we try to look for it locally.
      final target = await WayaFileHelper.getFileLocalDirectory(buildMessage(messageId), "/x/x/$name");

      //? Print this.
      print("SendMessageDTO/ Copying ${entity.path} to ${target.path}");

      //? If this does not exist...
      if (!await target.exists()) {
        try {
          await entity.copy(target.path);
        } catch (_) {}

        //? This was copied successfully.
        if (!await target.exists()) {
          print("SendMessageDTO/ Failed to copy ${entity.path} to ${target.path}");
        }
      }
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

  List<SendMessageDto> get fragmentMedia {
    //? Our list of DTOs that is our result.
    final result = <SendMessageDto>[];

    //? Now, for each media item in the message body...
    for (var i = 0; i < (media?.length ?? 0); i++) {
      final file = media![i];

      // This is fine.
      result.add(SendMessageDto(
        chatId: chatId,
        type: type,
        originalMessageId: i != 0 ? null : originalMessageId,
        originalMessage: i != 0 ? null : originalMessage,
        content: i != 0 ? null : content,
        media: [file],
        contacts: contacts,
      ));
    }

    //? The result to return.
    return result;
  }
}
