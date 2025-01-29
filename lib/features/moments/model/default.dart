import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

part 'default.g.dart';

@JsonEnum()
enum UpdateType {
  text,
  video,
  audio,
  photo,
}

@JsonSerializable()
class StatusUpdateModel {
  final String id;
  final String userId;
  final User? user;
  final UpdateType type;
  final String mood;
  final String content;
  final DateTime createdAt;
  final DateTime expiresAt;

  // Construct.
  const StatusUpdateModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.expiresAt,
    required this.type,
    required this.mood,
    required this.content,
    this.user,
  });

  // This is fine.
  factory StatusUpdateModel.fromJson(Map<String, dynamic> json) => _$StatusUpdateModelFromJson(json);

  // This is fine.
  Map<String, dynamic> toJson() => _$StatusUpdateModelToJson(this);

  /// A very lazy way of adding the user of a status update to the status update.
  /// Only really useful in contexts where the user is not assigned at the startup
  /// time.
  StatusUpdateModel bindUser({User? user}) {
    return StatusUpdateModel(
      id: id,
      userId: userId,
      createdAt: createdAt,
      expiresAt: expiresAt,
      user: user,
      type: type,
      mood: mood,
      content: content,
    );
  }
}
