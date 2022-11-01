import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/all_posts_entity.dart';
import 'package:wayagram/app/data/model/posts_model_entity.dart';


AllPostsEntity $AllPostsEntityFromJson(Map<String, dynamic> json) {
	final AllPostsEntity allPostsEntity = AllPostsEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsEntity.id = id;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		allPostsEntity.description = description;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		allPostsEntity.type = type;
	}
	final dynamic? kind = jsonConvert.convert<dynamic>(json['kind']);
	if (kind != null) {
		allPostsEntity.kind = kind;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allPostsEntity.profileId = profileId;
	}
	final dynamic? groupId = jsonConvert.convert<dynamic>(json['GroupId']);
	if (groupId != null) {
		allPostsEntity.groupId = groupId;
	}
	final dynamic? pageId = jsonConvert.convert<dynamic>(json['PageId']);
	if (pageId != null) {
		allPostsEntity.pageId = pageId;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		allPostsEntity.isDeleted = isDeleted;
	}
	final bool? isPoll = jsonConvert.convert<bool>(json['isPoll']);
	if (isPoll != null) {
		allPostsEntity.isPoll = isPoll;
	}
	final bool? isPromoted = jsonConvert.convert<bool>(json['isPromoted']);
	if (isPromoted != null) {
		allPostsEntity.isPromoted = isPromoted;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		allPostsEntity.isPaid = isPaid;
	}
	final String? viewsCount = jsonConvert.convert<String>(json['viewsCount']);
	if (viewsCount != null) {
		allPostsEntity.viewsCount = viewsCount;
	}
	final double? likeCount = jsonConvert.convert<double>(json['likeCount']);
	if (likeCount != null) {
		allPostsEntity.likeCount = likeCount;
	}
	final String? unLikeCount = jsonConvert.convert<String>(json['unLikeCount']);
	if (unLikeCount != null) {
		allPostsEntity.unLikeCount = unLikeCount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		allPostsEntity.shareCount = shareCount;
	}
	final String? commentCount = jsonConvert.convert<String>(json['commentCount']);
	if (commentCount != null) {
		allPostsEntity.commentCount = commentCount;
	}
	final String? repostCount = jsonConvert.convert<String>(json['repostCount']);
	if (repostCount != null) {
		allPostsEntity.repostCount = repostCount;
	}
	final bool? repostedPost = jsonConvert.convert<bool>(json['repostedPost']);
	if (repostedPost != null) {
		allPostsEntity.repostedPost = repostedPost;
	}
	final bool? isRepostWithComment = jsonConvert.convert<bool>(json['isRepostWithComment']);
	if (isRepostWithComment != null) {
		allPostsEntity.isRepostWithComment = isRepostWithComment;
	}
	final String? originalPostId = jsonConvert.convert<String>(json['OriginalPostId']);
	if (originalPostId != null) {
		allPostsEntity.originalPostId = originalPostId;
	}
	final String? reposterProfileId = jsonConvert.convert<String>(json['ReposterProfileId']);
	if (reposterProfileId != null) {
		allPostsEntity.reposterProfileId = reposterProfileId;
	}
	final String? repostCommentDesc = jsonConvert.convert<String>(json['repostCommentDesc']);
	if (repostCommentDesc != null) {
		allPostsEntity.repostCommentDesc = repostCommentDesc;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		allPostsEntity.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		allPostsEntity.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allPostsEntity.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allPostsEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allPostsEntity.updatedAt = updatedAt;
	}
	final List<PostsModelPostImages>? postImages = jsonConvert.convertListNotNull<PostsModelPostImages>(json['PostImages']);
	if (postImages != null) {
		allPostsEntity.postImages = postImages;
	}
	final List<PostsModelPostTags>? postTags = jsonConvert.convertListNotNull<PostsModelPostTags>(json['PostTags']);
	if (postTags != null) {
		allPostsEntity.postTags = postTags;
	}
	final List<PostsModelPostMentions>? postMentions = jsonConvert.convertListNotNull<PostsModelPostMentions>(json['PostMentions']);
	if (postMentions != null) {
		allPostsEntity.postMentions = postMentions;
	}
	final dynamic? promotion = jsonConvert.convert<dynamic>(json['Promotion']);
	if (promotion != null) {
		allPostsEntity.promotion = promotion;
	}
	final AllPostsPoll? poll = jsonConvert.convert<AllPostsPoll>(json['Poll']);
	if (poll != null) {
		allPostsEntity.poll = poll;
	}
	final dynamic? product = jsonConvert.convert<dynamic>(json['Product']);
	if (product != null) {
		allPostsEntity.product = product;
	}
	final dynamic? donation = jsonConvert.convert<dynamic>(json['Donation']);
	if (donation != null) {
		allPostsEntity.donation = donation;
	}
	final bool? isPagePost = jsonConvert.convert<bool>(json['isPagePost']);
	if (isPagePost != null) {
		allPostsEntity.isPagePost = isPagePost;
	}
	final AllPostsProfile? profile = jsonConvert.convert<AllPostsProfile>(json['Profile']);
	if (profile != null) {
		allPostsEntity.profile = profile;
	}
	final bool? isLiked = jsonConvert.convert<bool>(json['isLiked']);
	if (isLiked != null) {
		allPostsEntity.isLiked = isLiked;
	}
	final bool? isBookmarked = jsonConvert.convert<bool>(json['isBookmarked']);
	if (isBookmarked != null) {
		allPostsEntity.isBookmarked = isBookmarked;
	}
	final double? postCount = jsonConvert.convert<double>(json['postCount']);
	if (postCount != null) {
		allPostsEntity.postCount = postCount;
	}
	final bool? isRepost = jsonConvert.convert<bool>(json['isRepost']);
	if (isRepost != null) {
		allPostsEntity.isRepost = isRepost;
	}
	final String? repostedBy = jsonConvert.convert<String>(json['repostedBy']);
	if (repostedBy != null) {
		allPostsEntity.repostedBy = repostedBy;
	}
	final AllPostsEngagement? engagement = jsonConvert.convert<AllPostsEngagement>(json['Engagement']);
	if (engagement != null) {
		allPostsEntity.engagement = engagement;
	}
	final AllPostsOriginalOwner? originalOwner = jsonConvert.convert<AllPostsOriginalOwner>(json['OriginalOwner']);
	if (originalOwner != null) {
		allPostsEntity.originalOwner = originalOwner;
	}
	return allPostsEntity;
}

