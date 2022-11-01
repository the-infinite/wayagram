import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/products_model_entity.dart';

ProductsModelEntity $ProductsModelEntityFromJson(Map<String, dynamic> json) {
	final ProductsModelEntity productsModelEntity = ProductsModelEntity();
	final List<ProductsModelData>? data = jsonConvert.convertListNotNull<ProductsModelData>(json['data']);
	if (data != null) {
		productsModelEntity.data = data;
	}
	final ProductsModelMetadata? metadata = jsonConvert.convert<ProductsModelMetadata>(json['metadata']);
	if (metadata != null) {
		productsModelEntity.metadata = metadata;
	}
	return productsModelEntity;
}

Map<String, dynamic> $ProductsModelEntityToJson(ProductsModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] =  entity.data?.map((v) => v.toJson()).toList();
	data['metadata'] = entity.metadata?.toJson();
	return data;
}

ProductsModelData $ProductsModelDataFromJson(Map<String, dynamic> json) {
	final ProductsModelData productsModelData = ProductsModelData();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		productsModelData.id = id;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		productsModelData.profileId = profileId;
	}
	final String? postId = jsonConvert.convert<String>(json['PostId']);
	if (postId != null) {
		productsModelData.postId = postId;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		productsModelData.name = name;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		productsModelData.description = description;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		productsModelData.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		productsModelData.millisecUpdatedAt = millisecUpdatedAt;
	}
	final int? amount = jsonConvert.convert<int>(json['amount']);
	if (amount != null) {
		productsModelData.amount = amount;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		productsModelData.isDeleted = isDeleted;
	}
	final String? currentState = jsonConvert.convert<String>(json['currentState']);
	if (currentState != null) {
		productsModelData.currentState = currentState;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		productsModelData.shareCount = shareCount;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		productsModelData.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		productsModelData.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		productsModelData.updatedAt = updatedAt;
	}
	final List<ProductsModelDataProductImages>? productImages = jsonConvert.convertListNotNull<ProductsModelDataProductImages>(json['ProductImages']);
	if (productImages != null) {
		productsModelData.productImages = productImages;
	}
	final List<dynamic>? productTrnx = jsonConvert.convertListNotNull<dynamic>(json['ProductTrnx']);
	if (productTrnx != null) {
		productsModelData.productTrnx = productTrnx;
	}
	final ProductsModelDataPost? post = jsonConvert.convert<ProductsModelDataPost>(json['Post']);
	if (post != null) {
		productsModelData.post = post;
	}
	final int? noOfPurchase = jsonConvert.convert<int>(json['no_of_purchase']);
	if (noOfPurchase != null) {
		productsModelData.noOfPurchase = noOfPurchase;
	}
	final int? likes = jsonConvert.convert<int>(json['likes']);
	if (likes != null) {
		productsModelData.likes = likes;
	}
	final ProductsModelDataProfile? profile = jsonConvert.convert<ProductsModelDataProfile>(json['Profile']);
	if (profile != null) {
		productsModelData.profile = profile;
	}
	return productsModelData;
}

Map<String, dynamic> $ProductsModelDataToJson(ProductsModelData entity) {
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
	data['ProductTrnx'] =  entity.productTrnx;
	data['Post'] = entity.post?.toJson();
	data['no_of_purchase'] = entity.noOfPurchase;
	data['likes'] = entity.likes;
	data['Profile'] = entity.profile?.toJson();
	return data;
}

ProductsModelDataProductImages $ProductsModelDataProductImagesFromJson(Map<String, dynamic> json) {
	final ProductsModelDataProductImages productsModelDataProductImages = ProductsModelDataProductImages();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		productsModelDataProductImages.id = id;
	}
	final String? productId = jsonConvert.convert<String>(json['ProductId']);
	if (productId != null) {
		productsModelDataProductImages.productId = productId;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		productsModelDataProductImages.imageUrl = imageUrl;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		productsModelDataProductImages.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		productsModelDataProductImages.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		productsModelDataProductImages.updatedAt = updatedAt;
	}
	return productsModelDataProductImages;
}

