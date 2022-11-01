import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/notification_model_entity.dart';

NotificationModelEntity $NotificationModelEntityFromJson(Map<String, dynamic> json) {
	final NotificationModelEntity notificationModelEntity = NotificationModelEntity();
	final List<NotificationModelData>? data = jsonConvert.convertListNotNull<NotificationModelData>(json['data']);
	if (data != null) {
		notificationModelEntity.data = data;
	}
	final NotificationModelMetadata? metadata = jsonConvert.convert<NotificationModelMetadata>(json['metadata']);
	if (metadata != null) {
		notificationModelEntity.metadata = metadata;
	}
	return notificationModelEntity;
}

Map<String, dynamic> $NotificationModelEntityToJson(NotificationModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] =  entity.data?.map((v) => v.toJson()).toList();
	data['metadata'] = entity.metadata?.toJson();
	return data;
}

NotificationModelData $NotificationModelDataFromJson(Map<String, dynamic> json) {
	final NotificationModelData notificationModelData = NotificationModelData();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		notificationModelData.id = id;
	}
	final String? patronId = jsonConvert.convert<String>(json['PatronId']);
	if (patronId != null) {
		notificationModelData.patronId = patronId;
	}
	final String? recipientId = jsonConvert.convert<String>(json['RecipientId']);
	if (recipientId != null) {
		notificationModelData.recipientId = recipientId;
	}
	final String? itemId = jsonConvert.convert<String>(json['ItemId']);
	if (itemId != null) {
		notificationModelData.itemId = itemId;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		notificationModelData.type = type;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		notificationModelData.title = title;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		notificationModelData.content = content;
	}
	final String? millisec = jsonConvert.convert<String>(json['millisec']);
	if (millisec != null) {
		notificationModelData.millisec = millisec;
	}
	final bool? deliveredByLog = jsonConvert.convert<bool>(json['delivered_by_log']);
	if (deliveredByLog != null) {
		notificationModelData.deliveredByLog = deliveredByLog;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		notificationModelData.sV = sV;
	}
	final bool? deliveredByPush = jsonConvert.convert<bool>(json['delivered_by_push']);
	if (deliveredByPush != null) {
		notificationModelData.deliveredByPush = deliveredByPush;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		notificationModelData.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		notificationModelData.updatedAt = updatedAt;
	}
	final NotificationModelDataProfile? profile = jsonConvert.convert<NotificationModelDataProfile>(json['Profile']);
	if (profile != null) {
		notificationModelData.profile = profile;
	}
	return notificationModelData;
}

Map<String, dynamic> $NotificationModelDataToJson(NotificationModelData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['PatronId'] = entity.patronId;
	data['RecipientId'] = entity.recipientId;
	data['ItemId'] = entity.itemId;
	data['type'] = entity.type;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['millisec'] = entity.millisec;
	data['delivered_by_log'] = entity.deliveredByLog;
	data['_v'] = entity.sV;
	data['delivered_by_push'] = entity.deliveredByPush;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['Profile'] = entity.profile?.toJson();
	return data;
}

