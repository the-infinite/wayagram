import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

enum FollowRelationship {
  accepted,
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
