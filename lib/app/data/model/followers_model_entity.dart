import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/followers_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class FollowersModelEntity {

	int? count;
	List<FollowersModelFollowers>? followers;
  
  FollowersModelEntity();

  factory FollowersModelEntity.fromJson(Map<String, dynamic> json) => $FollowersModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $FollowersModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FollowersModelFollowers {

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
	FollowersModelFollowersConnection? connection;
  
  FollowersModelFollowers();

  factory FollowersModelFollowers.fromJson(Map<String, dynamic> json) => $FollowersModelFollowersFromJson(json);

  Map<String, dynamic> toJson() => $FollowersModelFollowersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FollowersModelFollowersConnection {

	bool? connected;
	bool? isAccepted;
	bool? isPending;
	bool? isDeclined;
	bool? following;
	bool? followsYou;
  
  FollowersModelFollowersConnection();

  factory FollowersModelFollowersConnection.fromJson(Map<String, dynamic> json) => $FollowersModelFollowersConnectionFromJson(json);

  Map<String, dynamic> toJson() => $FollowersModelFollowersConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}