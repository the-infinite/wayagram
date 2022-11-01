import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/all_events_entity.dart';

AllEventsEntity $AllEventsEntityFromJson(Map<String, dynamic> json) {
	final AllEventsEntity allEventsEntity = AllEventsEntity();
	final List<AllEventsData>? data = jsonConvert.convertListNotNull<AllEventsData>(json['data']);
	if (data != null) {
		allEventsEntity.data = data;
	}
	final AllEventsMetadata? metadata = jsonConvert.convert<AllEventsMetadata>(json['metadata']);
	if (metadata != null) {
		allEventsEntity.metadata = metadata;
	}
	return allEventsEntity;
}

Map<String, dynamic> $AllEventsEntityToJson(AllEventsEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] =  entity.data?.map((v) => v.toJson()).toList();
	data['metadata'] = entity.metadata?.toJson();
	return data;
}

AllEventsData $AllEventsDataFromJson(Map<String, dynamic> json) {
	final AllEventsData allEventsData = AllEventsData();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allEventsData.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allEventsData.profileId = profileId;
	}
	final String? eventName = jsonConvert.convert<String>(json['eventName']);
	if (eventName != null) {
		allEventsData.eventName = eventName;
	}
	final String? eventOrganizer = jsonConvert.convert<String>(json['eventOrganizer']);
	if (eventOrganizer != null) {
		allEventsData.eventOrganizer = eventOrganizer;
	}
	final String? location = jsonConvert.convert<String>(json['location']);
	if (location != null) {
		allEventsData.location = location;
	}
	final String? details = jsonConvert.convert<String>(json['details']);
	if (details != null) {
		allEventsData.details = details;
	}
	final String? eventPoster = jsonConvert.convert<String>(json['eventPoster']);
	if (eventPoster != null) {
		allEventsData.eventPoster = eventPoster;
	}
	final dynamic? eventUrl = jsonConvert.convert<dynamic>(json['eventUrl']);
	if (eventUrl != null) {
		allEventsData.eventUrl = eventUrl;
	}
	final String? eventStart = jsonConvert.convert<String>(json['eventStart']);
	if (eventStart != null) {
		allEventsData.eventStart = eventStart;
	}
	final String? eventEnd = jsonConvert.convert<String>(json['eventEnd']);
	if (eventEnd != null) {
		allEventsData.eventEnd = eventEnd;
	}
	final String? eventTicketEnd = jsonConvert.convert<String>(json['eventTicketEnd']);
	if (eventTicketEnd != null) {
		allEventsData.eventTicketEnd = eventTicketEnd;
	}
	final int? noOfTicketAllowed = jsonConvert.convert<int>(json['no_of_ticket_allowed']);
	if (noOfTicketAllowed != null) {
		allEventsData.noOfTicketAllowed = noOfTicketAllowed;
	}
	final int? noOfTicketBought = jsonConvert.convert<int>(json['no_of_ticket_bought']);
	if (noOfTicketBought != null) {
		allEventsData.noOfTicketBought = noOfTicketBought;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		allEventsData.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		allEventsData.millisecUpdatedAt = millisecUpdatedAt;
	}
	final bool? isPrivate = jsonConvert.convert<bool>(json['isPrivate']);
	if (isPrivate != null) {
		allEventsData.isPrivate = isPrivate;
	}
	final bool? isPromoted = jsonConvert.convert<bool>(json['isPromoted']);
	if (isPromoted != null) {
		allEventsData.isPromoted = isPromoted;
	}
	final bool? virtual = jsonConvert.convert<bool>(json['virtual']);
	if (virtual != null) {
		allEventsData.virtual = virtual;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		allEventsData.isPaid = isPaid;
	}
	final int? amount = jsonConvert.convert<int>(json['amount']);
	if (amount != null) {
		allEventsData.amount = amount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		allEventsData.shareCount = shareCount;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		allEventsData.isDeleted = isDeleted;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		allEventsData.currentState = currentState;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allEventsData.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allEventsData.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allEventsData.updatedAt = updatedAt;
	}
	final List<AllEventsDataEventParticipants>? eventParticipants = jsonConvert.convertListNotNull<AllEventsDataEventParticipants>(json['EventParticipants']);
	if (eventParticipants != null) {
		allEventsData.eventParticipants = eventParticipants;
	}
	final List<AllEventsDataEventLikes>? eventLikes = jsonConvert.convertListNotNull<AllEventsDataEventLikes>(json['EventLikes']);
	if (eventLikes != null) {
		allEventsData.eventLikes = eventLikes;
	}
	final bool? maxCapacityReached = jsonConvert.convert<bool>(json['max_capacity_reached']);
	if (maxCapacityReached != null) {
		allEventsData.maxCapacityReached = maxCapacityReached;
	}
	final bool? userInterested = jsonConvert.convert<bool>(json['userInterested']);
	if (userInterested != null) {
		allEventsData.userInterested = userInterested;
	}
	final AllEventsDataEngagement? engagement = jsonConvert.convert<AllEventsDataEngagement>(json['Engagement']);
	if (engagement != null) {
		allEventsData.engagement = engagement;
	}
	final AllEventsDataProfile? profile = jsonConvert.convert<AllEventsDataProfile>(json['Profile']);
	if (profile != null) {
		allEventsData.profile = profile;
	}
	return allEventsData;
}

