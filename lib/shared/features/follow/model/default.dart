import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

part 'default.g.dart';

@JsonEnum()
enum FollowRelationship {
  accepted,
  none,
  pending,
  rejected,
}

@JsonEnum()
enum FollowAction {
  accept._("accept"),
  reject._("reject");

  final String value;
  const FollowAction._(this.value);
}

@JsonSerializable()
class FollowModel {
  final String id;
  final String followerId;
  final String followingId;
  final bool followedBack;
  final FollowRelationship status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowModel({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.followedBack,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$FollowModelToJson(this);

  factory FollowModel.fromJson(Map<String, dynamic> json) => _$FollowModelFromJson(json);

  ///
  bool get isOtherFollowingMe {
    return (followerId == ConversationState.self.id && followedBack) || followingId == ConversationState.self.id;
  }

  ///
  bool get isUserFollowing {
    return followerId == ConversationState.self.id || (followingId == ConversationState.self.id && followedBack);
  }

  /// Helper function used to get the user ID of the person in this follower following relationship that is not the user in question.
  String get otherUserId => otherFollowerId(ConversationState.self.id);

  /// Helper function used to get the user ID of the person in this relationship
  /// that is not the person calling it.
  Future<CachedUserDataTuple?> followerData(String userId) => UserResource.getUserDetails(otherFollowerId(userId));

  /// Helper function used to get the user ID of the person who is not the user
  /// in focus when making this request.
  String otherFollowerId(String userId) => followerId == userId ? followingId : followerId;

  /// Helper function used to get the user ID of the person in this relationship
  /// that is not the logged in user.
  Future<CachedUserDataTuple?> getOtherUser() => followerData(ConversationState.self.id);
}

@JsonSerializable()
class FollowStatusModel {
  final bool isFollowedBy;
  final bool isFollowing;
  final bool isMutual;
  final FollowRelationship status;

  FollowStatusModel({
    required this.isFollowedBy,
    required this.isFollowing,
    required this.isMutual,
    required this.status,
  });

  Map<String, dynamic> toJson() => _$FollowStatusModelToJson(this);

  factory FollowStatusModel.fromJson(Map<String, dynamic> json) => _$FollowStatusModelFromJson(json);

  bool get isOtherFollowingMe => (isFollowing && isMutual) || isFollowedBy;

  bool get isUserFollowing => isFollowing || (isFollowedBy && isMutual);
}

@JsonSerializable()
class UserSettingsDto {
  final bool? showPeopleFollowMe;
  final bool? showPeopleFollowing;
  final bool? restrictRequestToPeopleFollow;

  // Construct.
  UserSettingsDto({
    required this.showPeopleFollowMe,
    required this.showPeopleFollowing,
    required this.restrictRequestToPeopleFollow,
  });

  // From JSON constructor
  factory UserSettingsDto.fromJson(Map<String, dynamic> json) => _$UserSettingsDtoFromJson(json);

  // To JSON method
  Map<String, dynamic> toJson() => _$UserSettingsDtoToJson(this);
}
