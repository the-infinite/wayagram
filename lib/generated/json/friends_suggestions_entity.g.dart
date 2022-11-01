import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/friends_suggestions_entity.dart';

FriendsSuggestionsEntity $FriendsSuggestionsEntityFromJson(Map<String, dynamic> json) {
	final FriendsSuggestionsEntity friendsSuggestionsEntity = FriendsSuggestionsEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		friendsSuggestionsEntity.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		friendsSuggestionsEntity.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		friendsSuggestionsEntity.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		friendsSuggestionsEntity.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		friendsSuggestionsEntity.bio = bio;
	}
	final double? notificationCount = jsonConvert.convert<double>(json['notificationCount']);
	if (notificationCount != null) {
		friendsSuggestionsEntity.notificationCount = notificationCount;
	}
	final double? posts = jsonConvert.convert<double>(json['posts']);
	if (posts != null) {
		friendsSuggestionsEntity.posts = posts;
	}
	final double? groupCount = jsonConvert.convert<double>(json['groupCount']);
	if (groupCount != null) {
		friendsSuggestionsEntity.groupCount = groupCount;
	}
	final double? pageCount = jsonConvert.convert<double>(json['pageCount']);
	if (pageCount != null) {
		friendsSuggestionsEntity.pageCount = pageCount;
	}
	final double? followings = jsonConvert.convert<double>(json['followings']);
	if (followings != null) {
		friendsSuggestionsEntity.followings = followings;
	}
	final double? followers = jsonConvert.convert<double>(json['followers']);
	if (followers != null) {
		friendsSuggestionsEntity.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		friendsSuggestionsEntity.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		friendsSuggestionsEntity.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		friendsSuggestionsEntity.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		friendsSuggestionsEntity.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		friendsSuggestionsEntity.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		friendsSuggestionsEntity.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		friendsSuggestionsEntity.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		friendsSuggestionsEntity.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		friendsSuggestionsEntity.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		friendsSuggestionsEntity.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		friendsSuggestionsEntity.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		friendsSuggestionsEntity.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		friendsSuggestionsEntity.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		friendsSuggestionsEntity.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		friendsSuggestionsEntity.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		friendsSuggestionsEntity.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		friendsSuggestionsEntity.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		friendsSuggestionsEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		friendsSuggestionsEntity.updatedAt = updatedAt;
	}
	final FriendsSuggestionsConnection? connection = jsonConvert.convert<FriendsSuggestionsConnection>(json['connection']);
	if (connection != null) {
		friendsSuggestionsEntity.connection = connection;
	}
	return friendsSuggestionsEntity;
}

Map<String, dynamic> $FriendsSuggestionsEntityToJson(FriendsSuggestionsEntity entity) {
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

FriendsSuggestionsConnection $FriendsSuggestionsConnectionFromJson(Map<String, dynamic> json) {
	final FriendsSuggestionsConnection friendsSuggestionsConnection = FriendsSuggestionsConnection();
	return friendsSuggestionsConnection;
}

Map<String, dynamic> $FriendsSuggestionsConnectionToJson(FriendsSuggestionsConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}