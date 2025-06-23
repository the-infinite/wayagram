import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/model/base_model.dart';

part 'post.g.dart';

@JsonSerializable()
class PostModel extends BaseModel<PostModel> {
  final String id;
  final String userId;
  final List<String>? categories;
  final String? groupId;
  final String? pageId;
  final dynamic contentType;
  final dynamic content;
  final List<String> media;
  final List<dynamic> hashtags;
  final String? sourceType;
  final String? linkedServiceId;
  final String? privacy;
  final String? url;
  final String? status;
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
  final PostModel? originalPost;
  final UserDetailsModel? user;
  final PageModel? page;
  final GroupModel? group;
  @JsonKey(defaultValue: false)
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
    required this.status,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.popularityScore,
    required this.isPromoted,
    required this.isReposted,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
    this.promotionExpiry,
    this.url,
    this.deletedAt,
    this.originalPostId,
    this.user,
    this.page,
    this.group,
    this.originalPost,
  });

  int get engagementCount => commentCount + likeCount + shareCount;

  PostModel copyWith({
    String? id,
    String? userId,
    List<String>? categories,
    String? groupId,
    String? pageId,
    String? contentType,
    String? content,
    List<String>? media,
    List<String>? hashtags,
    String? sourceType,
    String? linkedServiceId,
    String? privacy,
    String? url,
    String? status,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    int? popularityScore,
    bool? isPromoted,
    bool? isReposted,
    DateTime? promotionExpiry,
    DateTime? deletedAt,
    String? originalPostId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic user,
    dynamic page,
    dynamic group,
    bool? isLiked,
    PostModel? originalPost,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categories: categories ?? this.categories,
      groupId: groupId ?? this.groupId,
      pageId: pageId ?? this.pageId,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
      media: media ?? this.media,
      hashtags: hashtags ?? this.hashtags,
      sourceType: sourceType ?? this.sourceType,
      linkedServiceId: linkedServiceId ?? this.linkedServiceId,
      privacy: privacy ?? this.privacy,
      url: url ?? this.url,
      status: status ?? this.status,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      popularityScore: popularityScore ?? this.popularityScore,
      isPromoted: isPromoted ?? this.isPromoted,
      isReposted: isReposted ?? this.isReposted,
      promotionExpiry: promotionExpiry ?? this.promotionExpiry,
      deletedAt: deletedAt ?? this.deletedAt,
      originalPostId: originalPostId ?? this.originalPostId,
      originalPost: originalPost ?? this.originalPost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      page: page ?? this.page,
      group: group ?? this.group,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

//? Using this for search implementation, pls don't remove
  @override
  Map<String, dynamic> toMap() => {'hashtags': hashtags};
}

@JsonSerializable()
class BookmarkModel extends BaseModel<BookmarkModel> {
  final String id;
  final String userId;
  final String postId;
  final PostModel? post;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookmarkModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.post,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) =>
      _$BookmarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkModelToJson(this);

  @override
  Map<String, dynamic> toMap() => toJson();
}
