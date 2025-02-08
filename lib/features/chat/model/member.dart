import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

part 'member.g.dart';

enum ChatUserActivity {
  online,
  offline;
}

@JsonSerializable()
class ChatUser {
  final String id;
  final String userId;
  final ChatUserActivity onlineStatus;
  final DateTime lastSeen;
  final bool isChatOpen;
  final String? avatar;
  final String? coverImage;
  final String? bio;
  final String username;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatUser({
    required this.id,
    required this.userId,
    required this.onlineStatus,
    required this.lastSeen,
    required this.isChatOpen,
    required this.username,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    this.coverImage,
    this.bio,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}

@JsonSerializable()
class ChatMember {
  final String id;
  final String chatId;
  final String userId;
  final bool isDeletedChat;
  final bool isArchived;
  final bool isPined;
  final DateTime joinedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatUser? chatUser;
  final UserDetailsModel? userData;
  final SocialProfileModel? profileData;

  ChatMember({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.isDeletedChat,
    required this.isArchived,
    required this.isPined,
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.chatUser,
    this.profileData,
    this.userData,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) => _$ChatMemberFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMemberToJson(this);

  ChatMember copyWith(UserDetailsModel user, SocialProfileModel profile) {
    return ChatMember(
      id: id,
      chatId: chatId,
      userId: userId,
      isDeletedChat: isDeletedChat,
      isArchived: isArchived,
      isPined: isPined,
      joinedAt: joinedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      chatUser: chatUser,
      userData: user,
      profileData: profile,
    );
  }
}
