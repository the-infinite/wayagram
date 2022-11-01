import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/posts_model_entity.dart';

PostsModelEntity $PostsModelEntityFromJson(Map<String, dynamic> json) {
	final PostsModelEntity postsModelEntity = PostsModelEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelEntity.id = id;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		postsModelEntity.description = description;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		postsModelEntity.type = type;
	}
	final String? kind = jsonConvert.convert<String>(json['kind']);
	if (kind != null) {
		postsModelEntity.kind = kind;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		postsModelEntity.profileId = profileId;
	}
	final dynamic? groupId = jsonConvert.convert<dynamic>(json['GroupId']);
	if (groupId != null) {
		postsModelEntity.groupId = groupId;
	}
	final dynamic? pageId = jsonConvert.convert<dynamic>(json['PageId']);
	if (pageId != null) {
		postsModelEntity.pageId = pageId;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		postsModelEntity.isDeleted = isDeleted;
	}
	final bool? isPoll = jsonConvert.convert<bool>(json['isPoll']);
	if (isPoll != null) {
		postsModelEntity.isPoll = isPoll;
	}
	final bool? isPromoted = jsonConvert.convert<bool>(json['isPromoted']);
	if (isPromoted != null) {
		postsModelEntity.isPromoted = isPromoted;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		postsModelEntity.isPaid = isPaid;
	}
	final String? viewsCount = jsonConvert.convert<String>(json['viewsCount']);
	if (viewsCount != null) {
		postsModelEntity.viewsCount = viewsCount;
	}
	final double? likeCount = jsonConvert.convert<double>(json['likeCount']);
	if (likeCount != null) {
		postsModelEntity.likeCount = likeCount;
	}
	final String? unLikeCount = jsonConvert.convert<String>(json['unLikeCount']);
	if (unLikeCount != null) {
		postsModelEntity.unLikeCount = unLikeCount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		postsModelEntity.shareCount = shareCount;
	}
	final String? commentCount = jsonConvert.convert<String>(json['commentCount']);
	if (commentCount != null) {
		postsModelEntity.commentCount = commentCount;
	}
	final String? repostCount = jsonConvert.convert<String>(json['repostCount']);
	if (repostCount != null) {
		postsModelEntity.repostCount = repostCount;
	}
	final bool? repostedPost = jsonConvert.convert<bool>(json['repostedPost']);
	if (repostedPost != null) {
		postsModelEntity.repostedPost = repostedPost;
	}
	final bool? isRepostWithComment = jsonConvert.convert<bool>(json['isRepostWithComment']);
	if (isRepostWithComment != null) {
		postsModelEntity.isRepostWithComment = isRepostWithComment;
	}
	final String? originalPostId = jsonConvert.convert<String>(json['OriginalPostId']);
	if (originalPostId != null) {
		postsModelEntity.originalPostId = originalPostId;
	}
	final String? reposterProfileId = jsonConvert.convert<String>(json['ReposterProfileId']);
	if (reposterProfileId != null) {
		postsModelEntity.reposterProfileId = reposterProfileId;
	}
	final String? repostCommentDesc = jsonConvert.convert<String>(json['repostCommentDesc']);
	if (repostCommentDesc != null) {
		postsModelEntity.repostCommentDesc = repostCommentDesc;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelEntity.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		postsModelEntity.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelEntity.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelEntity.updatedAt = updatedAt;
	}
	final List<PostsModelPostImages>? postImages = jsonConvert.convertListNotNull<PostsModelPostImages>(json['PostImages']);
	if (postImages != null) {
		postsModelEntity.postImages = postImages;
	}
	final List<PostsModelPostTags>? postTags = jsonConvert.convertListNotNull<PostsModelPostTags>(json['PostTags']);
	if (postTags != null) {
		postsModelEntity.postTags = postTags;
	}
	final List<PostsModelPostMentions>? postMentions = jsonConvert.convertListNotNull<PostsModelPostMentions>(json['PostMentions']);
	if (postMentions != null) {
		postsModelEntity.postMentions = postMentions;
	}
	final dynamic? promotion = jsonConvert.convert<dynamic>(json['Promotion']);
	if (promotion != null) {
		postsModelEntity.promotion = promotion;
	}
	final PostsModelPoll? poll = jsonConvert.convert<PostsModelPoll>(json['Poll']);
	if (poll != null) {
		postsModelEntity.poll = poll;
	}
	final PostsModelProduct? product = jsonConvert.convert<PostsModelProduct>(json['Product']);
	if (product != null) {
		postsModelEntity.product = product;
	}
	final PostsModelDonation? donation = jsonConvert.convert<PostsModelDonation>(json['Donation']);
	if (donation != null) {
		postsModelEntity.donation = donation;
	}
	final bool? isPagePost = jsonConvert.convert<bool>(json['isPagePost']);
	if (isPagePost != null) {
		postsModelEntity.isPagePost = isPagePost;
	}
	final PostsModelProfile? profile = jsonConvert.convert<PostsModelProfile>(json['Profile']);
	if (profile != null) {
		postsModelEntity.profile = profile;
	}
	final bool? isLiked = jsonConvert.convert<bool>(json['isLiked']);
	if (isLiked != null) {
		postsModelEntity.isLiked = isLiked;
	}
	final bool? isBookmarked = jsonConvert.convert<bool>(json['isBookmarked']);
	if (isBookmarked != null) {
		postsModelEntity.isBookmarked = isBookmarked;
	}
	final double? postCount = jsonConvert.convert<double>(json['postCount']);
	if (postCount != null) {
		postsModelEntity.postCount = postCount;
	}
	final bool? isRepost = jsonConvert.convert<bool>(json['isRepost']);
	if (isRepost != null) {
		postsModelEntity.isRepost = isRepost;
	}
	final String? repostedBy = jsonConvert.convert<String>(json['repostedBy']);
	if (repostedBy != null) {
		postsModelEntity.repostedBy = repostedBy;
	}
	final PostsModelEngagement? engagement = jsonConvert.convert<PostsModelEngagement>(json['Engagement']);
	if (engagement != null) {
		postsModelEntity.engagement = engagement;
	}
	final PostsModelOriginalOwner? originalOwner = jsonConvert.convert<PostsModelOriginalOwner>(json['OriginalOwner']);
	if (originalOwner != null) {
		postsModelEntity.originalOwner = originalOwner;
	}
	return postsModelEntity;
}

