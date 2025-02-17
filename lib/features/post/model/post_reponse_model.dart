import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/model/base_model.dart';

class PostReponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  PostReponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory PostReponseModel.fromJson(Map<String, dynamic> json) {
    return PostReponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class Data {
  final List<Post> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;

  Data({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    this.nextPage,
    required this.hasPrevPage,
    this.prevPage,
    required this.pagingCounter,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      docs: (json['docs'] as List).map((e) => Post.fromJson(e)).toList(),
      totalDocs: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      nextPage: json["nextPage"],
      hasPrevPage: json["hasPrevPage"],
      prevPage: json["prevPage"],
      pagingCounter: json["pagingCounter"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docs': docs.map((e) => e.toJson()).toList(),
    };
  }
}

class Post extends BaseModel<Post> {
  final String id;
  final String userId;
  final List<dynamic>? categories;
  final String? groupId;
  final String? pageId;
  final String contentType;
  final String content;
  final List<String> media;
  final List<String> hashtags;
  final String sourceType;
  final String? linkedServiceId;
  final String privacy;
  final String? url;
  final String status;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final double popularityScore;
  final bool isPromoted;
  final bool isReposted;
  final String? promotionExpiry;
  final String? deletedAt;
  final String? originalPostId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserDetailsModel user;

  Post({
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
    this.linkedServiceId,
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
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      categories: json['categories'],
      groupId: json['groupId'],
      pageId: json['pageId'],
      contentType: json['contentType'],
      content: json['content'],
      media: List<String>.from(json['media']),
      hashtags: List<String>.from(json['hashtags']),
      sourceType: json['sourceType'],
      linkedServiceId: json['linkedServiceId'],
      privacy: json['privacy'],
      url: json['url'],
      status: json['status'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
      popularityScore: (json['popularityScore'] as num).toDouble(),
      isPromoted: json['isPromoted'],
      isReposted: json['isReposted'],
      promotionExpiry: json['promotionExpiry'],
      deletedAt: json['deletedAt'],
      originalPostId: json['originalPostId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: UserDetailsModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'categories': categories,
      'groupId': groupId,
      'pageId': pageId,
      'contentType': contentType,
      'content': content,
      'media': media,
      'hashtags': hashtags,
      'sourceType': sourceType,
      'linkedServiceId': linkedServiceId,
      'privacy': privacy,
      'url': url,
      'status': status,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'popularityScore': popularityScore,
      'isPromoted': isPromoted,
      'isReposted': isReposted,
      'promotionExpiry': promotionExpiry,
      'deletedAt': deletedAt,
      'originalPostId': originalPostId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  Post copyWith({
    String? id,
    String? userId,
    List<dynamic>? categories,
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
    double? popularityScore,
    bool? isPromoted,
    bool? isReposted,
    String? promotionExpiry,
    String? deletedAt,
    String? originalPostId,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserDetailsModel? user,
  }) {
    return Post(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return toJson();
  }
}