Map<String, dynamic> $ProductsModelDataProductImagesToJson(ProductsModelDataProductImages entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ProductId'] = entity.productId;
	data['imageUrl'] = entity.imageUrl;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

ProductsModelDataPost $ProductsModelDataPostFromJson(Map<String, dynamic> json) {
	final ProductsModelDataPost productsModelDataPost = ProductsModelDataPost();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		productsModelDataPost.id = id;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		productsModelDataPost.description = description;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		productsModelDataPost.type = type;
	}
	final String? kind = jsonConvert.convert<String>(json['kind']);
	if (kind != null) {
		productsModelDataPost.kind = kind;
	}
	final String? profileId = jsonConvert.convert<String>(json['ProfileId']);
	if (profileId != null) {
		productsModelDataPost.profileId = profileId;
	}
	final dynamic? groupId = jsonConvert.convert<dynamic>(json['GroupId']);
	if (groupId != null) {
		productsModelDataPost.groupId = groupId;
	}
	final dynamic? pageId = jsonConvert.convert<dynamic>(json['PageId']);
	if (pageId != null) {
		productsModelDataPost.pageId = pageId;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		productsModelDataPost.isDeleted = isDeleted;
	}
	final bool? isPoll = jsonConvert.convert<bool>(json['isPoll']);
	if (isPoll != null) {
		productsModelDataPost.isPoll = isPoll;
	}
	final bool? isPromoted = jsonConvert.convert<bool>(json['isPromoted']);
	if (isPromoted != null) {
		productsModelDataPost.isPromoted = isPromoted;
	}
	final bool? isPaid = jsonConvert.convert<bool>(json['isPaid']);
	if (isPaid != null) {
		productsModelDataPost.isPaid = isPaid;
	}
	final String? viewsCount = jsonConvert.convert<String>(json['viewsCount']);
	if (viewsCount != null) {
		productsModelDataPost.viewsCount = viewsCount;
	}
	final String? likeCount = jsonConvert.convert<String>(json['likeCount']);
	if (likeCount != null) {
		productsModelDataPost.likeCount = likeCount;
	}
	final String? unLikeCount = jsonConvert.convert<String>(json['unLikeCount']);
	if (unLikeCount != null) {
		productsModelDataPost.unLikeCount = unLikeCount;
	}
	final String? shareCount = jsonConvert.convert<String>(json['shareCount']);
	if (shareCount != null) {
		productsModelDataPost.shareCount = shareCount;
	}
	final String? commentCount = jsonConvert.convert<String>(json['commentCount']);
	if (commentCount != null) {
		productsModelDataPost.commentCount = commentCount;
	}
	final String? repostCount = jsonConvert.convert<String>(json['repostCount']);
	if (repostCount != null) {
		productsModelDataPost.repostCount = repostCount;
	}
	final bool? repostedPost = jsonConvert.convert<bool>(json['repostedPost']);
	if (repostedPost != null) {
		productsModelDataPost.repostedPost = repostedPost;
	}
	final bool? isRepostWithComment = jsonConvert.convert<bool>(json['isRepostWithComment']);
	if (isRepostWithComment != null) {
		productsModelDataPost.isRepostWithComment = isRepostWithComment;
	}
	final dynamic? originalPostId = jsonConvert.convert<dynamic>(json['OriginalPostId']);
	if (originalPostId != null) {
		productsModelDataPost.originalPostId = originalPostId;
	}
	final dynamic? reposterProfileId = jsonConvert.convert<dynamic>(json['ReposterProfileId']);
	if (reposterProfileId != null) {
		productsModelDataPost.reposterProfileId = reposterProfileId;
	}
	final String? repostCommentDesc = jsonConvert.convert<String>(json['repostCommentDesc']);
	if (repostCommentDesc != null) {
		productsModelDataPost.repostCommentDesc = repostCommentDesc;
	}
	final String? millisecCreatedAt = jsonConvert.convert<String>(json['millisecCreatedAt']);
	if (millisecCreatedAt != null) {
		productsModelDataPost.millisecCreatedAt = millisecCreatedAt;
	}
	final String? millisecUpdatedAt = jsonConvert.convert<String>(json['millisecUpdatedAt']);
	if (millisecUpdatedAt != null) {
		productsModelDataPost.millisecUpdatedAt = millisecUpdatedAt;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		productsModelDataPost.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		productsModelDataPost.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		productsModelDataPost.updatedAt = updatedAt;
	}
	return productsModelDataPost;
}

Map<String, dynamic> $ProductsModelDataPostToJson(ProductsModelDataPost entity) {
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
	return data;
}

