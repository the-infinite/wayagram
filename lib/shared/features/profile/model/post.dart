import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

part 'post.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String userId;
  final List<String>? categories;
  final String? groupId;
  final String? pageId;
  final String contentType;
  final String content;
  final List<String> media;
  final List<String> hashtags;
  final String sourceType;
  final String linkedServiceId;
  final String privacy;
  final String? url;
  final String status;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int popularityScore;
  final bool isPromoted;
  final bool isReposted;
  final DateTime? promotionExpiry;
  final DateTime? deletedAt;
  final String? originalPostId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserDetailsModel? user;
  final PageModel? page;
  final GroupModel? group;
  final bool isLiked;

  PostModel({
    required this.id,
    required this.userId,
    this.categories,
    this.groupId,
    this.pageId,
    required this.contentType,
    required this.content,
    required this.media,
    required this.hashtags,
    required this.sourceType,
    required this.linkedServiceId,
    required this.privacy,
    this.url,
    required this.status,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.popularityScore,
    required this.isPromoted,
    required this.isReposted,
    this.promotionExpiry,
    this.deletedAt,
    this.originalPostId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.page,
    this.group,
    required this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
