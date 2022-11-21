import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/following_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class FollowingModelEntity {

	int? count;
	List<FollowingModelFollowing>? following;
  
  FollowingModelEntity();

  factory FollowingModelEntity.fromJson(Map<String, dynamic> json) => $FollowingModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $FollowingModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FollowingModelFollowing {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	String? avatar;
	String? coverImage;
	String? bio;
	int? notificationCount;
	int? posts;
	int? groupCount;
	int? pageCount;
	int? followings;
	int? followers;
	String? username;
	String? displayName;
	bool? notPublic;
	bool? deleted;
	bool? simulatedUser;
	bool? isMuted;
	bool? isBan;
	bool? isDisabled;
	bool? isDeactivate;
	String? theme;
	String? fontSize;
	String? phone;
	String? email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	FollowingModelFollowingConnection? connection;
  
  FollowingModelFollowing();

  factory FollowingModelFollowing.fromJson(Map<String, dynamic> json) => $FollowingModelFollowingFromJson(json);

  Map<String, dynamic> toJson() => $FollowingModelFollowingToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

	@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowingModelFollowing &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

@JsonSerializable()
class FollowingModelFollowingConnection {

	bool? connected;
	bool? isAccepted;
	bool? isPending;
	bool? isDeclined;
	bool? following;
	bool? followsYou;
  
  FollowingModelFollowingConnection();

  factory FollowingModelFollowingConnection.fromJson(Map<String, dynamic> json) => $FollowingModelFollowingConnectionFromJson(json);

  Map<String, dynamic> toJson() => $FollowingModelFollowingConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}