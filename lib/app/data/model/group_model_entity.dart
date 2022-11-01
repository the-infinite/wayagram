import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/group_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class GroupModelEntity {
	String? id;
	String? userId;
	String? category;
	dynamic categoryId;
	dynamic customCategory;
	String? name;
	String? description;
	String? imageUrl;
	String? headerImageUrl;
	bool? isPublic;
	bool? mute;
	bool? isDeleted;
	bool? allowMemberPost;
	bool? simulated;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	double? numberOfMembers;
	bool? isUserAMember;
	bool? isUserAdmin;
	bool? isUserOnMute;
  
  GroupModelEntity();

  factory GroupModelEntity.fromJson(Map<String, dynamic> json) => $GroupModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $GroupModelEntityToJson(this);

	static List<GroupModelEntity> getService(List<dynamic> val) {
		return val.map((e) => GroupModelEntity.fromJson(e)).toList();
	}

  @override
  String toString() {
    return jsonEncode(this);
  }

	@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupModelEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}