Map<String, dynamic> $PostsModelEntityToJson(PostsModelEntity entity) {
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
	data['Product'] = entity.product?.toJson();
	data['Donation'] = entity.donation?.toJson();
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

PostsModelPostImages $PostsModelPostImagesFromJson(Map<String, dynamic> json) {
	final PostsModelPostImages postsModelPostImages = PostsModelPostImages();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPostImages.id = id;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		postsModelPostImages.type = type;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelPostImages.postId = postId;
	}
	final String? imageURL = jsonConvert.convert<String>(json['imageURL']);
	if (imageURL != null) {
		postsModelPostImages.imageURL = imageURL;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		postsModelPostImages.isDeleted = isDeleted;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelPostImages.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelPostImages.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelPostImages.updatedAt = updatedAt;
	}
	return postsModelPostImages;
}

Map<String, dynamic> $PostsModelPostImagesToJson(PostsModelPostImages entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['type'] = entity.type;
	data['PostId'] = entity.postId;
	data['imageURL'] = entity.imageURL;
	data['isDeleted'] = entity.isDeleted;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

PostsModelPostTags $PostsModelPostTagsFromJson(Map<String, dynamic> json) {
	final PostsModelPostTags postsModelPostTags = PostsModelPostTags();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPostTags.id = id;
	}
	final String? hashtagId = jsonConvert.convert<String>(json['HashtagId']);
	if (hashtagId != null) {
		postsModelPostTags.hashtagId = hashtagId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelPostTags.postId = postId;
	}
	final PostsModelPostTagsHashTag? hashTag = jsonConvert.convert<PostsModelPostTagsHashTag>(json['HashTag']);
	if (hashTag != null) {
		postsModelPostTags.hashTag = hashTag;
	}
	return postsModelPostTags;
}

Map<String, dynamic> $PostsModelPostTagsToJson(PostsModelPostTags entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['HashtagId'] = entity.hashtagId;
	data['PostId'] = entity.postId;
	data['HashTag'] = entity.hashTag?.toJson();
	return data;
}

PostsModelPostTagsHashTag $PostsModelPostTagsHashTagFromJson(Map<String, dynamic> json) {
	final PostsModelPostTagsHashTag postsModelPostTagsHashTag = PostsModelPostTagsHashTag();
	final String? hashtag = jsonConvert.convert<String>(json['hashtag']);
	if (hashtag != null) {
		postsModelPostTagsHashTag.hashtag = hashtag;
	}
	return postsModelPostTagsHashTag;
}

Map<String, dynamic> $PostsModelPostTagsHashTagToJson(PostsModelPostTagsHashTag entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['hashtag'] = entity.hashtag;
	return data;
}

PostsModelPostMentions $PostsModelPostMentionsFromJson(Map<String, dynamic> json) {
	final PostsModelPostMentions postsModelPostMentions = PostsModelPostMentions();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPostMentions.id = id;
	}
	final String? mentionId = jsonConvert.convert<String>(json['MentionId']);
	if (mentionId != null) {
		postsModelPostMentions.mentionId = mentionId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelPostMentions.postId = postId;
	}
	final PostsModelPostMentionsMention? mention = jsonConvert.convert<PostsModelPostMentionsMention>(json['Mention']);
	if (mention != null) {
		postsModelPostMentions.mention = mention;
	}
	return postsModelPostMentions;
}

Map<String, dynamic> $PostsModelPostMentionsToJson(PostsModelPostMentions entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['MentionId'] = entity.mentionId;
	data['PostId'] = entity.postId;
	data['Mention'] = entity.mention?.toJson();
	return data;
}

PostsModelPostMentionsMention $PostsModelPostMentionsMentionFromJson(Map<String, dynamic> json) {
	final PostsModelPostMentionsMention postsModelPostMentionsMention = PostsModelPostMentionsMention();
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		postsModelPostMentionsMention.username = username;
	}
	return postsModelPostMentionsMention;
}

Map<String, dynamic> $PostsModelPostMentionsMentionToJson(PostsModelPostMentionsMention entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['username'] = entity.username;
	return data;
}

