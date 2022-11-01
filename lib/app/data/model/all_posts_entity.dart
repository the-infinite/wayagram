import 'package:wayagram/app/data/model/posts_model_entity.dart';
import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/all_posts_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class AllPostsEntity {
	String? id;
	String? description;
	String? type;
	dynamic kind;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "GroupId")
	dynamic groupId;
	@JSONField(name: "PageId")
	dynamic pageId;
	bool? isDeleted;
	bool? isPoll;
	bool? isPromoted;
	bool? isPaid;
	String? viewsCount;
	double? likeCount;
	String? unLikeCount;
	String? shareCount;
	String? commentCount;
	String? repostCount;
	bool? repostedPost;
	bool? isRepostWithComment;
	@JSONField(name: "OriginalPostId")
	String? originalPostId;
	@JSONField(name: "ReposterProfileId")
	String? reposterProfileId;
	String? repostCommentDesc;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "PostImages")
	List<PostsModelPostImages>? postImages;
	@JSONField(name: "PostTags")
	List<PostsModelPostTags>? postTags;
	@JSONField(name: "PostMentions")
	List<PostsModelPostMentions>? postMentions;
	@JSONField(name: "Promotion")
	dynamic promotion;
	@JSONField(name: "Poll")
	AllPostsPoll? poll;
	@JSONField(name: "Product")
	dynamic product;
	@JSONField(name: "Donation")
	dynamic donation;
	bool? isPagePost;
	@JSONField(name: "Profile")
	AllPostsProfile? profile;
	bool? isLiked;
	bool? isBookmarked;
	double? postCount;
	bool? isRepost;
	String? repostedBy;
	@JSONField(name: "Engagement")
	AllPostsEngagement? engagement;
	@JSONField(name: "OriginalOwner")
	AllPostsOriginalOwner? originalOwner;
  
  AllPostsEntity();

  factory AllPostsEntity.fromJson(Map<String, dynamic> json) => $AllPostsEntityFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsEntityToJson(this);

	static List<AllPostsEntity> getService(List<dynamic> val) {
		return val.map((e) => AllPostsEntity.fromJson(e)).toList();
	}

  @override
  String toString() {
    return jsonEncode(this);
  }

	@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllPostsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class AllPostsPoll {

	String? id;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "ProfileId")
	String? profileId;
	bool? isPaid;
	double? amount;
	String? currentState;
	String? description;
	bool? showResult;
	bool? schedule;
	bool? showOptionResult;
	String? pollCategory;
	String? startDate;
	String? endDate;
	String? startTime;
	String? endTime;
	String? pollExpire;
	double? voteLimit;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	String? shareCount;
	@JSONField(name: "_v")
	String? sV;
	bool? isDeleted;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "PollOptions")
	List<AllPostsPollPollOptions>? pollOptions;
	@JSONField(name: "VotePayments")
	List<dynamic>? votePayments;
	@JSONField(name: "Votes")
	AllPostsPollVotes? votes;
	double? totalVotesCountPoll;
	double? totalAmount;
	String? lastUserChoice;
	bool? userVoted;
	double? totalVotesLoggedInUser;
  
  AllPostsPoll();

  factory AllPostsPoll.fromJson(Map<String, dynamic> json) => $AllPostsPollFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsPollToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsPollPollOptions {

	String? id;
	double? position;
	String? option;
	@JSONField(name: "media_url")
	dynamic mediaUrl;
	@JSONField(name: "media_type")
	dynamic mediaType;
	@JSONField(name: "short_desc")
	String? shortDesc;
	@JSONField(name: "Votes")
	List<dynamic>? votes;
	double? totalVotesCountPollOption;
	bool? userVoted;
  
  AllPostsPollPollOptions();

  factory AllPostsPollPollOptions.fromJson(Map<String, dynamic> json) => $AllPostsPollPollOptionsFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsPollPollOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsPollVotes {

	@JSONField(name: "River Stynx")
	double? riverStynx;
	@JSONField(name: "Mississippi ")
	double? mississippi ;
	@JSONField(name: "Nile")
	double? nile;
  
  AllPostsPollVotes();

  factory AllPostsPollVotes.fromJson(Map<String, dynamic> json) => $AllPostsPollVotesFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsPollVotesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsProfile {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	dynamic avatar;
	dynamic coverImage;
	String? bio;
	double? notificationCount;
	double? posts;
	double? groupCount;
	double? pageCount;
	double? followings;
	double? followers;
	String? username;
	String? displayName;
	bool? notPublic;
	bool? deleted;
	bool? simulatedUser;
	bool? isMuted;
	bool? isBan;
	bool? isDisabled;
	bool? isDeactivate;
	String? theme;
	String? fontSize;
	dynamic phone;
	dynamic email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	AllPostsProfileConnection? connection;
  
  AllPostsProfile();

  factory AllPostsProfile.fromJson(Map<String, dynamic> json) => $AllPostsProfileFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsProfileConnection {


  
  AllPostsProfileConnection();

  factory AllPostsProfileConnection.fromJson(Map<String, dynamic> json) => $AllPostsProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsEngagement {

	double? viewCount;
	double? likeCount;
	double? repostCount;
	double? commentCount;
	double? bookmarkCount;
  
  AllPostsEngagement();

  factory AllPostsEngagement.fromJson(Map<String, dynamic> json) => $AllPostsEngagementFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsEngagementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwner {

	String? id;
	String? description;
	String? type;
	dynamic kind;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "GroupId")
	dynamic groupId;
	@JSONField(name: "PageId")
	dynamic pageId;
	bool? isDeleted;
	bool? isPoll;
	bool? isPromoted;
	bool? isPaid;
	String? viewsCount;
	String? likeCount;
	String? unLikeCount;
	String? shareCount;
	String? commentCount;
	String? repostCount;
	bool? repostedPost;
	bool? isRepostWithComment;
	@JSONField(name: "OriginalPostId")
	dynamic originalPostId;
	@JSONField(name: "ReposterProfileId")
	dynamic reposterProfileId;
	String? repostCommentDesc;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "PostImages")
	List<PostsModelPostImages>? postImages;
	@JSONField(name: "PostTags")
	List<PostsModelPostTags>? postTags;
	@JSONField(name: "PostMentions")
	List<PostsModelPostMentions>? postMentions;
	@JSONField(name: "Promotion")
	dynamic promotion;
	@JSONField(name: "Poll")
	AllPostsOriginalOwnerPoll? poll;
	@JSONField(name: "Product")
	dynamic product;
	@JSONField(name: "Donation")
	dynamic donation;
	@JSONField(name: "Profile")
	AllPostsOriginalOwnerProfile? profile;
  
  AllPostsOriginalOwner();

  factory AllPostsOriginalOwner.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPostTags {

	String? id;
	@JSONField(name: "HashtagId")
	String? hashtagId;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "HashTag")
	AllPostsOriginalOwnerPostTagsHashTag? hashTag;
  
  AllPostsOriginalOwnerPostTags();

  factory AllPostsOriginalOwnerPostTags.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPostTagsFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPostTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPostTagsHashTag {

	String? hashtag;
  
  AllPostsOriginalOwnerPostTagsHashTag();

  factory AllPostsOriginalOwnerPostTagsHashTag.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPostTagsHashTagFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPostTagsHashTagToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPostMentions {

	String? id;
	@JSONField(name: "MentionId")
	String? mentionId;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "Mention")
	AllPostsOriginalOwnerPostMentionsMention? mention;
  
  AllPostsOriginalOwnerPostMentions();

  factory AllPostsOriginalOwnerPostMentions.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPostMentionsFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPostMentionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPostMentionsMention {

	String? username;
  
  AllPostsOriginalOwnerPostMentionsMention();

  factory AllPostsOriginalOwnerPostMentionsMention.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPostMentionsMentionFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPostMentionsMentionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPoll {

	String? id;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "ProfileId")
	String? profileId;
	bool? isPaid;
	double? amount;
	String? currentState;
	String? description;
	bool? showResult;
	bool? schedule;
	bool? showOptionResult;
	String? pollCategory;
	String? startDate;
	String? endDate;
	String? startTime;
	String? endTime;
	String? pollExpire;
	double? voteLimit;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	String? shareCount;
	@JSONField(name: "_v")
	String? sV;
	bool? isDeleted;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "PollOptions")
	List<AllPostsOriginalOwnerPollPollOptions>? pollOptions;
	@JSONField(name: "VotePayments")
	List<dynamic>? votePayments;
	@JSONField(name: "Votes")
	AllPostsOriginalOwnerPollVotes? votes;
	double? totalVotesCount;
	double? totalAmount;
	String? lastUserChoice;
	bool? userVoted;
	double? totalVotesLoggedInUser;
  
  AllPostsOriginalOwnerPoll();

  factory AllPostsOriginalOwnerPoll.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPollFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPollToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPollPollOptions {

	String? id;
	double? position;
	String? option;
	@JSONField(name: "media_url")
	dynamic mediaUrl;
	@JSONField(name: "media_type")
	dynamic mediaType;
	@JSONField(name: "short_desc")
	String? shortDesc;
	@JSONField(name: "Votes")
	List<dynamic>? votes;
	double? totalVotesCountPollOption;
	bool? userVoted;
  
  AllPostsOriginalOwnerPollPollOptions();

  factory AllPostsOriginalOwnerPollPollOptions.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPollPollOptionsFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPollPollOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerPollVotes {

	@JSONField(name: "Nile")
	double? nile;
	@JSONField(name: "Mississippi ")
	double? mississippi ;
	@JSONField(name: "River Stynx")
	double? riverStynx;
  
  AllPostsOriginalOwnerPollVotes();

  factory AllPostsOriginalOwnerPollVotes.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerPollVotesFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerPollVotesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerProfile {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	dynamic avatar;
	dynamic coverImage;
	String? bio;
	double? notificationCount;
	double? posts;
	double? groupCount;
	double? pageCount;
	double? followings;
	double? followers;
	String? username;
	String? displayName;
	bool? notPublic;
	bool? deleted;
	bool? simulatedUser;
	bool? isMuted;
	bool? isBan;
	bool? isDisabled;
	bool? isDeactivate;
	String? theme;
	String? fontSize;
	dynamic phone;
	dynamic email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	AllPostsOriginalOwnerProfileConnection? connection;
  
  AllPostsOriginalOwnerProfile();

  factory AllPostsOriginalOwnerProfile.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerProfileFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllPostsOriginalOwnerProfileConnection {


  
  AllPostsOriginalOwnerProfileConnection();

  factory AllPostsOriginalOwnerProfileConnection.fromJson(Map<String, dynamic> json) => $AllPostsOriginalOwnerProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $AllPostsOriginalOwnerProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}