Map<String, dynamic> $AllPostsEntityToJson(AllPostsEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['description'] = entity.description;
	data['type'] = entity.type;
	data['kind'] = entity.kind;
	data['ProfileId'] = entity.profileId;
	data['GroupId'] = entity.groupId;
	data['PageId'] = entity.pageId;
	data['isDeleted'] = entity.isDeleted;
	data['isPoll'] = entity.isPoll;
	data['isPromoted'] = entity.isPromoted;
	data['isPaid'] = entity.isPaid;
	data['viewsCount'] = entity.viewsCount;
	data['likeCount'] = entity.likeCount;
	data['unLikeCount'] = entity.unLikeCount;
	data['shareCount'] = entity.shareCount;
	data['commentCount'] = entity.commentCount;
	data['repostCount'] = entity.repostCount;
	data['repostedPost'] = entity.repostedPost;
	data['isRepostWithComment'] = entity.isRepostWithComment;
	data['OriginalPostId'] = entity.originalPostId;
	data['ReposterProfileId'] = entity.reposterProfileId;
	data['repostCommentDesc'] = entity.repostCommentDesc;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['PostImages'] =  entity.postImages?.map((v) => v.toJson()).toList();
	data['PostTags'] =  entity.postTags?.map((v) => v.toJson()).toList();
	data['PostMentions'] =  entity.postMentions?.map((v) => v.toJson()).toList();
	data['Promotion'] = entity.promotion;
	data['Poll'] = entity.poll?.toJson();
	data['Product'] = entity.product;
	data['Donation'] = entity.donation;
	data['isPagePost'] = entity.isPagePost;
	data['Profile'] = entity.profile?.toJson();
	data['isLiked'] = entity.isLiked;
	data['isBookmarked'] = entity.isBookmarked;
	data['postCount'] = entity.postCount;
	data['isRepost'] = entity.isRepost;
	data['repostedBy'] = entity.repostedBy;
	data['Engagement'] = entity.engagement?.toJson();
	data['OriginalOwner'] = entity.originalOwner?.toJson();
	return data;
}

AllPostsPoll $AllPostsPollFromJson(Map<String, dynamic> json) {
	final AllPostsPoll allPostsPoll = AllPostsPoll();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsPoll.id = id;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		allPostsPoll.postId = postId;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allPostsPoll.profileId = profileId;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		allPostsPoll.isPaid = isPaid;
	}
	final double? amount = jsonConvert.convert<double>(json['amount']);
	if (amount != null) {
		allPostsPoll.amount = amount;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		allPostsPoll.currentState = currentState;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		allPostsPoll.description = description;
	}
	final bool? showResult = jsonConvert.convert<bool>(json['showResult']);
	if (showResult != null) {
		allPostsPoll.showResult = showResult;
	}
	final bool? schedule = jsonConvert.convert<bool>(json['schedule']);
	if (schedule != null) {
		allPostsPoll.schedule = schedule;
	}
	final bool? showOptionResult = jsonConvert.convert<bool>(json['showOptionResult']);
	if (showOptionResult != null) {
		allPostsPoll.showOptionResult = showOptionResult;
	}
	final String? pollCategory = jsonConvert.convert<String>(json['pollCategory']);
	if (pollCategory != null) {
		allPostsPoll.pollCategory = pollCategory;
	}
	final String? startDate = jsonConvert.convert<String>(json['startDate']);
	if (startDate != null) {
		allPostsPoll.startDate = startDate;
	}
	final String? endDate = jsonConvert.convert<String>(json['endDate']);
	if (endDate != null) {
		allPostsPoll.endDate = endDate;
	}
	final String? startTime = jsonConvert.convert<String>(json['startTime']);
	if (startTime != null) {
		allPostsPoll.startTime = startTime;
	}
	final String? endTime = jsonConvert.convert<String>(json['endTime']);
	if (endTime != null) {
		allPostsPoll.endTime = endTime;
	}
	final String? pollExpire = jsonConvert.convert<String>(json['pollExpire']);
	if (pollExpire != null) {
		allPostsPoll.pollExpire = pollExpire;
	}
	final double? voteLimit = jsonConvert.convert<double>(json['voteLimit']);
	if (voteLimit != null) {
		allPostsPoll.voteLimit = voteLimit;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		allPostsPoll.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		allPostsPoll.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		allPostsPoll.shareCount = shareCount;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allPostsPoll.sV = sV;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		allPostsPoll.isDeleted = isDeleted;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allPostsPoll.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allPostsPoll.updatedAt = updatedAt;
	}
	final List<AllPostsPollPollOptions>? pollOptions = jsonConvert.convertListNotNull<AllPostsPollPollOptions>(json['PollOptions']);
	if (pollOptions != null) {
		allPostsPoll.pollOptions = pollOptions;
	}
	final List<dynamic>? votePayments = jsonConvert.convertListNotNull<dynamic>(json['VotePayments']);
	if (votePayments != null) {
		allPostsPoll.votePayments = votePayments;
	}
	final AllPostsPollVotes? votes = jsonConvert.convert<AllPostsPollVotes>(json['Votes']);
	if (votes != null) {
		allPostsPoll.votes = votes;
	}
	final double? totalVotesCountPoll = jsonConvert.convert<double>(json['totalVotesCountPoll']);
	if (totalVotesCountPoll != null) {
		allPostsPoll.totalVotesCountPoll = totalVotesCountPoll;
	}
	final double? totalAmount = jsonConvert.convert<double>(json['totalAmount']);
	if (totalAmount != null) {
		allPostsPoll.totalAmount = totalAmount;
	}
	final String? lastUserChoice = jsonConvert.convert<String>(json['lastUserChoice']);
	if (lastUserChoice != null) {
		allPostsPoll.lastUserChoice = lastUserChoice;
	}
	final bool? userVoted = jsonConvert.convert<bool>(json['userVoted']);
	if (userVoted != null) {
		allPostsPoll.userVoted = userVoted;
	}
	final double? totalVotesLoggedInUser = jsonConvert.convert<double>(json['totalVotesLoggedInUser']);
	if (totalVotesLoggedInUser != null) {
		allPostsPoll.totalVotesLoggedInUser = totalVotesLoggedInUser;
	}
	return allPostsPoll;
}

