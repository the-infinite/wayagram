import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

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

  factory ChatUser.fromJson(Map<String, dynamic> json) => _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);

  /// Helper function used to get the details of this user if this person is a
  /// normal person.
  Future<CachedUserDataTuple?> get userData => UserResource.getUserDetails(userId);

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