PostsModelPoll $PostsModelPollFromJson(Map<String, dynamic> json) {
	final PostsModelPoll postsModelPoll = PostsModelPoll();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPoll.id = id;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelPoll.postId = postId;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		postsModelPoll.profileId = profileId;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		postsModelPoll.isPaid = isPaid;
	}
	final double? amount = jsonConvert.convert<double>(json['amount']);
	if (amount != null) {
		postsModelPoll.amount = amount;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		postsModelPoll.currentState = currentState;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		postsModelPoll.description = description;
	}
	final bool? showResult = jsonConvert.convert<bool>(json['showResult']);
	if (showResult != null) {
		postsModelPoll.showResult = showResult;
	}
	final bool? schedule = jsonConvert.convert<bool>(json['schedule']);
	if (schedule != null) {
		postsModelPoll.schedule = schedule;
	}
	final bool? showOptionResult = jsonConvert.convert<bool>(json['showOptionResult']);
	if (showOptionResult != null) {
		postsModelPoll.showOptionResult = showOptionResult;
	}
	final String? pollCategory = jsonConvert.convert<String>(json['pollCategory']);
	if (pollCategory != null) {
		postsModelPoll.pollCategory = pollCategory;
	}
	final String? startDate = jsonConvert.convert<String>(json['startDate']);
	if (startDate != null) {
		postsModelPoll.startDate = startDate;
	}
	final String? endDate = jsonConvert.convert<String>(json['endDate']);
	if (endDate != null) {
		postsModelPoll.endDate = endDate;
	}
	final String? startTime = jsonConvert.convert<String>(json['startTime']);
	if (startTime != null) {
		postsModelPoll.startTime = startTime;
	}
	final String? endTime = jsonConvert.convert<String>(json['endTime']);
	if (endTime != null) {
		postsModelPoll.endTime = endTime;
	}
	final String? pollExpire = jsonConvert.convert<String>(json['pollExpire']);
	if (pollExpire != null) {
		postsModelPoll.pollExpire = pollExpire;
	}
	final double? voteLimit = jsonConvert.convert<double>(json['voteLimit']);
	if (voteLimit != null) {
		postsModelPoll.voteLimit = voteLimit;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelPoll.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		postsModelPoll.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		postsModelPoll.shareCount = shareCount;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelPoll.sV = sV;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		postsModelPoll.isDeleted = isDeleted;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelPoll.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelPoll.updatedAt = updatedAt;
	}
	final List<PostsModelPollPollOptions>? pollOptions = jsonConvert.convertListNotNull<PostsModelPollPollOptions>(json['PollOptions']);
	if (pollOptions != null) {
		postsModelPoll.pollOptions = pollOptions;
	}
	final List<PostsModelPollVotePayments>? votePayments = jsonConvert.convertListNotNull<PostsModelPollVotePayments>(json['VotePayments']);
	if (votePayments != null) {
		postsModelPoll.votePayments = votePayments;
	}
	final double? totalVotesCountPoll = jsonConvert.convert<double>(json['totalVotesCountPoll']);
	if (totalVotesCountPoll != null) {
		postsModelPoll.totalVotesCountPoll = totalVotesCountPoll;
	}
	final double? totalAmount = jsonConvert.convert<double>(json['totalAmount']);
	if (totalAmount != null) {
		postsModelPoll.totalAmount = totalAmount;
	}
	final String? lastUserChoice = jsonConvert.convert<String>(json['lastUserChoice']);
	if (lastUserChoice != null) {
		postsModelPoll.lastUserChoice = lastUserChoice;
	}
	final bool? userVoted = jsonConvert.convert<bool>(json['userVoted']);
	if (userVoted != null) {
		postsModelPoll.userVoted = userVoted;
	}
	final double? totalVotesLoggedInUser = jsonConvert.convert<double>(json['totalVotesLoggedInUser']);
	if (totalVotesLoggedInUser != null) {
		postsModelPoll.totalVotesLoggedInUser = totalVotesLoggedInUser;
	}
	return postsModelPoll;
}

Map<String, dynamic> $PostsModelPollToJson(PostsModelPoll entity) {
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
	data['VotePayments'] =  entity.votePayments?.map((v) => v.toJson()).toList();
	data['totalVotesCountPoll'] = entity.totalVotesCountPoll;
	data['totalAmount'] = entity.totalAmount;
	data['lastUserChoice'] = entity.lastUserChoice;
	data['userVoted'] = entity.userVoted;
	data['totalVotesLoggedInUser'] = entity.totalVotesLoggedInUser;
	return data;
}

PostsModelPollPollOptions $PostsModelPollPollOptionsFromJson(Map<String, dynamic> json) {
	final PostsModelPollPollOptions postsModelPollPollOptions = PostsModelPollPollOptions();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPollPollOptions.id = id;
	}
	final double? position = jsonConvert.convert<double>(json['position']);
	if (position != null) {
		postsModelPollPollOptions.position = position;
	}
	final String? option = jsonConvert.convert<String>(json['option']);
	if (option != null) {
		postsModelPollPollOptions.option = option;
	}
	final String? mediaUrl = jsonConvert.convert<String>(json['media_url']);
	if (mediaUrl != null) {
		postsModelPollPollOptions.mediaUrl = mediaUrl;
	}
	final String? mediaType = jsonConvert.convert<String>(json['media_type']);
	if (mediaType != null) {
		postsModelPollPollOptions.mediaType = mediaType;
	}
	final String? shortDesc = jsonConvert.convert<String>(json['short_desc']);
	if (shortDesc != null) {
		postsModelPollPollOptions.shortDesc = shortDesc;
	}
	final List<PostsModelPollPollOptionsVotes>? votes = jsonConvert.convertListNotNull<PostsModelPollPollOptionsVotes>(json['Votes']);
	if (votes != null) {
		postsModelPollPollOptions.votes = votes;
	}
	final double? totalVotesCountPollOption = jsonConvert.convert<double>(json['totalVotesCountPollOption']);
	if (totalVotesCountPollOption != null) {
		postsModelPollPollOptions.totalVotesCountPollOption = totalVotesCountPollOption;
	}
	final bool? userVoted = jsonConvert.convert<bool>(json['userVoted']);
	if (userVoted != null) {
		postsModelPollPollOptions.userVoted = userVoted;
	}
	return postsModelPollPollOptions;
}