NotificationModelDataProfile $NotificationModelDataProfileFromJson(Map<String, dynamic> json) {
	final NotificationModelDataProfile notificationModelDataProfile = NotificationModelDataProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		notificationModelDataProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		notificationModelDataProfile.userId = userId;
	}
	final dynamic? avatar = jsonConvert.convert<dynamic>(json['avatar']);
	if (avatar != null) {
		notificationModelDataProfile.avatar = avatar;
	}
	final dynamic? coverImage = jsonConvert.convert<dynamic>(json['coverImage']);
	if (coverImage != null) {
		notificationModelDataProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		notificationModelDataProfile.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		notificationModelDataProfile.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		notificationModelDataProfile.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		notificationModelDataProfile.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		notificationModelDataProfile.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		notificationModelDataProfile.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		notificationModelDataProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		notificationModelDataProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		notificationModelDataProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		notificationModelDataProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		notificationModelDataProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		notificationModelDataProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		notificationModelDataProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		notificationModelDataProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		notificationModelDataProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		notificationModelDataProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		notificationModelDataProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		notificationModelDataProfile.fontSize = fontSize;
	}
	final dynamic? phone = jsonConvert.convert<dynamic>(json['phone']);
	if (phone != null) {
		notificationModelDataProfile.phone = phone;
	}
	final dynamic? email = jsonConvert.convert<dynamic>(json['email']);
	if (email != null) {
		notificationModelDataProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		notificationModelDataProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		notificationModelDataProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		notificationModelDataProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		notificationModelDataProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		notificationModelDataProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		notificationModelDataProfile.updatedAt = updatedAt;
	}
	final NotificationModelDataProfileConnection? connection = jsonConvert.convert<NotificationModelDataProfileConnection>(json['connection']);
	if (connection != null) {
		notificationModelDataProfile.connection = connection;
	}
	return notificationModelDataProfile;
}

Map<String, dynamic> $NotificationModelDataProfileToJson(NotificationModelDataProfile entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['UserId'] = entity.userId;
	data['avatar'] = entity.avatar;
	data['coverImage'] = entity.coverImage;
	data['bio'] = entity.bio;
	data['notificationCount'] = entity.notificationCount;
	data['posts'] = entity.posts;
	data['groupCount'] = entity.groupCount;
	data['pageCount'] = entity.pageCount;
	data['followings'] = entity.followings;
	data['followers'] = entity.followers;
	data['username'] = entity.username;
	data['displayName'] = entity.displayName;
	data['notPublic'] = entity.notPublic;
	data['deleted'] = entity.deleted;
	data['simulatedUser'] = entity.simulatedUser;
	data['isMuted'] = entity.isMuted;
	data['isBan'] = entity.isBan;
	data['isDisabled'] = entity.isDisabled;
	data['isDeactivate'] = entity.isDeactivate;
	data['theme'] = entity.theme;
	data['fontSize'] = entity.fontSize;
	data['phone'] = entity.phone;
	data['email'] = entity.email;
	data['style'] = entity.style;
	data['stream_key'] = entity.streamKey;
	data['roleId'] = entity.roleId;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['connection'] = entity.connection?.toJson();
	return data;
}

NotificationModelDataProfileConnection $NotificationModelDataProfileConnectionFromJson(Map<String, dynamic> json) {
	final NotificationModelDataProfileConnection notificationModelDataProfileConnection = NotificationModelDataProfileConnection();
	return notificationModelDataProfileConnection;
}

Map<String, dynamic> $NotificationModelDataProfileConnectionToJson(NotificationModelDataProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}

NotificationModelMetadata $NotificationModelMetadataFromJson(Map<String, dynamic> json) {
	final NotificationModelMetadata notificationModelMetadata = NotificationModelMetadata();
	final dynamic? previousPage = jsonConvert.convert<dynamic>(json['previousPage']);
	if (previousPage != null) {
		notificationModelMetadata.previousPage = previousPage;
	}
	final int? currentPage = jsonConvert.convert<int>(json['currentPage']);
	if (currentPage != null) {
		notificationModelMetadata.currentPage = currentPage;
	}
	final dynamic? nextPage = jsonConvert.convert<dynamic>(json['nextPage']);
	if (nextPage != null) {
		notificationModelMetadata.nextPage = nextPage;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		notificationModelMetadata.total = total;
	}
	final int? limit = jsonConvert.convert<int>(json['limit']);
	if (limit != null) {
		notificationModelMetadata.limit = limit;
	}
	return notificationModelMetadata;
}

Map<String, dynamic> $NotificationModelMetadataToJson(NotificationModelMetadata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['previousPage'] = entity.previousPage;
	data['currentPage'] = entity.currentPage;
	data['nextPage'] = entity.nextPage;
	data['total'] = entity.total;
	data['limit'] = entity.limit;
	return data;
}