Map<String, dynamic> $AllPostsPollToJson(AllPostsPoll entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['PostId'] = entity.postId;
	data['ProfileId'] = entity.profileId;
	data['isPaid'] = entity.isPaid;
	data['amount'] = entity.amount;
	data['currentState'] = entity.currentState;
	data['description'] = entity.description;
	data['showResult'] = entity.showResult;
	data['schedule'] = entity.schedule;
	data['showOptionResult'] = entity.showOptionResult;
	data['pollCategory'] = entity.pollCategory;
	data['startDate'] = entity.startDate;
	data['endDate'] = entity.endDate;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['pollExpire'] = entity.pollExpire;
	data['voteLimit'] = entity.voteLimit;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['shareCount'] = entity.shareCount;
	data['_v'] = entity.sV;
	data['isDeleted'] = entity.isDeleted;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['PollOptions'] =  entity.pollOptions?.map((v) => v.toJson()).toList();
	data['VotePayments'] =  entity.votePayments;
	data['Votes'] = entity.votes?.toJson();
	data['totalVotesCountPoll'] = entity.totalVotesCountPoll;
	data['totalAmount'] = entity.totalAmount;
	data['lastUserChoice'] = entity.lastUserChoice;
	data['userVoted'] = entity.userVoted;
	data['totalVotesLoggedInUser'] = entity.totalVotesLoggedInUser;
	return data;
}

AllPostsPollPollOptions $AllPostsPollPollOptionsFromJson(Map<String, dynamic> json) {
	final AllPostsPollPollOptions allPostsPollPollOptions = AllPostsPollPollOptions();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsPollPollOptions.id = id;
	}
	final double? position = jsonConvert.convert<double>(json['position']);
	if (position != null) {
		allPostsPollPollOptions.position = position;
	}
	final String? option = jsonConvert.convert<String>(json['option']);
	if (option != null) {
		allPostsPollPollOptions.option = option;
	}
	final dynamic? mediaUrl = jsonConvert.convert<dynamic>(json['media_url']);
	if (mediaUrl != null) {
		allPostsPollPollOptions.mediaUrl = mediaUrl;
	}
	final dynamic? mediaType = jsonConvert.convert<dynamic>(json['media_type']);
	if (mediaType != null) {
		allPostsPollPollOptions.mediaType = mediaType;
	}
	final String? shortDesc = jsonConvert.convert<String>(json['short_desc']);
	if (shortDesc != null) {
		allPostsPollPollOptions.shortDesc = shortDesc;
	}
	final List<dynamic>? votes = jsonConvert.convertListNotNull<dynamic>(json['Votes']);
	if (votes != null) {
		allPostsPollPollOptions.votes = votes;
	}
	final double? totalVotesCountPollOption = jsonConvert.convert<double>(json['totalVotesCountPollOption']);
	if (totalVotesCountPollOption != null) {
		allPostsPollPollOptions.totalVotesCountPollOption = totalVotesCountPollOption;
	}
	final bool? userVoted = jsonConvert.convert<bool>(json['userVoted']);
	if (userVoted != null) {
		allPostsPollPollOptions.userVoted = userVoted;
	}
	return allPostsPollPollOptions;
}

Map<String, dynamic> $AllPostsPollPollOptionsToJson(AllPostsPollPollOptions entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['position'] = entity.position;
	data['option'] = entity.option;
	data['media_url'] = entity.mediaUrl;
	data['media_type'] = entity.mediaType;
	data['short_desc'] = entity.shortDesc;
	data['Votes'] =  entity.votes;
	data['totalVotesCountPollOption'] = entity.totalVotesCountPollOption;
	data['userVoted'] = entity.userVoted;
	return data;
}

AllPostsPollVotes $AllPostsPollVotesFromJson(Map<String, dynamic> json) {
	final AllPostsPollVotes allPostsPollVotes = AllPostsPollVotes();
	final double? riverStynx = jsonConvert.convert<double>(json['River Stynx']);
	if (riverStynx != null) {
		allPostsPollVotes.riverStynx = riverStynx;
	}
	final double? mississippi = jsonConvert.convert<double>(json['Mississippi ']);
	if (mississippi != null) {
		allPostsPollVotes.mississippi = mississippi;
	}
	final double? nile = jsonConvert.convert<double>(json['Nile']);
	if (nile != null) {
		allPostsPollVotes.nile = nile;
	}
	return allPostsPollVotes;
}

