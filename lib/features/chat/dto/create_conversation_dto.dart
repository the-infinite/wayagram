import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/default.dart';

part 'create_conversation_dto.g.dart';

@JsonSerializable()
class CreateConversationDto {
  final String createdBy;
  final List<String> otherUsers;
  final ChatType chatType;

  CreateConversationDto({
    required this.createdBy,
    required this.otherUsers,
    required this.chatType,
  });

  // From JSON constructor
  factory CreateConversationDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationDtoFromJson(json);

  // To JSON method
  Map<String, dynamic> toJson() => _$CreateConversationDtoToJson(this);
}

@JsonSerializable()
class PrivacySettingsDto {
  final bool? canSeeOnlineStatus;
  final bool? canSeeLastSeen;
  @JsonKey(name: 'canSeeReadReeceipt')
  final bool? canSeeReadReceipt;
  final bool? canSeeProfilePicture;
  final bool? canSeeProfileDescription;
  final bool? everyoneCanContactMe;

  PrivacySettingsDto({
    required this.canSeeOnlineStatus,
    required this.canSeeLastSeen,
    required this.canSeeReadReceipt,
    required this.canSeeProfilePicture,
    required this.canSeeProfileDescription,
    required this.everyoneCanContactMe,
  });

  // From JSON constructor
  factory PrivacySettingsDto.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsDtoFromJson(json);

  // To JSON method
  Map<String, dynamic> toJson() => _$PrivacySettingsDtoToJson(this);
}