Map<String, dynamic> $AllEventsDataToJson(AllEventsData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['eventName'] = entity.eventName;
	data['eventOrganizer'] = entity.eventOrganizer;
	data['location'] = entity.location;
	data['details'] = entity.details;
	data['eventPoster'] = entity.eventPoster;
	data['eventUrl'] = entity.eventUrl;
	data['eventStart'] = entity.eventStart;
	data['eventEnd'] = entity.eventEnd;
	data['eventTicketEnd'] = entity.eventTicketEnd;
	data['no_of_ticket_allowed'] = entity.noOfTicketAllowed;
	data['no_of_ticket_bought'] = entity.noOfTicketBought;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['isPrivate'] = entity.isPrivate;
	data['isPromoted'] = entity.isPromoted;
	data['virtual'] = entity.virtual;
	data['isPaid'] = entity.isPaid;
	data['amount'] = entity.amount;
	data['shareCount'] = entity.shareCount;
	data['isDeleted'] = entity.isDeleted;
	data['currentState'] = entity.currentState;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['EventParticipants'] =  entity.eventParticipants?.map((v) => v.toJson()).toList();
	data['EventLikes'] =  entity.eventLikes?.map((v) => v.toJson()).toList();
	data['max_capacity_reached'] = entity.maxCapacityReached;
	data['userInterested'] = entity.userInterested;
	data['Engagement'] = entity.engagement?.toJson();
	data['Profile'] = entity.profile?.toJson();
	return data;
}

AllEventsDataEventParticipants $AllEventsDataEventParticipantsFromJson(Map<String, dynamic> json) {
	final AllEventsDataEventParticipants allEventsDataEventParticipants = AllEventsDataEventParticipants();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allEventsDataEventParticipants.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allEventsDataEventParticipants.profileId = profileId;
	}
	final String? eventId = jsonConvert.convert<String>(json['EventId']);
	if (eventId != null) {
		allEventsDataEventParticipants.eventId = eventId;
	}
	final String? going = jsonConvert.convert<String>(json['going']);
	if (going != null) {
		allEventsDataEventParticipants.going = going;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allEventsDataEventParticipants.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allEventsDataEventParticipants.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allEventsDataEventParticipants.updatedAt = updatedAt;
	}
	return allEventsDataEventParticipants;
}

Map<String, dynamic> $AllEventsDataEventParticipantsToJson(AllEventsDataEventParticipants entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['EventId'] = entity.eventId;
	data['going'] = entity.going;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

AllEventsDataEventLikes $AllEventsDataEventLikesFromJson(Map<String, dynamic> json) {
	final AllEventsDataEventLikes allEventsDataEventLikes = AllEventsDataEventLikes();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allEventsDataEventLikes.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allEventsDataEventLikes.profileId = profileId;
	}
	final String? eventId = jsonConvert.convert<String>(json['EventId']);
	if (eventId != null) {
		allEventsDataEventLikes.eventId = eventId;
	}
	final bool? like = jsonConvert.convert<bool>(json['like']);
	if (like != null) {
		allEventsDataEventLikes.like = like;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allEventsDataEventLikes.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allEventsDataEventLikes.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allEventsDataEventLikes.updatedAt = updatedAt;
	}
	return allEventsDataEventLikes;
}