Map<String, dynamic> $PostsModelPollPollOptionsToJson(PostsModelPollPollOptions entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['position'] = entity.position;
	data['option'] = entity.option;
	data['media_url'] = entity.mediaUrl;
	data['media_type'] = entity.mediaType;
	data['short_desc'] = entity.shortDesc;
	data['Votes'] =  entity.votes?.map((v) => v.toJson()).toList();
	data['totalVotesCountPollOption'] = entity.totalVotesCountPollOption;
	data['userVoted'] = entity.userVoted;
	return data;
}

PostsModelPollPollOptionsVotes $PostsModelPollPollOptionsVotesFromJson(Map<String, dynamic> json) {
	final PostsModelPollPollOptionsVotes postsModelPollPollOptionsVotes = PostsModelPollPollOptionsVotes();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPollPollOptionsVotes.id = id;
	}
	final String? voterId = jsonConvert.convert<String>(json['VoterId']);
	if (voterId != null) {
		postsModelPollPollOptionsVotes.voterId = voterId;
	}
	final String? pollOptionId = jsonConvert.convert<String>(json['PollOptionId']);
	if (pollOptionId != null) {
		postsModelPollPollOptionsVotes.pollOptionId = pollOptionId;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelPollPollOptionsVotes.millisecCreatedAt = millisecCreatedAt;
	}
	return postsModelPollPollOptionsVotes;
}

Map<String, dynamic> $PostsModelPollPollOptionsVotesToJson(PostsModelPollPollOptionsVotes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['VoterId'] = entity.voterId;
	data['PollOptionId'] = entity.pollOptionId;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	return data;
}

PostsModelPollVotePayments $PostsModelPollVotePaymentsFromJson(Map<String, dynamic> json) {
	final PostsModelPollVotePayments postsModelPollVotePayments = PostsModelPollVotePayments();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelPollVotePayments.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		postsModelPollVotePayments.profileId = profileId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelPollVotePayments.postId = postId;
	}
	final String? pollId = jsonConvert.convert<String>(json['PollId']);
	if (pollId != null) {
		postsModelPollVotePayments.pollId = pollId;
	}
	final String? pollOptionId = jsonConvert.convert<String>(json['PollOptionId']);
	if (pollOptionId != null) {
		postsModelPollVotePayments.pollOptionId = pollOptionId;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelPollVotePayments.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		postsModelPollVotePayments.millisecUpdatedAt = millisecUpdatedAt;
	}
	final double? amount = jsonConvert.convert<double>(json['amount']);
	if (amount != null) {
		postsModelPollVotePayments.amount = amount;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelPollVotePayments.sV = sV;
	}
	final dynamic? paymentRef = jsonConvert.convert<dynamic>(json['paymentRef']);
	if (paymentRef != null) {
		postsModelPollVotePayments.paymentRef = paymentRef;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelPollVotePayments.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelPollVotePayments.updatedAt = updatedAt;
	}
	return postsModelPollVotePayments;
}

Map<String, dynamic> $PostsModelPollVotePaymentsToJson(PostsModelPollVotePayments entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['PostId'] = entity.postId;
	data['PollId'] = entity.pollId;
	data['PollOptionId'] = entity.pollOptionId;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['amount'] = entity.amount;
	data['_v'] = entity.sV;
	data['paymentRef'] = entity.paymentRef;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

PostsModelPollVotes $PostsModelPollVotesFromJson(Map<String, dynamic> json) {
	final PostsModelPollVotes postsModelPollVotes = PostsModelPollVotes();
	final double? noWords = jsonConvert.convert<double>(json['No words']);
	if (noWords != null) {
		postsModelPollVotes.noWords = noWords;
	}
	final double? godAbeg = jsonConvert.convert<double>(json['God abeg ']);
	if (godAbeg != null) {
		postsModelPollVotes.godAbeg = godAbeg;
	}
	final double? nothingMuch = jsonConvert.convert<double>(json['Nothing much']);
	if (nothingMuch != null) {
		postsModelPollVotes.nothingMuch = nothingMuch;
	}
	final double? nothingActually = jsonConvert.convert<double>(json['Nothing actually ']);
	if (nothingActually != null) {
		postsModelPollVotes.nothingActually = nothingActually;
	}
	return postsModelPollVotes;
}

Map<String, dynamic> $PostsModelPollVotesToJson(PostsModelPollVotes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['No words'] = entity.noWords;
	data['God abeg '] = entity.godAbeg;
	data['Nothing much'] = entity.nothingMuch;
	data['Nothing actually '] = entity.nothingActually;
	return data;
}

PostsModelProduct $PostsModelProductFromJson(Map<String, dynamic> json) {
	final PostsModelProduct postsModelProduct = PostsModelProduct();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelProduct.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		postsModelProduct.profileId = profileId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelProduct.postId = postId;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		postsModelProduct.name = name;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		postsModelProduct.description = description;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelProduct.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		postsModelProduct.millisecUpdatedAt = millisecUpdatedAt;
	}
	final double? amount = jsonConvert.convert<double>(json['amount']);
	if (amount != null) {
		postsModelProduct.amount = amount;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		postsModelProduct.isDeleted = isDeleted;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		postsModelProduct.currentState = currentState;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		postsModelProduct.shareCount = shareCount;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelProduct.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelProduct.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelProduct.updatedAt = updatedAt;
	}
	final List<PostsModelProductProductImages>? productImages = jsonConvert.convertListNotNull<PostsModelProductProductImages>(json['ProductImages']);
	if (productImages != null) {
		postsModelProduct.productImages = productImages;
	}
	return postsModelProduct;
}

