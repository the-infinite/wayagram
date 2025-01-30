import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

part 'message.g.dart';

// This is fine.
enum MessageType {
  text,
  audio,
  file,
  location,
  contact,
  call,

  @JsonValue("missed_call")
  missedCall,
}

@JsonSerializable()
class MessageModel {
  final String id;
  final String conversationId;
  final User? sender;
  final String senderId;
  final MessageModel? replyTo;
  final String? body;
  final List<String>? files;
  final String? voiceMessage;
  final List<String>? contacts;
  final MessageType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;
  final DateTime? deliveredAt;

  // This is fine.
  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.body,
    required this.files,
    required this.voiceMessage,
    required this.contacts,
    required this.senderId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.replyTo,
    this.readAt,
    this.deliveredAt,
  });

  String get contentDescription {
    return switch (type) {
      MessageType.file => "${files!.length} files",
      MessageType.location => "Location",
      _ => body!,
    };
  }

  String get senderName {
    return sender == null ? "WayaGram User" : "${sender!.firstName} ${sender!.lastName}";
  }

  // This is fine.
  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  // This is fine.
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
