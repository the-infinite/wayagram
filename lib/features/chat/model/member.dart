import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/shop_resource.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/resource/user_resource.dart';

part 'member.g.dart';

enum ChatUserActivity {
  online,
  offline;
}

enum ChatMemberRole {
  member,
  admin,
  owner,
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
  final bool canSeeOnlineStatus;
  final bool canSeeLastSeen;
  @JsonKey(name: 'canSeeReadReeceipt')
  final bool canSeeReadReceipt;
  final bool canSeeProfilePicture;
  final bool canSeeProfileDescription;
  final bool? isShop;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatUser({
    required this.id,
    required this.userId,
    required this.onlineStatus,
    required this.lastSeen,
    required this.isChatOpen,
    required this.avatar,
    required this.coverImage,
    required this.bio,
    required this.username,
    required this.displayName,
    required this.canSeeOnlineStatus,
    required this.canSeeLastSeen,
    required this.canSeeReadReceipt,
    required this.canSeeProfilePicture,
    required this.canSeeProfileDescription,
    required this.isShop,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);

  /// Helper function used to get the details of this user if this person is a
  /// normal person.
  Future<CachedUserDataTuple?> get userData =>
      UserResource.getUserDetails(userId);

  /// Helper function used to get the details of this user if the person is a in
  /// fact a shop.
  Future<ShopDetailsModel?> get shopData => ShopResource.getShopById(userId);
}

@JsonSerializable()
class ChatMember {
  final String id;
  final String chatId;
  final String userId;
  final bool isDeletedChat;
  final bool isArchived;
  final bool isPined;
  final bool isMuted;
  final DateTime joinedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatUser? chatUser;
  final DateTime? mutedUntil;
  final ChatMemberRole role;
  final bool notificationsEnabled;
  final UserDetailsModel? userData;
  final SocialProfileModel? profileData;

  ChatMember({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.mutedUntil,
    required this.isDeletedChat,
    required this.isArchived,
    required this.isPined,
    required this.isMuted,
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.chatUser,
    required this.role,
    required this.notificationsEnabled,
    this.profileData,
    this.userData,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMemberToJson(this);

  CachedUserDataTuple? get combined => userData == null || profileData == null
      ? null
      : (userData!, profileData!);

  ChatMember copyWith(UserDetailsModel user, SocialProfileModel profile) {
    return ChatMember(
      id: id,
      chatId: chatId,
      userId: userId,
      mutedUntil: mutedUntil,
      isDeletedChat: isDeletedChat,
      isArchived: isArchived,
      isPined: isPined,
      isMuted: isMuted,
      joinedAt: joinedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      chatUser: chatUser,
      notificationsEnabled: notificationsEnabled,
      role: role,
      userData: user,
      profileData: profile,
    );
  }
}