Map<String, dynamic> $AllPostsPollVotesToJson(AllPostsPollVotes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['River Stynx'] = entity.riverStynx;
	data['Mississippi '] = entity.mississippi;
	data['Nile'] = entity.nile;
	return data;
}

AllPostsProfile $AllPostsProfileFromJson(Map<String, dynamic> json) {
	final AllPostsProfile allPostsProfile = AllPostsProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		allPostsProfile.userId = userId;
	}
	final dynamic? avatar = jsonConvert.convert<dynamic>(json['avatar']);
	if (avatar != null) {
		allPostsProfile.avatar = avatar;
	}
	final dynamic? coverImage = jsonConvert.convert<dynamic>(json['coverImage']);
	if (coverImage != null) {
		allPostsProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		allPostsProfile.bio = bio;
	}
	final double? notificationCount = jsonConvert.convert<double>(json['notificationCount']);
	if (notificationCount != null) {
		allPostsProfile.notificationCount = notificationCount;
	}
	final double? posts = jsonConvert.convert<double>(json['posts']);
	if (posts != null) {
		allPostsProfile.posts = posts;
	}
	final double? groupCount = jsonConvert.convert<double>(json['groupCount']);
	if (groupCount != null) {
		allPostsProfile.groupCount = groupCount;
	}
	final double? pageCount = jsonConvert.convert<double>(json['pageCount']);
	if (pageCount != null) {
		allPostsProfile.pageCount = pageCount;
	}
	final double? followings = jsonConvert.convert<double>(json['followings']);
	if (followings != null) {
		allPostsProfile.followings = followings;
	}
	final double? followers = jsonConvert.convert<double>(json['followers']);
	if (followers != null) {
		allPostsProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		allPostsProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		allPostsProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		allPostsProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		allPostsProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		allPostsProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		allPostsProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		allPostsProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		allPostsProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		allPostsProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		allPostsProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		allPostsProfile.fontSize = fontSize;
	}
	final dynamic? phone = jsonConvert.convert<dynamic>(json['phone']);
	if (phone != null) {
		allPostsProfile.phone = phone;
	}
	final dynamic? email = jsonConvert.convert<dynamic>(json['email']);
	if (email != null) {
		allPostsProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		allPostsProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		allPostsProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		allPostsProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allPostsProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allPostsProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allPostsProfile.updatedAt = updatedAt;
	}
	final AllPostsProfileConnection? connection = jsonConvert.convert<AllPostsProfileConnection>(json['connection']);
	if (connection != null) {
		allPostsProfile.connection = connection;
	}
	return allPostsProfile;
}

