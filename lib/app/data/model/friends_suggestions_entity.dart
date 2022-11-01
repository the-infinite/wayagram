import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/friends_suggestions_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class FriendsSuggestionsEntity {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	String? avatar;
	String? coverImage;
	String? bio;
	double? notificationCount;
	double? posts;
	double? groupCount;
	double? pageCount;
	double? followings;
	double? followers;
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
	FriendsSuggestionsConnection? connection;
  
  FriendsSuggestionsEntity();

  factory FriendsSuggestionsEntity.fromJson(Map<String, dynamic> json) => $FriendsSuggestionsEntityFromJson(json);

  Map<String, dynamic> toJson() => $FriendsSuggestionsEntityToJson(this);

	static List<FriendsSuggestionsEntity> getService(List<dynamic> val) {
		return val.map((e) => FriendsSuggestionsEntity.fromJson(e)).toList();
	}

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FriendsSuggestionsConnection {


  
  FriendsSuggestionsConnection();

  factory FriendsSuggestionsConnection.fromJson(Map<String, dynamic> json) => $FriendsSuggestionsConnectionFromJson(json);

  Map<String, dynamic> toJson() => $FriendsSuggestionsConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}