Map<String, dynamic> $AllEventsDataEventLikesToJson(AllEventsDataEventLikes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['EventId'] = entity.eventId;
	data['like'] = entity.like;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

AllEventsDataEngagement $AllEventsDataEngagementFromJson(Map<String, dynamic> json) {
	final AllEventsDataEngagement allEventsDataEngagement = AllEventsDataEngagement();
	final int? likeCount = jsonConvert.convert<int>(json['likeCount']);
	if (likeCount != null) {
		allEventsDataEngagement.likeCount = likeCount;
	}
	final int? bookmarkCount = jsonConvert.convert<int>(json['bookmarkCount']);
	if (bookmarkCount != null) {
		allEventsDataEngagement.bookmarkCount = bookmarkCount;
	}
	return allEventsDataEngagement;
}

Map<String, dynamic> $AllEventsDataEngagementToJson(AllEventsDataEngagement entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['likeCount'] = entity.likeCount;
	data['bookmarkCount'] = entity.bookmarkCount;
	return data;
}

AllEventsDataProfile $AllEventsDataProfileFromJson(Map<String, dynamic> json) {
	final AllEventsDataProfile allEventsDataProfile = AllEventsDataProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allEventsDataProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		allEventsDataProfile.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		allEventsDataProfile.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		allEventsDataProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		allEventsDataProfile.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		allEventsDataProfile.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		allEventsDataProfile.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		allEventsDataProfile.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		allEventsDataProfile.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		allEventsDataProfile.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		allEventsDataProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		allEventsDataProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		allEventsDataProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		allEventsDataProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		allEventsDataProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		allEventsDataProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		allEventsDataProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		allEventsDataProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		allEventsDataProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		allEventsDataProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		allEventsDataProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		allEventsDataProfile.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		allEventsDataProfile.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		allEventsDataProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		allEventsDataProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		allEventsDataProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		allEventsDataProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allEventsDataProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allEventsDataProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allEventsDataProfile.updatedAt = updatedAt;
	}
	final AllEventsDataProfileConnection? connection = jsonConvert.convert<AllEventsDataProfileConnection>(json['connection']);
	if (connection != null) {
		allEventsDataProfile.connection = connection;
	}
	return allEventsDataProfile;
}

Map<String, dynamic> $AllEventsDataProfileToJson(AllEventsDataProfile entity) {
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

AllEventsDataProfileConnection $AllEventsDataProfileConnectionFromJson(Map<String, dynamic> json) {
	final AllEventsDataProfileConnection allEventsDataProfileConnection = AllEventsDataProfileConnection();
	final bool? connected = jsonConvert.convert<bool>(json['connected']);
	if (connected != null) {
		allEventsDataProfileConnection.connected = connected;
	}
	final bool? isAccepted = jsonConvert.convert<bool>(json['isAccepted']);
	if (isAccepted != null) {
		allEventsDataProfileConnection.isAccepted = isAccepted;
	}
	final bool? isPending = jsonConvert.convert<bool>(json['isPending']);
	if (isPending != null) {
		allEventsDataProfileConnection.isPending = isPending;
	}
	final bool? isDeclined = jsonConvert.convert<bool>(json['isDeclined']);
	if (isDeclined != null) {
		allEventsDataProfileConnection.isDeclined = isDeclined;
	}
	final bool? muted = jsonConvert.convert<bool>(json['muted']);
	if (muted != null) {
		allEventsDataProfileConnection.muted = muted;
	}
	final bool? blocked = jsonConvert.convert<bool>(json['blocked']);
	if (blocked != null) {
		allEventsDataProfileConnection.blocked = blocked;
	}
	final bool? following = jsonConvert.convert<bool>(json['following']);
	if (following != null) {
		allEventsDataProfileConnection.following = following;
	}
	final bool? followsYou = jsonConvert.convert<bool>(json['followsYou']);
	if (followsYou != null) {
		allEventsDataProfileConnection.followsYou = followsYou;
	}
	return allEventsDataProfileConnection;
}

Map<String, dynamic> $AllEventsDataProfileConnectionToJson(AllEventsDataProfileConnection entity) {
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

AllEventsMetadata $AllEventsMetadataFromJson(Map<String, dynamic> json) {
	final AllEventsMetadata allEventsMetadata = AllEventsMetadata();
	final dynamic? previousPage = jsonConvert.convert<dynamic>(json['previousPage']);
	if (previousPage != null) {
		allEventsMetadata.previousPage = previousPage;
	}
	final int? currentPage = jsonConvert.convert<int>(json['currentPage']);
	if (currentPage != null) {
		allEventsMetadata.currentPage = currentPage;
	}
	final dynamic? nextPage = jsonConvert.convert<dynamic>(json['nextPage']);
	if (nextPage != null) {
		allEventsMetadata.nextPage = nextPage;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		allEventsMetadata.total = total;
	}
	final int? limit = jsonConvert.convert<int>(json['limit']);
	if (limit != null) {
		allEventsMetadata.limit = limit;
	}
	return allEventsMetadata;
}

Map<String, dynamic> $AllEventsMetadataToJson(AllEventsMetadata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['previousPage'] = entity.previousPage;
	data['currentPage'] = entity.currentPage;
	data['nextPage'] = entity.nextPage;
	data['total'] = entity.total;
	data['limit'] = entity.limit;
	return data;
}