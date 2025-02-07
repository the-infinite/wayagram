import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

part 'member.g.dart';

@JsonSerializable()
class ChatMember {
  final String id;
  final String chatId;
  final String userId;
  final bool isDeletedChat;
  final bool isArchived;
  final bool isPined;
  final DateTime joinedAt;
  final UserDetailsModel? user;

  ChatMember({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.isDeletedChat,
    required this.isArchived,
    required this.isPined,
    required this.joinedAt,
    required this.user,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) => _$ChatMemberFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMemberToJson(this);
}
