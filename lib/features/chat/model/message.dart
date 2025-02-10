import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/dto/chat.dart';

part 'message.g.dart';

// This is fine.
enum MessageType {
  text,
  voiceNote,
  sticker,
  image,
  video,
  file,
  location,
  contact,
  call,

  @JsonValue("missed_call")
  missedCall,
}

// The status of messages.
enum MessageStatusCode {
  sent,
  deleted,
  read,
  delivered,
}

// The kind of deletion you want to perform on this message.
enum MessageDeleteAction {
  @JsonValue('delete-for-me')
  deleteForMe('delete-for-me'),

  @JsonValue('delete-for-everyone')
  deleteForEveryone('delete-for-everyone');

  const MessageDeleteAction(this.value);
  final String value;
}

@JsonSerializable()
class MessageMedia {
  final String id;
  final String messageId;
  final MessageType mediaType;
  final String mediaUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MessageMedia({
    required this.id,
    required this.messageId,
    required this.mediaType,
    required this.mediaUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageMedia.fromJson(Map<String, dynamic> json) => _$MessageMediaFromJson(json);

  Map<String, dynamic> toJson() => _$MessageMediaToJson(this);
}

@JsonSerializable()
class MessageReaction {
  final String id;
  final String messageId;
  final String userId;
  final String reaction;

  // Construct.
  const MessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.reaction,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) => _$MessageReactionFromJson(json);

  Map<String, dynamic> toJson() => _$MessageReactionToJson(this);
}

@JsonSerializable()
class MessageStatus {
  final String id;
  final String messageId;
  final String userId;
  final MessageStatusCode status;
  final DateTime createdAt;

  // Construct.
  MessageStatus({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  factory MessageStatus.fromJson(Map<String, dynamic> json) => _$MessageStatusFromJson(json);

  Map<String, dynamic> toJson() => _$MessageStatusToJson(this);
}

@JsonSerializable()
class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String? content;
  final String? mediaUrl;
  final MessageType messageType;
  final bool edited;
  final String? originalMessageId;
  final MessageModel? originalMessage;
  final String? forwardedFrom;
  final bool isReply;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageStatus>? status;
  final List<MessageMedia>? media;
  final List<MessageReaction>? messageReaction;
  final bool? isDeletedBySender;
  final bool? isDeleted;

  // Front-end implementations.
  final List<String>? contacts;
  final bool? isError;
  final SendMessageDto? dto;

  // This is fine.
  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.mediaUrl,
    required this.messageType,
    required this.edited,
    required this.originalMessageId,
    required this.originalMessage,
    required this.forwardedFrom,
    required this.isReply,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.media,
    required this.messageReaction,
    required this.contacts,
    required this.isDeleted,
    required this.isDeletedBySender,
    this.isError,
    this.dto,
  });

  String get contentDescription {
    return switch (messageType) {
      MessageType.file => "${media!.length} files",
      MessageType.location => "Location",
      _ => content ?? "",
    };
  }

  DateTime? get readAt {
    return status?.where((receipt) => receipt.status == MessageStatusCode.read).firstOrNull?.createdAt;
  }

  DateTime? get deliveredAt {
    return status?.where((receipt) => receipt.status == MessageStatusCode.delivered).firstOrNull?.createdAt;
  }

  Map<String, int> get reactionPairs {
    final result = <String, int>{};

    //? Now we iterate on each pair.
    for (final reaction in messageReaction ?? <MessageReaction>[]) {
      final count = result[reaction.reaction] ?? 0;
      result[reaction.reaction] = count + 1;
    }

    //? This is fine.
    return result;
  }

  // This is fine.
  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  // This is fine.
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  /// Clones this message in an attempt to set whether this is an error or not.
  MessageModel copyWith(bool isError, MessageModel? replyTo) {
    return MessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      mediaUrl: mediaUrl,
      messageType: messageType,
      edited: edited,
      dto: dto,
      originalMessageId: replyTo?.id ?? originalMessageId,
      originalMessage: replyTo ?? originalMessage,
      forwardedFrom: forwardedFrom,
      isReply: isReply,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      media: media,
      messageReaction: messageReaction,
      contacts: contacts,
      isError: isError,
      isDeleted: isDeleted,
      isDeletedBySender: isDeletedBySender,
    );
  }
}
