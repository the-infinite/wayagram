import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/features/chat/model/message.dart';

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

  Map<String, dynamic> toJson() {
    final map = _$SendMessageDtoToJson(this);
    if (media != null) {
      map['media'] = media?.map((file) {
        final uri = Uri.parse(file);
        final filename = uri.pathSegments.last;
        final extensionIndex = filename.lastIndexOf(".");
        final fileExtension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
        return MultipartFile.fromFileSync(
          file,
          filename: filename,
          contentType: WayaFileExtensions.getMimeType(fileExtension),
        );
      });
    }
    return map;
  }
}
