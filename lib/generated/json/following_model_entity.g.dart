import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/following_model_entity.dart';

FollowingModelEntity $FollowingModelEntityFromJson(Map<String, dynamic> json) {
	final FollowingModelEntity followingModelEntity = FollowingModelEntity();
	final int? count = jsonConvert.convert<int>(json['count']);
	if (count != null) {
		followingModelEntity.count = count;
	}
	final List<FollowingModelFollowing>? following = jsonConvert.convertListNotNull<FollowingModelFollowing>(json['following']);
	if (following != null) {
		followingModelEntity.following = following;
	}
	return followingModelEntity;
}

Map<String, dynamic> $FollowingModelEntityToJson(FollowingModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['count'] = entity.count;
	data['following'] =  entity.following?.map((v) => v.toJson()).toList();
	return data;
}

FollowingModelFollowing $FollowingModelFollowingFromJson(Map<String, dynamic> json) {
	final FollowingModelFollowing followingModelFollowing = FollowingModelFollowing();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		followingModelFollowing.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		followingModelFollowing.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		followingModelFollowing.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		followingModelFollowing.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		followingModelFollowing.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		followingModelFollowing.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		followingModelFollowing.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		followingModelFollowing.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		followingModelFollowing.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		followingModelFollowing.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		followingModelFollowing.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		followingModelFollowing.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		followingModelFollowing.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		followingModelFollowing.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		followingModelFollowing.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		followingModelFollowing.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		followingModelFollowing.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		followingModelFollowing.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		followingModelFollowing.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		followingModelFollowing.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		followingModelFollowing.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		followingModelFollowing.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		followingModelFollowing.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		followingModelFollowing.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		followingModelFollowing.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		followingModelFollowing.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		followingModelFollowing.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		followingModelFollowing.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		followingModelFollowing.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		followingModelFollowing.updatedAt = updatedAt;
	}
	final FollowingModelFollowingConnection? connection = jsonConvert.convert<FollowingModelFollowingConnection>(json['connection']);
	if (connection != null) {
		followingModelFollowing.connection = connection;
	}
	return followingModelFollowing;
}

Map<String, dynamic> $FollowingModelFollowingToJson(FollowingModelFollowing entity) {
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

FollowingModelFollowingConnection $FollowingModelFollowingConnectionFromJson(Map<String, dynamic> json) {
	final FollowingModelFollowingConnection followingModelFollowingConnection = FollowingModelFollowingConnection();
	final bool? connected = jsonConvert.convert<bool>(json['connected']);
	if (connected != null) {
		followingModelFollowingConnection.connected = connected;
	}
	final bool? isAccepted = jsonConvert.convert<bool>(json['isAccepted']);
	if (isAccepted != null) {
		followingModelFollowingConnection.isAccepted = isAccepted;
	}
	final bool? isPending = jsonConvert.convert<bool>(json['isPending']);
	if (isPending != null) {
		followingModelFollowingConnection.isPending = isPending;
	}
	final bool? isDeclined = jsonConvert.convert<bool>(json['isDeclined']);
	if (isDeclined != null) {
		followingModelFollowingConnection.isDeclined = isDeclined;
	}
	final bool? following = jsonConvert.convert<bool>(json['following']);
	if (following != null) {
		followingModelFollowingConnection.following = following;
	}
	final bool? followsYou = jsonConvert.convert<bool>(json['followsYou']);
	if (followsYou != null) {
		followingModelFollowingConnection.followsYou = followsYou;
	}
	return followingModelFollowingConnection;
}

Map<String, dynamic> $FollowingModelFollowingConnectionToJson(FollowingModelFollowingConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['connected'] = entity.connected;
	data['isAccepted'] = entity.isAccepted;
	data['isPending'] = entity.isPending;
	data['isDeclined'] = entity.isDeclined;
	data['following'] = entity.following;
	data['followsYou'] = entity.followsYou;
	return data;
}