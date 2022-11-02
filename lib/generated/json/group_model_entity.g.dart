import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/group_model_entity.dart';

GroupModelEntity $GroupModelEntityFromJson(Map<String, dynamic> json) {
	final GroupModelEntity groupModelEntity = GroupModelEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		groupModelEntity.id = id;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		groupModelEntity.userId = userId;
	}
	final String? category = jsonConvert.convert<String>(json['category']);
	if (category != null) {
		groupModelEntity.category = category;
	}
	final dynamic? categoryId = jsonConvert.convert<dynamic>(json['categoryId']);
	if (categoryId != null) {
		groupModelEntity.categoryId = categoryId;
	}
	final dynamic? customCategory = jsonConvert.convert<dynamic>(json['customCategory']);
	if (customCategory != null) {
		groupModelEntity.customCategory = customCategory;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		groupModelEntity.name = name;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		groupModelEntity.description = description;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		groupModelEntity.imageUrl = imageUrl;
	}
	final String? headerImageUrl = jsonConvert.convert<String>(json['headerImageUrl']);
	if (headerImageUrl != null) {
		groupModelEntity.headerImageUrl = headerImageUrl;
	}
	final bool? isPublic = jsonConvert.convert<bool>(json['isPublic']);
	if (isPublic != null) {
		groupModelEntity.isPublic = isPublic;
	}
	final bool? mute = jsonConvert.convert<bool>(json['mute']);
	if (mute != null) {
		groupModelEntity.mute = mute;
	}
	final bool? isDeleted = jsonConvert.convert<bool>(json['isDeleted']);
	if (isDeleted != null) {
		groupModelEntity.isDeleted = isDeleted;
	}
	final bool? allowMemberPost = jsonConvert.convert<bool>(json['allowMemberPost']);
	if (allowMemberPost != null) {
		groupModelEntity.allowMemberPost = allowMemberPost;
	}
	final bool? simulated = jsonConvert.convert<bool>(json['simulated']);
	if (simulated != null) {
		groupModelEntity.simulated = simulated;
	}
	final String? sV = jsonConvert.convert<String>(json['_v']);
	if (sV != null) {
		groupModelEntity.sV = sV;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		groupModelEntity.createdAt = createdAt;
	}
	final String? updatedAt = jsonConvert.convert<String>(json['updatedAt']);
	if (updatedAt != null) {
		groupModelEntity.updatedAt = updatedAt;
	}
	final double? numberOfMembers = jsonConvert.convert<double>(json['numberOfMembers']);
	if (numberOfMembers != null) {
		groupModelEntity.numberOfMembers = numberOfMembers;
	}
	final bool? isUserAMember = jsonConvert.convert<bool>(json['isUserAMember']);
	if (isUserAMember != null) {
		groupModelEntity.isUserAMember = isUserAMember;
	}
	final bool? isUserAdmin = jsonConvert.convert<bool>(json['isUserAdmin']);
	if (isUserAdmin != null) {
		groupModelEntity.isUserAdmin = isUserAdmin;
	}
	final bool? isUserOnMute = jsonConvert.convert<bool>(json['isUserOnMute']);
	if (isUserOnMute != null) {
		groupModelEntity.isUserOnMute = isUserOnMute;
	}
	return groupModelEntity;
}

Map<String, dynamic> $GroupModelEntityToJson(GroupModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['category'] = entity.category;
	data['categoryId'] = entity.categoryId;
	data['customCategory'] = entity.customCategory;
	data['name'] = entity.name;
	data['description'] = entity.description;
	data['imageUrl'] = entity.imageUrl;
	data['headerImageUrl'] = entity.headerImageUrl;
	data['isPublic'] = entity.isPublic;
	data['mute'] = entity.mute;
	data['isDeleted'] = entity.isDeleted;
	data['allowMemberPost'] = entity.allowMemberPost;
	data['simulated'] = entity.simulated;
	data['_v'] = entity.sV;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['numberOfMembers'] = entity.numberOfMembers;
	data['isUserAMember'] = entity.isUserAMember;
	data['isUserAdmin'] = entity.isUserAdmin;
	data['isUserOnMute'] = entity.isUserOnMute;
	return data;
}