Map<String, dynamic> $PostsModelProductToJson(PostsModelProduct entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['PostId'] = entity.postId;
	data['name'] = entity.name;
	data['description'] = entity.description;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['amount'] = entity.amount;
	data['isDeleted'] = entity.isDeleted;
	data['currentState'] = entity.currentState;
	data['shareCount'] = entity.shareCount;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['ProductImages'] =  entity.productImages?.map((v) => v.toJson()).toList();
	return data;
}

PostsModelProductProductImages $PostsModelProductProductImagesFromJson(Map<String, dynamic> json) {
	final PostsModelProductProductImages postsModelProductProductImages = PostsModelProductProductImages();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelProductProductImages.id = id;
	}
	final String? productId = jsonConvert.convert<String>(json['ProductId']);
	if (productId != null) {
		postsModelProductProductImages.productId = productId;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		postsModelProductProductImages.imageUrl = imageUrl;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelProductProductImages.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelProductProductImages.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelProductProductImages.updatedAt = updatedAt;
	}
	return postsModelProductProductImages;
}

Map<String, dynamic> $PostsModelProductProductImagesToJson(PostsModelProductProductImages entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProductId'] = entity.productId;
	data['imageUrl'] = entity.imageUrl;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

PostsModelDonation $PostsModelDonationFromJson(Map<String, dynamic> json) {
	final PostsModelDonation postsModelDonation = PostsModelDonation();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelDonation.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		postsModelDonation.profileId = profileId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		postsModelDonation.postId = postId;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		postsModelDonation.title = title;
	}
	final dynamic? orgName = jsonConvert.convert<dynamic>(json['orgName']);
	if (orgName != null) {
		postsModelDonation.orgName = orgName;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		postsModelDonation.description = description;
	}
	final String? ownerDescription = jsonConvert.convert<String>(json['ownerDescription']);
	if (ownerDescription != null) {
		postsModelDonation.ownerDescription = ownerDescription;
	}
	final String? impact = jsonConvert.convert<String>(json['impact']);
	if (impact != null) {
		postsModelDonation.impact = impact;
	}
	final String? amountJustification = jsonConvert.convert<String>(json['amountJustification']);
	if (amountJustification != null) {
		postsModelDonation.amountJustification = amountJustification;
	}
	final double? estimatedAmount = jsonConvert.convert<double>(json['estimatedAmount']);
	if (estimatedAmount != null) {
		postsModelDonation.estimatedAmount = estimatedAmount;
	}
	final double? currentAmount = jsonConvert.convert<double>(json['currentAmount']);
	if (currentAmount != null) {
		postsModelDonation.currentAmount = currentAmount;
	}
	final double? minimumAmount = jsonConvert.convert<double>(json['minimumAmount']);
	if (minimumAmount != null) {
		postsModelDonation.minimumAmount = minimumAmount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		postsModelDonation.shareCount = shareCount;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		postsModelDonation.imageUrl = imageUrl;
	}
	final bool? isClosed = jsonConvert.convert<bool>(json['isClosed']);
	if (isClosed != null) {
		postsModelDonation.isClosed = isClosed;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		postsModelDonation.currentState = currentState;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		postsModelDonation.isDeleted = isDeleted;
	}
	final bool? displayTotalDonation = jsonConvert.convert<bool>(json['displayTotalDonation']);
	if (displayTotalDonation != null) {
		postsModelDonation.displayTotalDonation = displayTotalDonation;
	}
	final bool? displayNumberOfDonors = jsonConvert.convert<bool>(json['displayNumberOfDonors']);
	if (displayNumberOfDonors != null) {
		postsModelDonation.displayNumberOfDonors = displayNumberOfDonors;
	}
	final String? donationExpiresAt = jsonConvert.convert<String>(json['donationExpiresAt']);
	if (donationExpiresAt != null) {
		postsModelDonation.donationExpiresAt = donationExpiresAt;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelDonation.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		postsModelDonation.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelDonation.sV = sV;
	}
	final bool? isPrivate = jsonConvert.convert<bool>(json['isPrivate']);
	if (isPrivate != null) {
		postsModelDonation.isPrivate = isPrivate;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelDonation.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelDonation.updatedAt = updatedAt;
	}
	final List<PostsModelDonationDonationImages>? donationImages = jsonConvert.convertListNotNull<PostsModelDonationDonationImages>(json['DonationImages']);
	if (donationImages != null) {
		postsModelDonation.donationImages = donationImages;
	}
	final List<dynamic>? donate = jsonConvert.convertListNotNull<dynamic>(json['Donate']);
	if (donate != null) {
		postsModelDonation.donate = donate;
	}
	final double? amountRaised = jsonConvert.convert<double>(json['amountRaised']);
	if (amountRaised != null) {
		postsModelDonation.amountRaised = amountRaised;
	}
	final double? totalDonors = jsonConvert.convert<double>(json['totalDonors']);
	if (totalDonors != null) {
		postsModelDonation.totalDonors = totalDonors;
	}
	final bool? userDonated = jsonConvert.convert<bool>(json['userDonated']);
	if (userDonated != null) {
		postsModelDonation.userDonated = userDonated;
	}
	return postsModelDonation;
}

