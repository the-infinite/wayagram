import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/default.dart';

part 'default.g.dart';

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
  factory CreateConversationDto.fromJson(Map<String, dynamic> json) => _$CreateConversationDtoFromJson(json);

  // To JSON method
  Map<String, dynamic> toJson() => _$CreateConversationDtoToJson(this);
}
