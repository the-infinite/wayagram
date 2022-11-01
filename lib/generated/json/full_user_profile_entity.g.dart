import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/full_user_profile_entity.dart';

FullUserProfileEntity $FullUserProfileEntityFromJson(Map<String, dynamic> json) {
	final FullUserProfileEntity fullUserProfileEntity = FullUserProfileEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		fullUserProfileEntity.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		fullUserProfileEntity.userId = userId;
	}
	final dynamic? avatar = jsonConvert.convert<dynamic>(json['avatar']);
	if (avatar != null) {
		fullUserProfileEntity.avatar = avatar;
	}
	final dynamic? coverImage = jsonConvert.convert<dynamic>(json['coverImage']);
	if (coverImage != null) {
		fullUserProfileEntity.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		fullUserProfileEntity.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		fullUserProfileEntity.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		fullUserProfileEntity.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		fullUserProfileEntity.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		fullUserProfileEntity.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		fullUserProfileEntity.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		fullUserProfileEntity.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		fullUserProfileEntity.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		fullUserProfileEntity.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		fullUserProfileEntity.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		fullUserProfileEntity.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		fullUserProfileEntity.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		fullUserProfileEntity.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		fullUserProfileEntity.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		fullUserProfileEntity.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		fullUserProfileEntity.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		fullUserProfileEntity.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		fullUserProfileEntity.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		fullUserProfileEntity.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		fullUserProfileEntity.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		fullUserProfileEntity.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		fullUserProfileEntity.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		fullUserProfileEntity.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		fullUserProfileEntity.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		fullUserProfileEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		fullUserProfileEntity.updatedAt = updatedAt;
	}
	final FullUserProfileConnection? connection = jsonConvert.convert<FullUserProfileConnection>(json['connection']);
	if (connection != null) {
		fullUserProfileEntity.connection = connection;
	}
	return fullUserProfileEntity;
}

Map<String, dynamic> $FullUserProfileEntityToJson(FullUserProfileEntity entity) {
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

FullUserProfileConnection $FullUserProfileConnectionFromJson(Map<String, dynamic> json) {
	final FullUserProfileConnection fullUserProfileConnection = FullUserProfileConnection();
	final bool? connected = jsonConvert.convert<bool>(json['connected']);
	if (connected != null) {
		fullUserProfileConnection.connected = connected;
	}
	final bool? isAccepted = jsonConvert.convert<bool>(json['isAccepted']);
	if (isAccepted != null) {
		fullUserProfileConnection.isAccepted = isAccepted;
	}
	final bool? isPending = jsonConvert.convert<bool>(json['isPending']);
	if (isPending != null) {
		fullUserProfileConnection.isPending = isPending;
	}
	final bool? isDeclined = jsonConvert.convert<bool>(json['isDeclined']);
	if (isDeclined != null) {
		fullUserProfileConnection.isDeclined = isDeclined;
	}
	final bool? muted = jsonConvert.convert<bool>(json['muted']);
	if (muted != null) {
		fullUserProfileConnection.muted = muted;
	}
	final bool? blocked = jsonConvert.convert<bool>(json['blocked']);
	if (blocked != null) {
		fullUserProfileConnection.blocked = blocked;
	}
	final bool? following = jsonConvert.convert<bool>(json['following']);
	if (following != null) {
		fullUserProfileConnection.following = following;
	}
	final bool? followsYou = jsonConvert.convert<bool>(json['followsYou']);
	if (followsYou != null) {
		fullUserProfileConnection.followsYou = followsYou;
	}
	return fullUserProfileConnection;
}

Map<String, dynamic> $FullUserProfileConnectionToJson(FullUserProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['connected'] = entity.connected;
	data['isAccepted'] = entity.isAccepted;
	data['isPending'] = entity.isPending;
	data['isDeclined'] = entity.isDeclined;
	data['muted'] = entity.muted;
	data['blocked'] = entity.blocked;
	data['following'] = entity.following;
	data['followsYou'] = entity.followsYou;
	return data;
}