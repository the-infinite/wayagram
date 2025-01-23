import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

enum NotificationMessageType {
  // For notifications...
  transaction,
  follower,
  event,
  poll,
  chat,
  comment,
  donation,

  // For notification requests.
  friendRequest,
  followRequest,
  groupInvite,
}

@JsonSerializable()
class NotificationTarget {
  final String? email;
  final String? token;
  final String? topic;

  // This is fine.
  NotificationTarget({
    this.email,
    this.token,
    this.topic,
  });

  factory NotificationTarget.fromJson(Map<String, dynamic> data) => _$NotificationTargetFromJson(data);

  Map<String, dynamic> toJson() => _$NotificationTargetToJson(this);
}

@JsonSerializable()
class NotificationMessage {
  final String subject;
  final String body;

  // This is fine.
  NotificationMessage({
    required this.subject,
    required this.body,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> data) => _$NotificationMessageFromJson(data);

  Map<String, dynamic> toJson() => _$NotificationMessageToJson(this);
}

@JsonSerializable()
class NotificationModel {
  final String id;
  final String type;
  final NotificationMessageType messageType;
  final NotificationTarget target;
  final NotificationMessage message;
  final bool read;
  final DateTime createdAt;
  final DateTime updatedAt;

  // This is fine.
  NotificationModel({
    required this.id,
    required this.type,
    required this.messageType,
    required this.target,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data) => _$NotificationModelFromJson(data);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  //? This is fine.
  String get notificationAction => switch (messageType) {
        NotificationMessageType.chat => "Tap to open the chat and reply",
        NotificationMessageType.comment => "Tap to view comment",
        NotificationMessageType.donation => "Tap to view details",
        NotificationMessageType.event => "Tap to join event",
        NotificationMessageType.follower => "Tap to view profile and follow back",
        NotificationMessageType.poll => "Tap to view results and insights",
        NotificationMessageType.transaction => "Tap to view transaction details in your wallet",

        // For requests.
        NotificationMessageType.groupInvite => "Tap to view group summary",
        NotificationMessageType.followRequest => "Tap to view follow request",
        NotificationMessageType.friendRequest => "Tap to view friendRequest request",
      };
}
