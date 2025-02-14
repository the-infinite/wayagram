import 'package:wayagram/shared/features/user/models/default.dart';

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

class Post {
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
}
