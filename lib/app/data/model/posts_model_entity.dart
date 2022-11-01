import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/posts_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class PostsModelEntity {

	String? id;
	String? description;
	String? type;
	String? kind;
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
	PostsModelPoll? poll;
	@JSONField(name: "Product")
	PostsModelProduct? product;
	@JSONField(name: "Donation")
	PostsModelDonation? donation;
	bool? isPagePost;
	@JSONField(name: "Profile")
	PostsModelProfile? profile;
	bool? isLiked;
	bool? isBookmarked;
	double? postCount;
	bool? isRepost;
	String? repostedBy;
	@JSONField(name: "Engagement")
	PostsModelEngagement? engagement;
	@JSONField(name: "OriginalOwner")
	PostsModelOriginalOwner? originalOwner;
  
  PostsModelEntity();

  factory PostsModelEntity.fromJson(Map<String, dynamic> json) => $PostsModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPostImages {

	String? id;
	String? type;
	@JSONField(name: "PostId")
	String? postId;
	String? imageURL;
	bool? isDeleted;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
  
  PostsModelPostImages();

  factory PostsModelPostImages.fromJson(Map<String, dynamic> json) => $PostsModelPostImagesFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPostImagesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPostTags {

	String? id;
	@JSONField(name: "HashtagId")
	String? hashtagId;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "HashTag")
	PostsModelPostTagsHashTag? hashTag;
  
  PostsModelPostTags();

  factory PostsModelPostTags.fromJson(Map<String, dynamic> json) => $PostsModelPostTagsFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPostTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPostTagsHashTag {

	String? hashtag;
  
  PostsModelPostTagsHashTag();

  factory PostsModelPostTagsHashTag.fromJson(Map<String, dynamic> json) => $PostsModelPostTagsHashTagFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPostTagsHashTagToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPostMentions {

	String? id;
	@JSONField(name: "MentionId")
	String? mentionId;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "Mention")
	PostsModelPostMentionsMention? mention;
  
  PostsModelPostMentions();

  factory PostsModelPostMentions.fromJson(Map<String, dynamic> json) => $PostsModelPostMentionsFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPostMentionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPostMentionsMention {

	String? username;
  
  PostsModelPostMentionsMention();

  factory PostsModelPostMentionsMention.fromJson(Map<String, dynamic> json) => $PostsModelPostMentionsMentionFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPostMentionsMentionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPoll {

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
	List<PostsModelPollPollOptions>? pollOptions;
	@JSONField(name: "VotePayments")
	List<PostsModelPollVotePayments>? votePayments;
	//@JSONField(name: "Votes")
	//PostsModelPollVotes? votes;
	double? totalVotesCountPoll;
	double? totalAmount;
	String? lastUserChoice;
	bool? userVoted;
	double? totalVotesLoggedInUser;
  
  PostsModelPoll();

  factory PostsModelPoll.fromJson(Map<String, dynamic> json) => $PostsModelPollFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPollToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPollPollOptions {
	String? id;
	double? position;
	String? option;
	@JSONField(name: "media_url")
	String? mediaUrl;
	@JSONField(name: "media_type")
	String? mediaType;
	@JSONField(name: "short_desc")
	String? shortDesc;
	@JSONField(name: "Votes")
	List<PostsModelPollPollOptionsVotes>? votes;
	double? totalVotesCountPollOption;
	bool? userVoted;
  
  PostsModelPollPollOptions();

  factory PostsModelPollPollOptions.fromJson(Map<String, dynamic> json) => $PostsModelPollPollOptionsFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPollPollOptionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPollPollOptionsVotes {
	String? id;
	@JSONField(name: "VoterId")
	String? voterId;
	@JSONField(name: "PollOptionId")
	String? pollOptionId;
	String? millisecCreatedAt;
  
  PostsModelPollPollOptionsVotes();

  factory PostsModelPollPollOptionsVotes.fromJson(Map<String, dynamic> json) => $PostsModelPollPollOptionsVotesFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPollPollOptionsVotesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPollVotePayments {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "PostId")
	String? postId;
	@JSONField(name: "PollId")
	String? pollId;
	@JSONField(name: "PollOptionId")
	String? pollOptionId;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	double? amount;
	@JSONField(name: "_v")
	String? sV;
	dynamic paymentRef;
	String? createdAt;
	String? updatedAt;
  
  PostsModelPollVotePayments();

  factory PostsModelPollVotePayments.fromJson(Map<String, dynamic> json) => $PostsModelPollVotePaymentsFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPollVotePaymentsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelPollVotes {

	@JSONField(name: "No words")
	double? noWords;
	@JSONField(name: "God abeg ")
	double? godAbeg ;
	@JSONField(name: "Nothing much")
	double? nothingMuch;
	@JSONField(name: "Nothing actually ")
	double? nothingActually ;
  
  PostsModelPollVotes();

  factory PostsModelPollVotes.fromJson(Map<String, dynamic> json) => $PostsModelPollVotesFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelPollVotesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelProduct {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "PostId")
	String? postId;
	String? name;
	String? description;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	double? amount;
	bool? isDeleted;
	String? currentState;
	String? shareCount;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "ProductImages")
	List<PostsModelProductProductImages>? productImages;
  
  PostsModelProduct();

  factory PostsModelProduct.fromJson(Map<String, dynamic> json) => $PostsModelProductFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelProductToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelProductProductImages {

	String? id;
	@JSONField(name: "ProductId")
	String? productId;
	String? imageUrl;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
  
  PostsModelProductProductImages();

  factory PostsModelProductProductImages.fromJson(Map<String, dynamic> json) => $PostsModelProductProductImagesFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelProductProductImagesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelDonation {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "PostId")
	String? postId;
	String? title;
	dynamic orgName;
	String? description;
	String? ownerDescription;
	String? impact;
	String? amountJustification;
	double? estimatedAmount;
	double? currentAmount;
	double? minimumAmount;
	String? shareCount;
	String? imageUrl;
	bool? isClosed;
	String? currentState;
	bool? isDeleted;
	bool? displayTotalDonation;
	bool? displayNumberOfDonors;
	String? donationExpiresAt;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	@JSONField(name: "_v")
	String? sV;
	bool? isPrivate;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "DonationImages")
	List<PostsModelDonationDonationImages>? donationImages;
	@JSONField(name: "Donate")
	List<dynamic>? donate;
	double? amountRaised;
	double? totalDonors;
	bool? userDonated;
  
  PostsModelDonation();

  factory PostsModelDonation.fromJson(Map<String, dynamic> json) => $PostsModelDonationFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelDonationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelDonationDonationImages {

	String? id;
	@JSONField(name: "DonationId")
	String? donationId;
	String? imageUrl;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
  
  PostsModelDonationDonationImages();

  factory PostsModelDonationDonationImages.fromJson(Map<String, dynamic> json) => $PostsModelDonationDonationImagesFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelDonationDonationImagesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelProfile {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	String? avatar;
	String? coverImage;
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
	String? phone;
	String? email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	PostsModelProfileConnection? connection;
  
  PostsModelProfile();

  factory PostsModelProfile.fromJson(Map<String, dynamic> json) => $PostsModelProfileFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelProfileConnection {


  
  PostsModelProfileConnection();

  factory PostsModelProfileConnection.fromJson(Map<String, dynamic> json) => $PostsModelProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelEngagement {

	double? viewCount;
	double? likeCount;
	double? repostCount;
	double? commentCount;
	double? bookmarkCount;
  
  PostsModelEngagement();

  factory PostsModelEngagement.fromJson(Map<String, dynamic> json) => $PostsModelEngagementFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelEngagementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelOriginalOwner {

	String? id;
	String? description;
	dynamic type;
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
	List<dynamic>? postImages;
	@JSONField(name: "PostTags")
	List<dynamic>? postTags;
	@JSONField(name: "PostMentions")
	List<dynamic>? postMentions;
	@JSONField(name: "Promotion")
	dynamic promotion;
	@JSONField(name: "Poll")
	dynamic poll;
	@JSONField(name: "Product")
	dynamic product;
	@JSONField(name: "Donation")
	dynamic donation;
	@JSONField(name: "Profile")
	PostsModelOriginalOwnerProfile? profile;
  
  PostsModelOriginalOwner();

  factory PostsModelOriginalOwner.fromJson(Map<String, dynamic> json) => $PostsModelOriginalOwnerFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelOriginalOwnerToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelOriginalOwnerProfile {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	String? avatar;
	String? coverImage;
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
	String? phone;
	String? email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	PostsModelOriginalOwnerProfileConnection? connection;
  
  PostsModelOriginalOwnerProfile();

  factory PostsModelOriginalOwnerProfile.fromJson(Map<String, dynamic> json) => $PostsModelOriginalOwnerProfileFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelOriginalOwnerProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PostsModelOriginalOwnerProfileConnection {


  
  PostsModelOriginalOwnerProfileConnection();

  factory PostsModelOriginalOwnerProfileConnection.fromJson(Map<String, dynamic> json) => $PostsModelOriginalOwnerProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $PostsModelOriginalOwnerProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}