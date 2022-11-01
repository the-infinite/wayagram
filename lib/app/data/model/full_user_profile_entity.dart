import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/full_user_profile_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class FullUserProfileEntity {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	dynamic avatar;
	dynamic coverImage;
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
	FullUserProfileConnection? connection;
  
  FullUserProfileEntity();

  factory FullUserProfileEntity.fromJson(Map<String, dynamic> json) => $FullUserProfileEntityFromJson(json);

  Map<String, dynamic> toJson() => $FullUserProfileEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FullUserProfileConnection {

	bool? connected;
	bool? isAccepted;
	bool? isPending;
	bool? isDeclined;
	bool? muted;
	bool? blocked;
	bool? following;
	bool? followsYou;
  
  FullUserProfileConnection();

  factory FullUserProfileConnection.fromJson(Map<String, dynamic> json) => $FullUserProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $FullUserProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}