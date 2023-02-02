import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/notification_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class NotificationModelEntity {

	List<NotificationModelData>? data;
	NotificationModelMetadata? metadata;
  
  NotificationModelEntity();

  factory NotificationModelEntity.fromJson(Map<String, dynamic> json) => $NotificationModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $NotificationModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NotificationModelData {
	String? id;
	@JSONField(name: "PatronId")
	String? patronId;
	@JSONField(name: "RecipientId")
	String? recipientId;
	@JSONField(name: "ItemId")
	String? itemId;
	String? type;
	String? title;
	String? content;
	String? millisec;
	@JSONField(name: "delivered_by_log")
	bool? deliveredByLog;
	@JSONField(name: "_v")
	String? sV;
	@JSONField(name: "delivered_by_push")
	bool? deliveredByPush;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "Profile")
	NotificationModelDataProfile? profile;
  
  NotificationModelData();

  factory NotificationModelData.fromJson(Map<String, dynamic> json) => $NotificationModelDataFromJson(json);

  Map<String, dynamic> toJson() => $NotificationModelDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NotificationModelDataProfile {
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
	NotificationModelDataProfileConnection? connection;
  
  NotificationModelDataProfile();

  factory NotificationModelDataProfile.fromJson(Map<String, dynamic> json) => $NotificationModelDataProfileFromJson(json);

  Map<String, dynamic> toJson() => $NotificationModelDataProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NotificationModelDataProfileConnection {
  NotificationModelDataProfileConnection();

  factory NotificationModelDataProfileConnection.fromJson(Map<String, dynamic> json) => $NotificationModelDataProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $NotificationModelDataProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NotificationModelMetadata {

	dynamic previousPage;
	int? currentPage;
	dynamic nextPage;
	int? total;
	int? limit;
  
  NotificationModelMetadata();

  factory NotificationModelMetadata.fromJson(Map<String, dynamic> json) => $NotificationModelMetadataFromJson(json);

  Map<String, dynamic> toJson() => $NotificationModelMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}