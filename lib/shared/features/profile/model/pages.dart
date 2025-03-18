import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

part 'pages.g.dart';

@JsonSerializable()
class PageModel {
  final String id;
  final int followerCount;
  final String ownerId;
  final String name;
  final String description;
  final bool isPublic;
  final String? coverImage;
  final List<String>? categories;
  final String? url;
  final String? profileImage;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserDetailsModel? owner;

  PageModel({
    required this.id,
    required this.followerCount,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.isPublic,
    required this.coverImage,
    required this.categories,
    required this.url,
    required this.profileImage,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) => _$PageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageModelToJson(this);
}