Map<String, dynamic> $AllPostsProfileToJson(AllPostsProfile entity) {
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

AllPostsProfileConnection $AllPostsProfileConnectionFromJson(Map<String, dynamic> json) {
	final AllPostsProfileConnection allPostsProfileConnection = AllPostsProfileConnection();
	return allPostsProfileConnection;
}

Map<String, dynamic> $AllPostsProfileConnectionToJson(AllPostsProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}

AllPostsEngagement $AllPostsEngagementFromJson(Map<String, dynamic> json) {
	final AllPostsEngagement allPostsEngagement = AllPostsEngagement();
	final double? viewCount = jsonConvert.convert<double>(json['viewCount']);
	if (viewCount != null) {
		allPostsEngagement.viewCount = viewCount;
	}
	final double? likeCount = jsonConvert.convert<double>(json['likeCount']);
	if (likeCount != null) {
		allPostsEngagement.likeCount = likeCount;
	}
	final double? repostCount = jsonConvert.convert<double>(json['repostCount']);
	if (repostCount != null) {
		allPostsEngagement.repostCount = repostCount;
	}
	final double? commentCount = jsonConvert.convert<double>(json['commentCount']);
	if (commentCount != null) {
		allPostsEngagement.commentCount = commentCount;
	}
	final double? bookmarkCount = jsonConvert.convert<double>(json['bookmarkCount']);
	if (bookmarkCount != null) {
		allPostsEngagement.bookmarkCount = bookmarkCount;
	}
	return allPostsEngagement;
}

Map<String, dynamic> $AllPostsEngagementToJson(AllPostsEngagement entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['viewCount'] = entity.viewCount;
	data['likeCount'] = entity.likeCount;
	data['repostCount'] = entity.repostCount;
	data['commentCount'] = entity.commentCount;
	data['bookmarkCount'] = entity.bookmarkCount;
	return data;
}

AllPostsOriginalOwner $AllPostsOriginalOwnerFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwner allPostsOriginalOwner = AllPostsOriginalOwner();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsOriginalOwner.id = id;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		allPostsOriginalOwner.description = description;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		allPostsOriginalOwner.type = type;
	}
	final dynamic? kind = jsonConvert.convert<dynamic>(json['kind']);
	if (kind != null) {
		allPostsOriginalOwner.kind = kind;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allPostsOriginalOwner.profileId = profileId;
	}
	final dynamic? groupId = jsonConvert.convert<dynamic>(json['GroupId']);
	if (groupId != null) {
		allPostsOriginalOwner.groupId = groupId;
	}
	final dynamic? pageId = jsonConvert.convert<dynamic>(json['PageId']);
	if (pageId != null) {
		allPostsOriginalOwner.pageId = pageId;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		allPostsOriginalOwner.isDeleted = isDeleted;
	}
	final bool? isPoll = jsonConvert.convert<bool>(json['isPoll']);
	if (isPoll != null) {
		allPostsOriginalOwner.isPoll = isPoll;
	}
	final bool? isPromoted = jsonConvert.convert<bool>(json['isPromoted']);
	if (isPromoted != null) {
		allPostsOriginalOwner.isPromoted = isPromoted;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		allPostsOriginalOwner.isPaid = isPaid;
	}
	final String? viewsCount = jsonConvert.convert<String>(json['viewsCount']);
	if (viewsCount != null) {
		allPostsOriginalOwner.viewsCount = viewsCount;
	}
	final String? likeCount = jsonConvert.convert<String>(json['likeCount']);
	if (likeCount != null) {
		allPostsOriginalOwner.likeCount = likeCount;
	}
	final String? unLikeCount = jsonConvert.convert<String>(json['unLikeCount']);
	if (unLikeCount != null) {
		allPostsOriginalOwner.unLikeCount = unLikeCount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		allPostsOriginalOwner.shareCount = shareCount;
	}
	final String? commentCount = jsonConvert.convert<String>(json['commentCount']);
	if (commentCount != null) {
		allPostsOriginalOwner.commentCount = commentCount;
	}
	final String? repostCount = jsonConvert.convert<String>(json['repostCount']);
	if (repostCount != null) {
		allPostsOriginalOwner.repostCount = repostCount;
	}
	final bool? repostedPost = jsonConvert.convert<bool>(json['repostedPost']);
	if (repostedPost != null) {
		allPostsOriginalOwner.repostedPost = repostedPost;
	}
	final bool? isRepostWithComment = jsonConvert.convert<bool>(json['isRepostWithComment']);
	if (isRepostWithComment != null) {
		allPostsOriginalOwner.isRepostWithComment = isRepostWithComment;
	}
	final dynamic? originalPostId = jsonConvert.convert<dynamic>(json['OriginalPostId']);
	if (originalPostId != null) {
		allPostsOriginalOwner.originalPostId = originalPostId;
	}
	final dynamic? reposterProfileId = jsonConvert.convert<dynamic>(json['ReposterProfileId']);
	if (reposterProfileId != null) {
		allPostsOriginalOwner.reposterProfileId = reposterProfileId;
	}
	final String? repostCommentDesc = jsonConvert.convert<String>(json['repostCommentDesc']);
	if (repostCommentDesc != null) {
		allPostsOriginalOwner.repostCommentDesc = repostCommentDesc;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		allPostsOriginalOwner.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		allPostsOriginalOwner.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allPostsOriginalOwner.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allPostsOriginalOwner.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allPostsOriginalOwner.updatedAt = updatedAt;
	}
	final List<PostsModelPostImages>? postImages = jsonConvert.convertListNotNull<PostsModelPostImages>(json['PostImages']);
	if (postImages != null) {
		allPostsOriginalOwner.postImages = postImages;
	}
	final List<PostsModelPostTags>? postTags = jsonConvert.convertListNotNull<PostsModelPostTags>(json['PostTags']);
	if (postTags != null) {
		allPostsOriginalOwner.postTags = postTags;
	}
	final List<PostsModelPostMentions>? postMentions = jsonConvert.convertListNotNull<PostsModelPostMentions>(json['PostMentions']);
	if (postMentions != null) {
		allPostsOriginalOwner.postMentions = postMentions;
	}
	final dynamic? promotion = jsonConvert.convert<dynamic>(json['Promotion']);
	if (promotion != null) {
		allPostsOriginalOwner.promotion = promotion;
	}
	final AllPostsOriginalOwnerPoll? poll = jsonConvert.convert<AllPostsOriginalOwnerPoll>(json['Poll']);
	if (poll != null) {
		allPostsOriginalOwner.poll = poll;
	}
	final dynamic? product = jsonConvert.convert<dynamic>(json['Product']);
	if (product != null) {
		allPostsOriginalOwner.product = product;
	}
	final dynamic? donation = jsonConvert.convert<dynamic>(json['Donation']);
	if (donation != null) {
		allPostsOriginalOwner.donation = donation;
	}
	final AllPostsOriginalOwnerProfile? profile = jsonConvert.convert<AllPostsOriginalOwnerProfile>(json['Profile']);
	if (profile != null) {
		allPostsOriginalOwner.profile = profile;
	}
	return allPostsOriginalOwner;
}

Map<String, dynamic> $AllPostsOriginalOwnerToJson(AllPostsOriginalOwner entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['description'] = entity.description;
	data['type'] = entity.type;
	data['kind'] = entity.kind;
	data['ProfileId'] = entity.profileId;
	data['GroupId'] = entity.groupId;
	data['PageId'] = entity.pageId;
	data['isDeleted'] = entity.isDeleted;
	data['isPoll'] = entity.isPoll;
	data['isPromoted'] = entity.isPromoted;
	data['isPaid'] = entity.isPaid;
	data['viewsCount'] = entity.viewsCount;
	data['likeCount'] = entity.likeCount;
	data['unLikeCount'] = entity.unLikeCount;
	data['shareCount'] = entity.shareCount;
	data['commentCount'] = entity.commentCount;
	data['repostCount'] = entity.repostCount;
	data['repostedPost'] = entity.repostedPost;
	data['isRepostWithComment'] = entity.isRepostWithComment;
	data['OriginalPostId'] = entity.originalPostId;
	data['ReposterProfileId'] = entity.reposterProfileId;
	data['repostCommentDesc'] = entity.repostCommentDesc;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['PostImages'] =  entity.postImages?.map((v) => v.toJson()).toList();
	data['PostTags'] =  entity.postTags?.map((v) => v.toJson()).toList();
	data['PostMentions'] =  entity.postMentions?.map((v) => v.toJson()).toList();
	data['Promotion'] = entity.promotion;
	data['Poll'] = entity.poll?.toJson();
	data['Product'] = entity.product;
	data['Donation'] = entity.donation;
	data['Profile'] = entity.profile?.toJson();
	return data;
}

