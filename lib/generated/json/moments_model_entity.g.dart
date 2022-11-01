import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/moments_model_entity.dart';

MomentsModelEntity $MomentsModelEntityFromJson(Map<String, dynamic> json) {
	final MomentsModelEntity momentsModelEntity = MomentsModelEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		momentsModelEntity.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		momentsModelEntity.profileId = profileId;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		momentsModelEntity.type = type;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		momentsModelEntity.content = content;
	}
	final dynamic? text = jsonConvert.convert<dynamic>(json['text']);
	if (text != null) {
		momentsModelEntity.text = text;
	}
	final String? image = jsonConvert.convert<String>(json['image']);
	if (image != null) {
		momentsModelEntity.image = image;
	}
	final String? userAvatar = jsonConvert.convert<String>(json['userAvatar']);
	if (userAvatar != null) {
		momentsModelEntity.userAvatar = userAvatar;
	}
	final String? userName = jsonConvert.convert<String>(json['userName']);
	if (userName != null) {
		momentsModelEntity.userName = userName;
	}
	final int? viewCount = jsonConvert.convert<int>(json['viewCount']);
	if (viewCount != null) {
		momentsModelEntity.viewCount = viewCount;
	}
	final bool? isExpire = jsonConvert.convert<bool>(json['isExpire']);
	if (isExpire != null) {
		momentsModelEntity.isExpire = isExpire;
	}
	final String? next24Hours = jsonConvert.convert<String>(json['next_24_hours']);
	if (next24Hours != null) {
		momentsModelEntity.next24Hours = next24Hours;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		momentsModelEntity.millisecCreatedAt = millisecCreatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		momentsModelEntity.sV = sV;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		momentsModelEntity.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		momentsModelEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		momentsModelEntity.updatedAt = updatedAt;
	}
	final MomentsModelProfile? profile = jsonConvert.convert<MomentsModelProfile>(json['Profile']);
	if (profile != null) {
		momentsModelEntity.profile = profile;
	}
	return momentsModelEntity;
}

Map<String, dynamic> $MomentsModelEntityToJson(MomentsModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['type'] = entity.type;
	data['content'] = entity.content;
	data['text'] = entity.text;
	data['image'] = entity.image;
	data['userAvatar'] = entity.userAvatar;
	data['userName'] = entity.userName;
	data['viewCount'] = entity.viewCount;
	data['isExpire'] = entity.isExpire;
	data['next_24_hours'] = entity.next24Hours;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['_v'] = entity.sV;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['Profile'] = entity.profile?.toJson();
	return data;
}

MomentsModelProfile $MomentsModelProfileFromJson(Map<String, dynamic> json) {
	final MomentsModelProfile momentsModelProfile = MomentsModelProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		momentsModelProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		momentsModelProfile.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		momentsModelProfile.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		momentsModelProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		momentsModelProfile.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		momentsModelProfile.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		momentsModelProfile.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		momentsModelProfile.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		momentsModelProfile.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		momentsModelProfile.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		momentsModelProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		momentsModelProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		momentsModelProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		momentsModelProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		momentsModelProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		momentsModelProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		momentsModelProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		momentsModelProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		momentsModelProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		momentsModelProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		momentsModelProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		momentsModelProfile.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		momentsModelProfile.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		momentsModelProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		momentsModelProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		momentsModelProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		momentsModelProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		momentsModelProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		momentsModelProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		momentsModelProfile.updatedAt = updatedAt;
	}
	final MomentsModelProfileConnection? connection = jsonConvert.convert<MomentsModelProfileConnection>(json['connection']);
	if (connection != null) {
		momentsModelProfile.connection = connection;
	}
	return momentsModelProfile;
}

Map<String, dynamic> $MomentsModelProfileToJson(MomentsModelProfile entity) {
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

MomentsModelProfileConnection $MomentsModelProfileConnectionFromJson(Map<String, dynamic> json) {
	final MomentsModelProfileConnection momentsModelProfileConnection = MomentsModelProfileConnection();
	return momentsModelProfileConnection;
}

Map<String, dynamic> $MomentsModelProfileConnectionToJson(MomentsModelProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}