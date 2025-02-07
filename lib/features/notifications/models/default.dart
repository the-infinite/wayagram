import 'package:json_annotation/json_annotation.dart';

// @sekani50 @Darlington885 Don't comment out the lines of code that use Json Serializable
// just run the flutter gen command.

part 'default.g.dart';

enum NotificationPriority {
  none,
  low,
  normal,
  high,
}

enum NotificationStatus {
  pending,
  processing,
  delivered,
  failed,
}

enum NotificationChannel {
  email,
  push,
  sms,
  webhook,
}

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
  final NotificationChannel channel;
  final NotificationStatus status;
  final NotificationPriority priority;
  final String correlationId;
  final NotificationMessageType messageType;
  final NotificationMessage message;
  final bool read;
  final DateTime createdAt;
  final DateTime updatedAt;

  // This is fine.
  NotificationModel({
    required this.id,
    required this.status,
    required this.priority,
    required this.messageType,
    required this.correlationId,
    required this.channel,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    // First, do the basic conversion.
    var json = {...data};

    //? If this has any data here....
    if (data["message"]?["data"] != null) {
      final messageData = data["message"]!["data"] as Map<String, dynamic>;

      // Retrieve each key.
      for (final key in messageData.keys) {
        json["message"]["body"] = json["message"]["body"].toString().replaceAll("{{$key}}", messageData[key]);
      }
    }

    // Next, return this as is.
    return _$NotificationModelFromJson(json);
  }

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