Map<String, dynamic> $PostsModelDonationToJson(PostsModelDonation entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProfileId'] = entity.profileId;
	data['PostId'] = entity.postId;
	data['title'] = entity.title;
	data['orgName'] = entity.orgName;
	data['description'] = entity.description;
	data['ownerDescription'] = entity.ownerDescription;
	data['impact'] = entity.impact;
	data['amountJustification'] = entity.amountJustification;
	data['estimatedAmount'] = entity.estimatedAmount;
	data['currentAmount'] = entity.currentAmount;
	data['minimumAmount'] = entity.minimumAmount;
	data['shareCount'] = entity.shareCount;
	data['imageUrl'] = entity.imageUrl;
	data['isClosed'] = entity.isClosed;
	data['currentState'] = entity.currentState;
	data['isDeleted'] = entity.isDeleted;
	data['displayTotalDonation'] = entity.displayTotalDonation;
	data['displayNumberOfDonors'] = entity.displayNumberOfDonors;
	data['donationExpiresAt'] = entity.donationExpiresAt;
	data['millisecCreatedAt'] = entity.millisecCreatedAt;
	data['millisecUpdatedAt'] = entity.millisecUpdatedAt;
	data['_v'] = entity.sV;
	data['isPrivate'] = entity.isPrivate;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['DonationImages'] =  entity.donationImages?.map((v) => v.toJson()).toList();
	data['Donate'] =  entity.donate;
	data['amountRaised'] = entity.amountRaised;
	data['totalDonors'] = entity.totalDonors;
	data['userDonated'] = entity.userDonated;
	return data;
}

PostsModelDonationDonationImages $PostsModelDonationDonationImagesFromJson(Map<String, dynamic> json) {
	final PostsModelDonationDonationImages postsModelDonationDonationImages = PostsModelDonationDonationImages();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelDonationDonationImages.id = id;
	}
	final String? donationId = jsonConvert.convert<String>(json['DonationId']);
	if (donationId != null) {
		postsModelDonationDonationImages.donationId = donationId;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		postsModelDonationDonationImages.imageUrl = imageUrl;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelDonationDonationImages.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelDonationDonationImages.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelDonationDonationImages.updatedAt = updatedAt;
	}
	return postsModelDonationDonationImages;
}

Map<String, dynamic> $PostsModelDonationDonationImagesToJson(PostsModelDonationDonationImages entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['DonationId'] = entity.donationId;
	data['imageUrl'] = entity.imageUrl;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

PostsModelProfile $PostsModelProfileFromJson(Map<String, dynamic> json) {
	final PostsModelProfile postsModelProfile = PostsModelProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		postsModelProfile.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		postsModelProfile.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		postsModelProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		postsModelProfile.bio = bio;
	}
	final double? notificationCount = jsonConvert.convert<double>(json['notificationCount']);
	if (notificationCount != null) {
		postsModelProfile.notificationCount = notificationCount;
	}
	final double? posts = jsonConvert.convert<double>(json['posts']);
	if (posts != null) {
		postsModelProfile.posts = posts;
	}
	final double? groupCount = jsonConvert.convert<double>(json['groupCount']);
	if (groupCount != null) {
		postsModelProfile.groupCount = groupCount;
	}
	final double? pageCount = jsonConvert.convert<double>(json['pageCount']);
	if (pageCount != null) {
		postsModelProfile.pageCount = pageCount;
	}
	final double? followings = jsonConvert.convert<double>(json['followings']);
	if (followings != null) {
		postsModelProfile.followings = followings;
	}
	final double? followers = jsonConvert.convert<double>(json['followers']);
	if (followers != null) {
		postsModelProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		postsModelProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		postsModelProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		postsModelProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		postsModelProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		postsModelProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		postsModelProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		postsModelProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		postsModelProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		postsModelProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		postsModelProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		postsModelProfile.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		postsModelProfile.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		postsModelProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		postsModelProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		postsModelProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		postsModelProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelProfile.updatedAt = updatedAt;
	}
	final PostsModelProfileConnection? connection = jsonConvert.convert<PostsModelProfileConnection>(json['connection']);
	if (connection != null) {
		postsModelProfile.connection = connection;
	}
	return postsModelProfile;
}

