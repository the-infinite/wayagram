import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/message.dart';

part 'media.g.dart';

@JsonSerializable()
class ChatMediaModel {
  final String id;
  final String senderId;
  final List<MessageMediaModel> media;
  final MessageType messageType;
  final DateTime createdAt;

  // Construct.
  const ChatMediaModel({
    required this.id,
    required this.senderId,
    required this.media,
    required this.messageType,
    required this.createdAt,
  });

  /// Returns `true` if the media is an image, otherwise `false`.
  bool get isImage =>
      messageType == MessageType.image ||
      WayaFileExtensions.images.contains(WayaFileExtensions.getExtensionFromPath(media.first.mediaUrl));

  /// Returns `true` if the media is a video, otherwise `false`.
  bool get isVideo =>
      messageType == MessageType.video ||
      WayaFileExtensions.videos.contains(WayaFileExtensions.getExtensionFromPath(media.first.mediaUrl));

  factory ChatMediaModel.fromJson(Map<String, dynamic> json) => _$ChatMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMediaModelToJson(this);
}
