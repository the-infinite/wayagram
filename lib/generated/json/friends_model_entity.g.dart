import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/friends_model_entity.dart';

FriendsModelEntity $FriendsModelEntityFromJson(Map<String, dynamic> json) {
	final FriendsModelEntity friendsModelEntity = FriendsModelEntity();
	final int? following = jsonConvert.convert<int>(json['following']);
	if (following != null) {
		friendsModelEntity.following = following;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		friendsModelEntity.followers = followers;
	}
	final List<FriendsModelFriends>? friends = jsonConvert.convertListNotNull<FriendsModelFriends>(json['friends']);
	if (friends != null) {
		friendsModelEntity.friends = friends;
	}
	return friendsModelEntity;
}

Map<String, dynamic> $FriendsModelEntityToJson(FriendsModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['following'] = entity.following;
	data['followers'] = entity.followers;
	data['friends'] =  entity.friends?.map((v) => v.toJson()).toList();
	return data;
}

FriendsModelFriends $FriendsModelFriendsFromJson(Map<String, dynamic> json) {
	final FriendsModelFriends friendsModelFriends = FriendsModelFriends();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		friendsModelFriends.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		friendsModelFriends.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		friendsModelFriends.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		friendsModelFriends.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		friendsModelFriends.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		friendsModelFriends.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		friendsModelFriends.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		friendsModelFriends.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		friendsModelFriends.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		friendsModelFriends.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		friendsModelFriends.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		friendsModelFriends.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		friendsModelFriends.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		friendsModelFriends.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		friendsModelFriends.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		friendsModelFriends.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		friendsModelFriends.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		friendsModelFriends.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		friendsModelFriends.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		friendsModelFriends.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		friendsModelFriends.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		friendsModelFriends.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		friendsModelFriends.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		friendsModelFriends.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		friendsModelFriends.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		friendsModelFriends.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		friendsModelFriends.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		friendsModelFriends.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		friendsModelFriends.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		friendsModelFriends.updatedAt = updatedAt;
	}
	final FriendsModelFriendsConnection? connection = jsonConvert.convert<FriendsModelFriendsConnection>(json['connection']);
	if (connection != null) {
		friendsModelFriends.connection = connection;
	}
	return friendsModelFriends;
}

Map<String, dynamic> $FriendsModelFriendsToJson(FriendsModelFriends entity) {
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

FriendsModelFriendsConnection $FriendsModelFriendsConnectionFromJson(Map<String, dynamic> json) {
	final FriendsModelFriendsConnection friendsModelFriendsConnection = FriendsModelFriendsConnection();
	return friendsModelFriendsConnection;
}

Map<String, dynamic> $FriendsModelFriendsConnectionToJson(FriendsModelFriendsConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}