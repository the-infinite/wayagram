import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/products_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ProductsModelEntity {

	List<ProductsModelData>? data;
	ProductsModelMetadata? metadata;
  
  ProductsModelEntity();

  factory ProductsModelEntity.fromJson(Map<String, dynamic> json) => $ProductsModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductsModelData {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "PostId")
	String? postId;
	String? name;
	String? description;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	int? amount;
	bool? isDeleted;
	String? currentState;
	String? shareCount;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "ProductImages")
	List<ProductsModelDataProductImages>? productImages;
	@JSONField(name: "ProductTrnx")
	List<dynamic>? productTrnx;
	@JSONField(name: "Post")
	ProductsModelDataPost? post;
	@JSONField(name: "no_of_purchase")
	int? noOfPurchase;
	int? likes;
	@JSONField(name: "Profile")
	ProductsModelDataProfile? profile;
  
  ProductsModelData();

  factory ProductsModelData.fromJson(Map<String, dynamic> json) => $ProductsModelDataFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductsModelDataProductImages {

	String? id;
	@JSONField(name: "ProductId")
	String? productId;
	String? imageUrl;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
  
  ProductsModelDataProductImages();

  factory ProductsModelDataProductImages.fromJson(Map<String, dynamic> json) => $ProductsModelDataProductImagesFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelDataProductImagesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductsModelDataPost {

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
  
  ProductsModelDataPost();

  factory ProductsModelDataPost.fromJson(Map<String, dynamic> json) => $ProductsModelDataPostFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelDataPostToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductsModelDataProfile {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	dynamic avatar;
	dynamic coverImage;
	String? bio;
	int? notificationCount;
	int? posts;
	int? groupCount;
	int? pageCount;
	int? followings;
	int? followers;
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
	ProductsModelDataProfileConnection? connection;
  
  ProductsModelDataProfile();

  factory ProductsModelDataProfile.fromJson(Map<String, dynamic> json) => $ProductsModelDataProfileFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelDataProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductsModelDataProfileConnection {


  
  ProductsModelDataProfileConnection();

  factory ProductsModelDataProfileConnection.fromJson(Map<String, dynamic> json) => $ProductsModelDataProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelDataProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductsModelMetadata {

	dynamic previousPage;
	int? currentPage;
	int? nextPage;
	int? total;
	int? limit;
  
  ProductsModelMetadata();

  factory ProductsModelMetadata.fromJson(Map<String, dynamic> json) => $ProductsModelMetadataFromJson(json);

  Map<String, dynamic> toJson() => $ProductsModelMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}