import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/blocked_accounts_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class BlockedAccountsEntity {

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
	dynamic phone;
	dynamic email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	BlockedAccountsConnection? connection;
  
  BlockedAccountsEntity();

  factory BlockedAccountsEntity.fromJson(Map<String, dynamic> json) => $BlockedAccountsEntityFromJson(json);

  Map<String, dynamic> toJson() => $BlockedAccountsEntityToJson(this);

	static List<BlockedAccountsEntity> getService(List<dynamic> val) {
		try {
			return val.map((e) => BlockedAccountsEntity.fromJson(e)).toList();
		} catch(e) {
			return [];
		}
	}

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class BlockedAccountsConnection {


  
  BlockedAccountsConnection();

  factory BlockedAccountsConnection.fromJson(Map<String, dynamic> json) => $BlockedAccountsConnectionFromJson(json);

  Map<String, dynamic> toJson() => $BlockedAccountsConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}