import 'package:json_annotation/json_annotation.dart';

part 'groups.g.dart';

@JsonSerializable()
class GroupModel {
  final String id;
  final String name;
  final String ownerId;
  final int memberCount;
  final String description;
  final bool isOpen;
  final List<String>? categories;
  final String url;
  final bool isPrivate;
  final String coverImage;
  final String profileImage;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  GroupModel({
    required this.id,
    required this.url,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.isOpen,
    required this.ownerId,
    required this.categories,
    required this.isPrivate,
    required this.coverImage,
    required this.profileImage,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