Map<String, dynamic> $PostsModelProfileToJson(PostsModelProfile entity) {
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

PostsModelProfileConnection $PostsModelProfileConnectionFromJson(Map<String, dynamic> json) {
	final PostsModelProfileConnection postsModelProfileConnection = PostsModelProfileConnection();
	return postsModelProfileConnection;
}

Map<String, dynamic> $PostsModelProfileConnectionToJson(PostsModelProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}

PostsModelEngagement $PostsModelEngagementFromJson(Map<String, dynamic> json) {
	final PostsModelEngagement postsModelEngagement = PostsModelEngagement();
	final double? viewCount = jsonConvert.convert<double>(json['viewCount']);
	if (viewCount != null) {
		postsModelEngagement.viewCount = viewCount;
	}
	final double? likeCount = jsonConvert.convert<double>(json['likeCount']);
	if (likeCount != null) {
		postsModelEngagement.likeCount = likeCount;
	}
	final double? repostCount = jsonConvert.convert<double>(json['repostCount']);
	if (repostCount != null) {
		postsModelEngagement.repostCount = repostCount;
	}
	final double? commentCount = jsonConvert.convert<double>(json['commentCount']);
	if (commentCount != null) {
		postsModelEngagement.commentCount = commentCount;
	}
	final double? bookmarkCount = jsonConvert.convert<double>(json['bookmarkCount']);
	if (bookmarkCount != null) {
		postsModelEngagement.bookmarkCount = bookmarkCount;
	}
	return postsModelEngagement;
}

Map<String, dynamic> $PostsModelEngagementToJson(PostsModelEngagement entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['viewCount'] = entity.viewCount;
	data['likeCount'] = entity.likeCount;
	data['repostCount'] = entity.repostCount;
	data['commentCount'] = entity.commentCount;
	data['bookmarkCount'] = entity.bookmarkCount;
	return data;
}

PostsModelOriginalOwner $PostsModelOriginalOwnerFromJson(Map<String, dynamic> json) {
	final PostsModelOriginalOwner postsModelOriginalOwner = PostsModelOriginalOwner();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelOriginalOwner.id = id;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		postsModelOriginalOwner.description = description;
	}
	final dynamic? type = jsonConvert.convert<dynamic>(json['type']);
	if (type != null) {
		postsModelOriginalOwner.type = type;
	}
	final dynamic? kind = jsonConvert.convert<dynamic>(json['kind']);
	if (kind != null) {
		postsModelOriginalOwner.kind = kind;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		postsModelOriginalOwner.profileId = profileId;
	}
	final dynamic? groupId = jsonConvert.convert<dynamic>(json['GroupId']);
	if (groupId != null) {
		postsModelOriginalOwner.groupId = groupId;
	}
	final dynamic? pageId = jsonConvert.convert<dynamic>(json['PageId']);
	if (pageId != null) {
		postsModelOriginalOwner.pageId = pageId;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		postsModelOriginalOwner.isDeleted = isDeleted;
	}
	final bool? isPoll = jsonConvert.convert<bool>(json['isPoll']);
	if (isPoll != null) {
		postsModelOriginalOwner.isPoll = isPoll;
	}
	final bool? isPromoted = jsonConvert.convert<bool>(json['isPromoted']);
	if (isPromoted != null) {
		postsModelOriginalOwner.isPromoted = isPromoted;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		postsModelOriginalOwner.isPaid = isPaid;
	}
	final String? viewsCount = jsonConvert.convert<String>(json['viewsCount']);
	if (viewsCount != null) {
		postsModelOriginalOwner.viewsCount = viewsCount;
	}
	final String? likeCount = jsonConvert.convert<String>(json['likeCount']);
	if (likeCount != null) {
		postsModelOriginalOwner.likeCount = likeCount;
	}
	final String? unLikeCount = jsonConvert.convert<String>(json['unLikeCount']);
	if (unLikeCount != null) {
		postsModelOriginalOwner.unLikeCount = unLikeCount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		postsModelOriginalOwner.shareCount = shareCount;
	}
	final String? commentCount = jsonConvert.convert<String>(json['commentCount']);
	if (commentCount != null) {
		postsModelOriginalOwner.commentCount = commentCount;
	}
	final String? repostCount = jsonConvert.convert<String>(json['repostCount']);
	if (repostCount != null) {
		postsModelOriginalOwner.repostCount = repostCount;
	}
	final bool? repostedPost = jsonConvert.convert<bool>(json['repostedPost']);
	if (repostedPost != null) {
		postsModelOriginalOwner.repostedPost = repostedPost;
	}
	final bool? isRepostWithComment = jsonConvert.convert<bool>(json['isRepostWithComment']);
	if (isRepostWithComment != null) {
		postsModelOriginalOwner.isRepostWithComment = isRepostWithComment;
	}
	final String? originalPostId = jsonConvert.convert<String>(json['OriginalPostId']);
	if (originalPostId != null) {
		postsModelOriginalOwner.originalPostId = originalPostId;
	}
	final String? reposterProfileId = jsonConvert.convert<String>(json['ReposterProfileId']);
	if (reposterProfileId != null) {
		postsModelOriginalOwner.reposterProfileId = reposterProfileId;
	}
	final String? repostCommentDesc = jsonConvert.convert<String>(json['repostCommentDesc']);
	if (repostCommentDesc != null) {
		postsModelOriginalOwner.repostCommentDesc = repostCommentDesc;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		postsModelOriginalOwner.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		postsModelOriginalOwner.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelOriginalOwner.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelOriginalOwner.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelOriginalOwner.updatedAt = updatedAt;
	}
	final List<dynamic>? postImages = jsonConvert.convertListNotNull<dynamic>(json['PostImages']);
	if (postImages != null) {
		postsModelOriginalOwner.postImages = postImages;
	}
	final List<dynamic>? postTags = jsonConvert.convertListNotNull<dynamic>(json['PostTags']);
	if (postTags != null) {
		postsModelOriginalOwner.postTags = postTags;
	}
	final List<dynamic>? postMentions = jsonConvert.convertListNotNull<dynamic>(json['PostMentions']);
	if (postMentions != null) {
		postsModelOriginalOwner.postMentions = postMentions;
	}
	final dynamic? promotion = jsonConvert.convert<dynamic>(json['Promotion']);
	if (promotion != null) {
		postsModelOriginalOwner.promotion = promotion;
	}
	final dynamic? poll = jsonConvert.convert<dynamic>(json['Poll']);
	if (poll != null) {
		postsModelOriginalOwner.poll = poll;
	}
	final dynamic? product = jsonConvert.convert<dynamic>(json['Product']);
	if (product != null) {
		postsModelOriginalOwner.product = product;
	}
	final dynamic? donation = jsonConvert.convert<dynamic>(json['Donation']);
	if (donation != null) {
		postsModelOriginalOwner.donation = donation;
	}
	final PostsModelOriginalOwnerProfile? profile = jsonConvert.convert<PostsModelOriginalOwnerProfile>(json['Profile']);
	if (profile != null) {
		postsModelOriginalOwner.profile = profile;
	}
	return postsModelOriginalOwner;
}

