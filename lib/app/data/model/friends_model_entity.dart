import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/friends_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class FriendsModelEntity {

	int? following;
	int? followers;
	List<FriendsModelFriends>? friends;
  FriendsModelEntity();

  factory FriendsModelEntity.fromJson(Map<String, dynamic> json) => $FriendsModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $FriendsModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FriendsModelFriends {

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
	FriendsModelFriendsConnection? connection;
  
  FriendsModelFriends();

  factory FriendsModelFriends.fromJson(Map<String, dynamic> json) => $FriendsModelFriendsFromJson(json);

  Map<String, dynamic> toJson() => $FriendsModelFriendsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FriendsModelFriendsConnection {


  
  FriendsModelFriendsConnection();

  factory FriendsModelFriendsConnection.fromJson(Map<String, dynamic> json) => $FriendsModelFriendsConnectionFromJson(json);

  Map<String, dynamic> toJson() => $FriendsModelFriendsConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}