AllPostsOriginalOwnerPostTags $AllPostsOriginalOwnerPostTagsFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPostTags allPostsOriginalOwnerPostTags = AllPostsOriginalOwnerPostTags();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsOriginalOwnerPostTags.id = id;
	}
	final String? hashtagId = jsonConvert.convert<String>(json['HashtagId']);
	if (hashtagId != null) {
		allPostsOriginalOwnerPostTags.hashtagId = hashtagId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		allPostsOriginalOwnerPostTags.postId = postId;
	}
	final AllPostsOriginalOwnerPostTagsHashTag? hashTag = jsonConvert.convert<AllPostsOriginalOwnerPostTagsHashTag>(json['HashTag']);
	if (hashTag != null) {
		allPostsOriginalOwnerPostTags.hashTag = hashTag;
	}
	return allPostsOriginalOwnerPostTags;
}

Map<String, dynamic> $AllPostsOriginalOwnerPostTagsToJson(AllPostsOriginalOwnerPostTags entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['HashtagId'] = entity.hashtagId;
	data['PostId'] = entity.postId;
	data['HashTag'] = entity.hashTag?.toJson();
	return data;
}

AllPostsOriginalOwnerPostTagsHashTag $AllPostsOriginalOwnerPostTagsHashTagFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPostTagsHashTag allPostsOriginalOwnerPostTagsHashTag = AllPostsOriginalOwnerPostTagsHashTag();
	final String? hashtag = jsonConvert.convert<String>(json['hashtag']);
	if (hashtag != null) {
		allPostsOriginalOwnerPostTagsHashTag.hashtag = hashtag;
	}
	return allPostsOriginalOwnerPostTagsHashTag;
}

Map<String, dynamic> $AllPostsOriginalOwnerPostTagsHashTagToJson(AllPostsOriginalOwnerPostTagsHashTag entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['hashtag'] = entity.hashtag;
	return data;
}

AllPostsOriginalOwnerPostMentions $AllPostsOriginalOwnerPostMentionsFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPostMentions allPostsOriginalOwnerPostMentions = AllPostsOriginalOwnerPostMentions();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsOriginalOwnerPostMentions.id = id;
	}
	final String? mentionId = jsonConvert.convert<String>(json['MentionId']);
	if (mentionId != null) {
		allPostsOriginalOwnerPostMentions.mentionId = mentionId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		allPostsOriginalOwnerPostMentions.postId = postId;
	}
	final AllPostsOriginalOwnerPostMentionsMention? mention = jsonConvert.convert<AllPostsOriginalOwnerPostMentionsMention>(json['Mention']);
	if (mention != null) {
		allPostsOriginalOwnerPostMentions.mention = mention;
	}
	return allPostsOriginalOwnerPostMentions;
}

Map<String, dynamic> $AllPostsOriginalOwnerPostMentionsToJson(AllPostsOriginalOwnerPostMentions entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['MentionId'] = entity.mentionId;
	data['PostId'] = entity.postId;
	data['Mention'] = entity.mention?.toJson();
	return data;
}

AllPostsOriginalOwnerPostMentionsMention $AllPostsOriginalOwnerPostMentionsMentionFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPostMentionsMention allPostsOriginalOwnerPostMentionsMention = AllPostsOriginalOwnerPostMentionsMention();
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		allPostsOriginalOwnerPostMentionsMention.username = username;
	}
	return allPostsOriginalOwnerPostMentionsMention;
}

Map<String, dynamic> $AllPostsOriginalOwnerPostMentionsMentionToJson(AllPostsOriginalOwnerPostMentionsMention entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['username'] = entity.username;
	return data;
}

