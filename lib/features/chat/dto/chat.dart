import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/message.dart';

part 'chat.g.dart';

@JsonSerializable()
class SendMessageDto {
  final MessageType type;
  final String? replyToId;
  final String? body;
  final MessageModel? replyTo;
  final List<String>? files;
  final String? voiceMessage;
  final List<String>? contacts;

  SendMessageDto({
    required this.type,
    required this.replyToId,
    required this.replyTo,
    required this.body,
    required this.files,
    required this.voiceMessage,
    required this.contacts,
  });

  factory SendMessageDto.fromJson(Map<String, dynamic> json) => _$SendMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);
}
