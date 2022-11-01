import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/followers_model_entity.dart';

FollowersModelEntity $FollowersModelEntityFromJson(Map<String, dynamic> json) {
	final FollowersModelEntity followersModelEntity = FollowersModelEntity();
	final int? count = jsonConvert.convert<int>(json['count']);
	if (count != null) {
		followersModelEntity.count = count;
	}
	final List<FollowersModelFollowers>? followers = jsonConvert.convertListNotNull<FollowersModelFollowers>(json['followers']);
	if (followers != null) {
		followersModelEntity.followers = followers;
	}
	return followersModelEntity;
}

Map<String, dynamic> $FollowersModelEntityToJson(FollowersModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['count'] = entity.count;
	data['followers'] =  entity.followers?.map((v) => v.toJson()).toList();
	return data;
}

FollowersModelFollowers $FollowersModelFollowersFromJson(Map<String, dynamic> json) {
	final FollowersModelFollowers followersModelFollowers = FollowersModelFollowers();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		followersModelFollowers.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		followersModelFollowers.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		followersModelFollowers.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		followersModelFollowers.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		followersModelFollowers.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		followersModelFollowers.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		followersModelFollowers.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		followersModelFollowers.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		followersModelFollowers.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		followersModelFollowers.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		followersModelFollowers.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		followersModelFollowers.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		followersModelFollowers.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		followersModelFollowers.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		followersModelFollowers.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		followersModelFollowers.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		followersModelFollowers.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		followersModelFollowers.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		followersModelFollowers.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		followersModelFollowers.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		followersModelFollowers.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		followersModelFollowers.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		followersModelFollowers.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		followersModelFollowers.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		followersModelFollowers.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		followersModelFollowers.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		followersModelFollowers.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		followersModelFollowers.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		followersModelFollowers.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		followersModelFollowers.updatedAt = updatedAt;
	}
	final FollowersModelFollowersConnection? connection = jsonConvert.convert<FollowersModelFollowersConnection>(json['connection']);
	if (connection != null) {
		followersModelFollowers.connection = connection;
	}
	return followersModelFollowers;
}

Map<String, dynamic> $FollowersModelFollowersToJson(FollowersModelFollowers entity) {
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

FollowersModelFollowersConnection $FollowersModelFollowersConnectionFromJson(Map<String, dynamic> json) {
	final FollowersModelFollowersConnection followersModelFollowersConnection = FollowersModelFollowersConnection();
	final bool? connected = jsonConvert.convert<bool>(json['connected']);
	if (connected != null) {
		followersModelFollowersConnection.connected = connected;
	}
	final bool? isAccepted = jsonConvert.convert<bool>(json['isAccepted']);
	if (isAccepted != null) {
		followersModelFollowersConnection.isAccepted = isAccepted;
	}
	final bool? isPending = jsonConvert.convert<bool>(json['isPending']);
	if (isPending != null) {
		followersModelFollowersConnection.isPending = isPending;
	}
	final bool? isDeclined = jsonConvert.convert<bool>(json['isDeclined']);
	if (isDeclined != null) {
		followersModelFollowersConnection.isDeclined = isDeclined;
	}
	final bool? following = jsonConvert.convert<bool>(json['following']);
	if (following != null) {
		followersModelFollowersConnection.following = following;
	}
	final bool? followsYou = jsonConvert.convert<bool>(json['followsYou']);
	if (followsYou != null) {
		followersModelFollowersConnection.followsYou = followsYou;
	}
	return followersModelFollowersConnection;
}

Map<String, dynamic> $FollowersModelFollowersConnectionToJson(FollowersModelFollowersConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['connected'] = entity.connected;
	data['isAccepted'] = entity.isAccepted;
	data['isPending'] = entity.isPending;
	data['isDeclined'] = entity.isDeclined;
	data['following'] = entity.following;
	data['followsYou'] = entity.followsYou;
	return data;
}