AllPostsOriginalOwnerPoll $AllPostsOriginalOwnerPollFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPoll allPostsOriginalOwnerPoll = AllPostsOriginalOwnerPoll();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsOriginalOwnerPoll.id = id;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		allPostsOriginalOwnerPoll.postId = postId;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		allPostsOriginalOwnerPoll.profileId = profileId;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		allPostsOriginalOwnerPoll.isPaid = isPaid;
	}
	final double? amount = jsonConvert.convert<double>(json['amount']);
	if (amount != null) {
		allPostsOriginalOwnerPoll.amount = amount;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		allPostsOriginalOwnerPoll.currentState = currentState;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		allPostsOriginalOwnerPoll.description = description;
	}
	final bool? showResult = jsonConvert.convert<bool>(json['showResult']);
	if (showResult != null) {
		allPostsOriginalOwnerPoll.showResult = showResult;
	}
	final bool? schedule = jsonConvert.convert<bool>(json['schedule']);
	if (schedule != null) {
		allPostsOriginalOwnerPoll.schedule = schedule;
	}
	final bool? showOptionResult = jsonConvert.convert<bool>(json['showOptionResult']);
	if (showOptionResult != null) {
		allPostsOriginalOwnerPoll.showOptionResult = showOptionResult;
	}
	final String? pollCategory = jsonConvert.convert<String>(json['pollCategory']);
	if (pollCategory != null) {
		allPostsOriginalOwnerPoll.pollCategory = pollCategory;
	}
	final String? startDate = jsonConvert.convert<String>(json['startDate']);
	if (startDate != null) {
		allPostsOriginalOwnerPoll.startDate = startDate;
	}
	final String? endDate = jsonConvert.convert<String>(json['endDate']);
	if (endDate != null) {
		allPostsOriginalOwnerPoll.endDate = endDate;
	}
	final String? startTime = jsonConvert.convert<String>(json['startTime']);
	if (startTime != null) {
		allPostsOriginalOwnerPoll.startTime = startTime;
	}
	final String? endTime = jsonConvert.convert<String>(json['endTime']);
	if (endTime != null) {
		allPostsOriginalOwnerPoll.endTime = endTime;
	}
	final String? pollExpire = jsonConvert.convert<String>(json['pollExpire']);
	if (pollExpire != null) {
		allPostsOriginalOwnerPoll.pollExpire = pollExpire;
	}
	final double? voteLimit = jsonConvert.convert<double>(json['voteLimit']);
	if (voteLimit != null) {
		allPostsOriginalOwnerPoll.voteLimit = voteLimit;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		allPostsOriginalOwnerPoll.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		allPostsOriginalOwnerPoll.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		allPostsOriginalOwnerPoll.shareCount = shareCount;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allPostsOriginalOwnerPoll.sV = sV;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		allPostsOriginalOwnerPoll.isDeleted = isDeleted;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allPostsOriginalOwnerPoll.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allPostsOriginalOwnerPoll.updatedAt = updatedAt;
	}
	final List<AllPostsOriginalOwnerPollPollOptions>? pollOptions = jsonConvert.convertListNotNull<AllPostsOriginalOwnerPollPollOptions>(json['PollOptions']);
	if (pollOptions != null) {
		allPostsOriginalOwnerPoll.pollOptions = pollOptions;
	}
	final List<dynamic>? votePayments = jsonConvert.convertListNotNull<dynamic>(json['VotePayments']);
	if (votePayments != null) {
		allPostsOriginalOwnerPoll.votePayments = votePayments;
	}
	final AllPostsOriginalOwnerPollVotes? votes = jsonConvert.convert<AllPostsOriginalOwnerPollVotes>(json['Votes']);
	if (votes != null) {
		allPostsOriginalOwnerPoll.votes = votes;
	}
	final double? totalVotesCount = jsonConvert.convert<double>(json['totalVotesCount']);
	if (totalVotesCount != null) {
		allPostsOriginalOwnerPoll.totalVotesCount = totalVotesCount;
	}
	final double? totalAmount = jsonConvert.convert<double>(json['totalAmount']);
	if (totalAmount != null) {
		allPostsOriginalOwnerPoll.totalAmount = totalAmount;
	}
	final String? lastUserChoice = jsonConvert.convert<String>(json['lastUserChoice']);
	if (lastUserChoice != null) {
		allPostsOriginalOwnerPoll.lastUserChoice = lastUserChoice;
	}
	final bool? userVoted = jsonConvert.convert<bool>(json['userVoted']);
	if (userVoted != null) {
		allPostsOriginalOwnerPoll.userVoted = userVoted;
	}
	final double? totalVotesLoggedInUser = jsonConvert.convert<double>(json['totalVotesLoggedInUser']);
	if (totalVotesLoggedInUser != null) {
		allPostsOriginalOwnerPoll.totalVotesLoggedInUser = totalVotesLoggedInUser;
	}
	return allPostsOriginalOwnerPoll;
}

Map<String, dynamic> $AllPostsOriginalOwnerPollToJson(AllPostsOriginalOwnerPoll entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['PostId'] = entity.postId;
	data['ProfileId'] = entity.profileId;
	data['isPaid'] = entity.isPaid;
	data['amount'] = entity.amount;
	data['currentState'] = entity.currentState;
	data['description'] = entity.description;
	data['showResult'] = entity.showResult;
	data['schedule'] = entity.schedule;
	data['showOptionResult'] = entity.showOptionResult;
	data['pollCategory'] = entity.pollCategory;
	data['startDate'] = entity.startDate;
	data['endDate'] = entity.endDate;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['pollExpire'] = entity.pollExpire;
	data['voteLimit'] = entity.voteLimit;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['shareCount'] = entity.shareCount;
	data['_v'] = entity.sV;
	data['isDeleted'] = entity.isDeleted;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['PollOptions'] =  entity.pollOptions?.map((v) => v.toJson()).toList();
	data['VotePayments'] =  entity.votePayments;
	data['Votes'] = entity.votes?.toJson();
	data['totalVotesCount'] = entity.totalVotesCount;
	data['totalAmount'] = entity.totalAmount;
	data['lastUserChoice'] = entity.lastUserChoice;
	data['userVoted'] = entity.userVoted;
	data['totalVotesLoggedInUser'] = entity.totalVotesLoggedInUser;
	return data;
}

AllPostsOriginalOwnerPollPollOptions $AllPostsOriginalOwnerPollPollOptionsFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPollPollOptions allPostsOriginalOwnerPollPollOptions = AllPostsOriginalOwnerPollPollOptions();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsOriginalOwnerPollPollOptions.id = id;
	}
	final double? position = jsonConvert.convert<double>(json['position']);
	if (position != null) {
		allPostsOriginalOwnerPollPollOptions.position = position;
	}
	final String? option = jsonConvert.convert<String>(json['option']);
	if (option != null) {
		allPostsOriginalOwnerPollPollOptions.option = option;
	}
	final dynamic? mediaUrl = jsonConvert.convert<dynamic>(json['media_url']);
	if (mediaUrl != null) {
		allPostsOriginalOwnerPollPollOptions.mediaUrl = mediaUrl;
	}
	final dynamic? mediaType = jsonConvert.convert<dynamic>(json['media_type']);
	if (mediaType != null) {
		allPostsOriginalOwnerPollPollOptions.mediaType = mediaType;
	}
	final String? shortDesc = jsonConvert.convert<String>(json['short_desc']);
	if (shortDesc != null) {
		allPostsOriginalOwnerPollPollOptions.shortDesc = shortDesc;
	}
	final List<dynamic>? votes = jsonConvert.convertListNotNull<dynamic>(json['Votes']);
	if (votes != null) {
		allPostsOriginalOwnerPollPollOptions.votes = votes;
	}
	final double? totalVotesCountPollOption = jsonConvert.convert<double>(json['totalVotesCountPollOption']);
	if (totalVotesCountPollOption != null) {
		allPostsOriginalOwnerPollPollOptions.totalVotesCountPollOption = totalVotesCountPollOption;
	}
	final bool? userVoted = jsonConvert.convert<bool>(json['userVoted']);
	if (userVoted != null) {
		allPostsOriginalOwnerPollPollOptions.userVoted = userVoted;
	}
	return allPostsOriginalOwnerPollPollOptions;
}

