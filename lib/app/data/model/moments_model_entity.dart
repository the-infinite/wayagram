import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/moments_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MomentsModelEntity {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	String? type;
	String? content;
	dynamic text;
	String? image;
	String? userAvatar;
	String? userName;
	int? viewCount;
	bool? isExpire;
	@JSONField(name: "next_24_hours")
	String? next24Hours;
	String? millisecCreatedAt;
	@JSONField(name: "_v")
	String? sV;
	String? millisecUpdatedAt;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "Profile")
	MomentsModelProfile? profile;
  
  MomentsModelEntity();

  factory MomentsModelEntity.fromJson(Map<String, dynamic> json) => $MomentsModelEntityFromJson(json);

	static List<MomentsModelEntity> getService(List<dynamic> val) {
		return val.map((e) => MomentsModelEntity.fromJson(e)).toList();
	}

  Map<String, dynamic> toJson() => $MomentsModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MomentsModelProfile {

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
	MomentsModelProfileConnection? connection;
  
  MomentsModelProfile();

  factory MomentsModelProfile.fromJson(Map<String, dynamic> json) => $MomentsModelProfileFromJson(json);

  Map<String, dynamic> toJson() => $MomentsModelProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MomentsModelProfileConnection {


  
  MomentsModelProfileConnection();

  factory MomentsModelProfileConnection.fromJson(Map<String, dynamic> json) => $MomentsModelProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $MomentsModelProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}