Map<String, dynamic> $PostsModelOriginalOwnerToJson(PostsModelOriginalOwner entity) {
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
	data['PostImages'] =  entity.postImages;
	data['PostTags'] =  entity.postTags;
	data['PostMentions'] =  entity.postMentions;
	data['Promotion'] = entity.promotion;
	data['Poll'] = entity.poll;
	data['Product'] = entity.product;
	data['Donation'] = entity.donation;
	data['Profile'] = entity.profile?.toJson();
	return data;
}

PostsModelOriginalOwnerProfile $PostsModelOriginalOwnerProfileFromJson(Map<String, dynamic> json) {
	final PostsModelOriginalOwnerProfile postsModelOriginalOwnerProfile = PostsModelOriginalOwnerProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		postsModelOriginalOwnerProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		postsModelOriginalOwnerProfile.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		postsModelOriginalOwnerProfile.avatar = avatar;
	}
	final String? coverImage = jsonConvert.convert<String>(json['coverImage']);
	if (coverImage != null) {
		postsModelOriginalOwnerProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		postsModelOriginalOwnerProfile.bio = bio;
	}
	final double? notificationCount = jsonConvert.convert<double>(json['notificationCount']);
	if (notificationCount != null) {
		postsModelOriginalOwnerProfile.notificationCount = notificationCount;
	}
	final double? posts = jsonConvert.convert<double>(json['posts']);
	if (posts != null) {
		postsModelOriginalOwnerProfile.posts = posts;
	}
	final double? groupCount = jsonConvert.convert<double>(json['groupCount']);
	if (groupCount != null) {
		postsModelOriginalOwnerProfile.groupCount = groupCount;
	}
	final double? pageCount = jsonConvert.convert<double>(json['pageCount']);
	if (pageCount != null) {
		postsModelOriginalOwnerProfile.pageCount = pageCount;
	}
	final double? followings = jsonConvert.convert<double>(json['followings']);
	if (followings != null) {
		postsModelOriginalOwnerProfile.followings = followings;
	}
	final double? followers = jsonConvert.convert<double>(json['followers']);
	if (followers != null) {
		postsModelOriginalOwnerProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		postsModelOriginalOwnerProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		postsModelOriginalOwnerProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		postsModelOriginalOwnerProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		postsModelOriginalOwnerProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		postsModelOriginalOwnerProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		postsModelOriginalOwnerProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		postsModelOriginalOwnerProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		postsModelOriginalOwnerProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		postsModelOriginalOwnerProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		postsModelOriginalOwnerProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		postsModelOriginalOwnerProfile.fontSize = fontSize;
	}
	final String? phone = jsonConvert.convert<String>(json['phone']);
	if (phone != null) {
		postsModelOriginalOwnerProfile.phone = phone;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		postsModelOriginalOwnerProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		postsModelOriginalOwnerProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		postsModelOriginalOwnerProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		postsModelOriginalOwnerProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		postsModelOriginalOwnerProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		postsModelOriginalOwnerProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		postsModelOriginalOwnerProfile.updatedAt = updatedAt;
	}
	final PostsModelOriginalOwnerProfileConnection? connection = jsonConvert.convert<PostsModelOriginalOwnerProfileConnection>(json['connection']);
	if (connection != null) {
		postsModelOriginalOwnerProfile.connection = connection;
	}
	return postsModelOriginalOwnerProfile;
}

Map<String, dynamic> $PostsModelOriginalOwnerProfileToJson(PostsModelOriginalOwnerProfile entity) {
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

PostsModelOriginalOwnerProfileConnection $PostsModelOriginalOwnerProfileConnectionFromJson(Map<String, dynamic> json) {
	final PostsModelOriginalOwnerProfileConnection postsModelOriginalOwnerProfileConnection = PostsModelOriginalOwnerProfileConnection();
	return postsModelOriginalOwnerProfileConnection;
}

Map<String, dynamic> $PostsModelOriginalOwnerProfileConnectionToJson(PostsModelOriginalOwnerProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}