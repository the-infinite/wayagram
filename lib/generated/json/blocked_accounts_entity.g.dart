import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/blocked_accounts_entity.dart';

BlockedAccountsEntity $BlockedAccountsEntityFromJson(Map<String, dynamic> json) {
	final BlockedAccountsEntity blockedAccountsEntity = BlockedAccountsEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		blockedAccountsEntity.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		blockedAccountsEntity.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		blockedAccountsEntity.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		blockedAccountsEntity.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		blockedAccountsEntity.bio = bio;
	}
	final double? notificationCount = jsonConvert.convert<double>(json['notificationCount']);
	if (notificationCount != null) {
		blockedAccountsEntity.notificationCount = notificationCount;
	}
	final double? posts = jsonConvert.convert<double>(json['posts']);
	if (posts != null) {
		blockedAccountsEntity.posts = posts;
	}
	final double? groupCount = jsonConvert.convert<double>(json['groupCount']);
	if (groupCount != null) {
		blockedAccountsEntity.groupCount = groupCount;
	}
	final double? pageCount = jsonConvert.convert<double>(json['pageCount']);
	if (pageCount != null) {
		blockedAccountsEntity.pageCount = pageCount;
	}
	final double? followings = jsonConvert.convert<double>(json['followings']);
	if (followings != null) {
		blockedAccountsEntity.followings = followings;
	}
	final double? followers = jsonConvert.convert<double>(json['followers']);
	if (followers != null) {
		blockedAccountsEntity.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		blockedAccountsEntity.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		blockedAccountsEntity.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		blockedAccountsEntity.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		blockedAccountsEntity.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		blockedAccountsEntity.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		blockedAccountsEntity.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		blockedAccountsEntity.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		blockedAccountsEntity.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		blockedAccountsEntity.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		blockedAccountsEntity.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		blockedAccountsEntity.fontSize = fontSize;
	}
	final dynamic? phone = jsonConvert.convert<dynamic>(json['phone']);
	if (phone != null) {
		blockedAccountsEntity.phone = phone;
	}
	final dynamic? email = jsonConvert.convert<dynamic>(json['email']);
	if (email != null) {
		blockedAccountsEntity.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		blockedAccountsEntity.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		blockedAccountsEntity.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		blockedAccountsEntity.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		blockedAccountsEntity.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		blockedAccountsEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		blockedAccountsEntity.updatedAt = updatedAt;
	}
	final BlockedAccountsConnection? connection = jsonConvert.convert<BlockedAccountsConnection>(json['connection']);
	if (connection != null) {
		blockedAccountsEntity.connection = connection;
	}
	return blockedAccountsEntity;
}

Map<String, dynamic> $BlockedAccountsEntityToJson(BlockedAccountsEntity entity) {
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

BlockedAccountsConnection $BlockedAccountsConnectionFromJson(Map<String, dynamic> json) {
	final BlockedAccountsConnection blockedAccountsConnection = BlockedAccountsConnection();
	return blockedAccountsConnection;
}

Map<String, dynamic> $BlockedAccountsConnectionToJson(BlockedAccountsConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}