import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

@JsonSerializable()
class NotificationTarget {
  final String? email;
  final String? token;
  final String? topic;

  // This is fine.
  NotificationTarget({
    required this.email,
    required this.token,
    required this.topic,
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
  final String messageType;
  final NotificationTarget target;
  final NotificationMessage message;
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
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data) => _$NotificationModelFromJson(data);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