Map<String, dynamic> $AllPostsOriginalOwnerPollPollOptionsToJson(AllPostsOriginalOwnerPollPollOptions entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['position'] = entity.position;
	data['option'] = entity.option;
	data['media_url'] = entity.mediaUrl;
	data['media_type'] = entity.mediaType;
	data['short_desc'] = entity.shortDesc;
	data['Votes'] =  entity.votes;
	data['totalVotesCountPollOption'] = entity.totalVotesCountPollOption;
	data['userVoted'] = entity.userVoted;
	return data;
}

AllPostsOriginalOwnerPollVotes $AllPostsOriginalOwnerPollVotesFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerPollVotes allPostsOriginalOwnerPollVotes = AllPostsOriginalOwnerPollVotes();
	final double? nile = jsonConvert.convert<double>(json['Nile']);
	if (nile != null) {
		allPostsOriginalOwnerPollVotes.nile = nile;
	}
	final double? mississippi = jsonConvert.convert<double>(json['Mississippi ']);
	if (mississippi != null) {
		allPostsOriginalOwnerPollVotes.mississippi = mississippi;
	}
	final double? riverStynx = jsonConvert.convert<double>(json['River Stynx']);
	if (riverStynx != null) {
		allPostsOriginalOwnerPollVotes.riverStynx = riverStynx;
	}
	return allPostsOriginalOwnerPollVotes;
}

Map<String, dynamic> $AllPostsOriginalOwnerPollVotesToJson(AllPostsOriginalOwnerPollVotes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Nile'] = entity.nile;
	data['Mississippi '] = entity.mississippi;
	data['River Stynx'] = entity.riverStynx;
	return data;
}

AllPostsOriginalOwnerProfile $AllPostsOriginalOwnerProfileFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerProfile allPostsOriginalOwnerProfile = AllPostsOriginalOwnerProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		allPostsOriginalOwnerProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		allPostsOriginalOwnerProfile.userId = userId;
	}
	final dynamic? avatar = jsonConvert.convert<dynamic>(json['avatar']);
	if (avatar != null) {
		allPostsOriginalOwnerProfile.avatar = avatar;
	}
	final dynamic? coverImage = jsonConvert.convert<dynamic>(json['coverImage']);
	if (coverImage != null) {
		allPostsOriginalOwnerProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		allPostsOriginalOwnerProfile.bio = bio;
	}
	final double? notificationCount = jsonConvert.convert<double>(json['notificationCount']);
	if (notificationCount != null) {
		allPostsOriginalOwnerProfile.notificationCount = notificationCount;
	}
	final double? posts = jsonConvert.convert<double>(json['posts']);
	if (posts != null) {
		allPostsOriginalOwnerProfile.posts = posts;
	}
	final double? groupCount = jsonConvert.convert<double>(json['groupCount']);
	if (groupCount != null) {
		allPostsOriginalOwnerProfile.groupCount = groupCount;
	}
	final double? pageCount = jsonConvert.convert<double>(json['pageCount']);
	if (pageCount != null) {
		allPostsOriginalOwnerProfile.pageCount = pageCount;
	}
	final double? followings = jsonConvert.convert<double>(json['followings']);
	if (followings != null) {
		allPostsOriginalOwnerProfile.followings = followings;
	}
	final double? followers = jsonConvert.convert<double>(json['followers']);
	if (followers != null) {
		allPostsOriginalOwnerProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		allPostsOriginalOwnerProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		allPostsOriginalOwnerProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		allPostsOriginalOwnerProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		allPostsOriginalOwnerProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		allPostsOriginalOwnerProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		allPostsOriginalOwnerProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		allPostsOriginalOwnerProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		allPostsOriginalOwnerProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		allPostsOriginalOwnerProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		allPostsOriginalOwnerProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		allPostsOriginalOwnerProfile.fontSize = fontSize;
	}
	final dynamic? phone = jsonConvert.convert<dynamic>(json['phone']);
	if (phone != null) {
		allPostsOriginalOwnerProfile.phone = phone;
	}
	final dynamic? email = jsonConvert.convert<dynamic>(json['email']);
	if (email != null) {
		allPostsOriginalOwnerProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		allPostsOriginalOwnerProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		allPostsOriginalOwnerProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		allPostsOriginalOwnerProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		allPostsOriginalOwnerProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		allPostsOriginalOwnerProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		allPostsOriginalOwnerProfile.updatedAt = updatedAt;
	}
	final AllPostsOriginalOwnerProfileConnection? connection = jsonConvert.convert<AllPostsOriginalOwnerProfileConnection>(json['connection']);
	if (connection != null) {
		allPostsOriginalOwnerProfile.connection = connection;
	}
	return allPostsOriginalOwnerProfile;
}

Map<String, dynamic> $AllPostsOriginalOwnerProfileToJson(AllPostsOriginalOwnerProfile entity) {
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

AllPostsOriginalOwnerProfileConnection $AllPostsOriginalOwnerProfileConnectionFromJson(Map<String, dynamic> json) {
	final AllPostsOriginalOwnerProfileConnection allPostsOriginalOwnerProfileConnection = AllPostsOriginalOwnerProfileConnection();
	return allPostsOriginalOwnerProfileConnection;
}

Map<String, dynamic> $AllPostsOriginalOwnerProfileConnectionToJson(AllPostsOriginalOwnerProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}