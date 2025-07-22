import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/model/base_model.dart';

part 'groups.g.dart';

@JsonSerializable()
class GroupModel extends BaseModel<GroupModel> {
  final String id;
  final String name;
  final String? ownerId;
  final int memberCount;
  final String description;
  final bool isOpen;
  final bool approveJoinRequest;
  final List<String>? categories;
  final String? url;
  final bool isPrivate;
  final String? coverImage;
  final String? mutedAt;
  final String? profileImage;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get engagementCount => memberCount;

  GroupModel({
    required this.id,
    required this.url,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.isOpen,
    required this.approveJoinRequest,
    required this.ownerId,
    required this.categories,
    required this.isPrivate,
    required this.coverImage,
    required this.mutedAt,
    required this.profileImage,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  Map<String, dynamic> toMap() => toJson();
}