ProductsModelDataProfile $ProductsModelDataProfileFromJson(Map<String, dynamic> json) {
	final ProductsModelDataProfile productsModelDataProfile = ProductsModelDataProfile();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		productsModelDataProfile.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['UserId']);
	if (userId != null) {
		productsModelDataProfile.userId = userId;
	}
	final dynamic? avatar = jsonConvert.convert<dynamic>(json['avatar']);
	if (avatar != null) {
		productsModelDataProfile.avatar = avatar;
	}
	final dynamic? coverImage = jsonConvert.convert<dynamic>(json['coverImage']);
	if (coverImage != null) {
		productsModelDataProfile.coverImage = coverImage;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		productsModelDataProfile.bio = bio;
	}
	final int? notificationCount = jsonConvert.convert<int>(json['notificationCount']);
	if (notificationCount != null) {
		productsModelDataProfile.notificationCount = notificationCount;
	}
	final int? posts = jsonConvert.convert<int>(json['posts']);
	if (posts != null) {
		productsModelDataProfile.posts = posts;
	}
	final int? groupCount = jsonConvert.convert<int>(json['groupCount']);
	if (groupCount != null) {
		productsModelDataProfile.groupCount = groupCount;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		productsModelDataProfile.pageCount = pageCount;
	}
	final int? followings = jsonConvert.convert<int>(json['followings']);
	if (followings != null) {
		productsModelDataProfile.followings = followings;
	}
	final int? followers = jsonConvert.convert<int>(json['followers']);
	if (followers != null) {
		productsModelDataProfile.followers = followers;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		productsModelDataProfile.username = username;
	}
	final String? displayName = jsonConvert.convert<String>(json['displayName']);
	if (displayName != null) {
		productsModelDataProfile.displayName = displayName;
	}
	final bool? notPublic = jsonConvert.convert<bool>(json['notPublic']);
	if (notPublic != null) {
		productsModelDataProfile.notPublic = notPublic;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		productsModelDataProfile.deleted = deleted;
	}
	final bool? simulatedUser = jsonConvert.convert<bool>(json['simulatedUser']);
	if (simulatedUser != null) {
		productsModelDataProfile.simulatedUser = simulatedUser;
	}
	final bool? isMuted = jsonConvert.convert<bool>(json['isMuted']);
	if (isMuted != null) {
		productsModelDataProfile.isMuted = isMuted;
	}
	final bool? isBan = jsonConvert.convert<bool>(json['isBan']);
	if (isBan != null) {
		productsModelDataProfile.isBan = isBan;
	}
	final bool? isDisabled = jsonConvert.convert<bool>(json['isDisabled']);
	if (isDisabled != null) {
		productsModelDataProfile.isDisabled = isDisabled;
	}
	final bool? isDeactivate = jsonConvert.convert<bool>(json['isDeactivate']);
	if (isDeactivate != null) {
		productsModelDataProfile.isDeactivate = isDeactivate;
	}
	final String? theme = jsonConvert.convert<String>(json['theme']);
	if (theme != null) {
		productsModelDataProfile.theme = theme;
	}
	final String? fontSize = jsonConvert.convert<String>(json['fontSize']);
	if (fontSize != null) {
		productsModelDataProfile.fontSize = fontSize;
	}
	final dynamic? phone = jsonConvert.convert<dynamic>(json['phone']);
	if (phone != null) {
		productsModelDataProfile.phone = phone;
	}
	final dynamic? email = jsonConvert.convert<dynamic>(json['email']);
	if (email != null) {
		productsModelDataProfile.email = email;
	}
	final String? style = jsonConvert.convert<String>(json['style']);
	if (style != null) {
		productsModelDataProfile.style = style;
	}
	final String? streamKey = jsonConvert.convert<String>(json['stream_key']);
	if (streamKey != null) {
		productsModelDataProfile.streamKey = streamKey;
	}
	final dynamic? roleId = jsonConvert.convert<dynamic>(json['roleId']);
	if (roleId != null) {
		productsModelDataProfile.roleId = roleId;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		productsModelDataProfile.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		productsModelDataProfile.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		productsModelDataProfile.updatedAt = updatedAt;
	}
	final ProductsModelDataProfileConnection? connection = jsonConvert.convert<ProductsModelDataProfileConnection>(json['connection']);
	if (connection != null) {
		productsModelDataProfile.connection = connection;
	}
	return productsModelDataProfile;
}

Map<String, dynamic> $ProductsModelDataProfileToJson(ProductsModelDataProfile entity) {
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

ProductsModelDataProfileConnection $ProductsModelDataProfileConnectionFromJson(Map<String, dynamic> json) {
	final ProductsModelDataProfileConnection productsModelDataProfileConnection = ProductsModelDataProfileConnection();
	return productsModelDataProfileConnection;
}

Map<String, dynamic> $ProductsModelDataProfileConnectionToJson(ProductsModelDataProfileConnection entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}

ProductsModelMetadata $ProductsModelMetadataFromJson(Map<String, dynamic> json) {
	final ProductsModelMetadata productsModelMetadata = ProductsModelMetadata();
	final dynamic? previousPage = jsonConvert.convert<dynamic>(json['previousPage']);
	if (previousPage != null) {
		productsModelMetadata.previousPage = previousPage;
	}
	final int? currentPage = jsonConvert.convert<int>(json['currentPage']);
	if (currentPage != null) {
		productsModelMetadata.currentPage = currentPage;
	}
	final int? nextPage = jsonConvert.convert<int>(json['nextPage']);
	if (nextPage != null) {
		productsModelMetadata.nextPage = nextPage;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		productsModelMetadata.total = total;
	}
	final int? limit = jsonConvert.convert<int>(json['limit']);
	if (limit != null) {
		productsModelMetadata.limit = limit;
	}
	return productsModelMetadata;
}

Map<String, dynamic> $ProductsModelMetadataToJson(ProductsModelMetadata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['previousPage'] = entity.previousPage;
	data['currentPage'] = entity.currentPage;
	data['nextPage'] = entity.nextPage;
	data['total'] = entity.total;
	data['limit'] = entity.limit;
	return data;
}