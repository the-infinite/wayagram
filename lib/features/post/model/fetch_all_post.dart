import 'dart:convert';

import 'package:wayagram/shared/features/profile/model/post.dart';
FetchAllPost fetchAllPostFromJson(String str) => FetchAllPost.fromJson(json.decode(str));
String fetchAllPostToJson(FetchAllPost data) => json.encode(data.toJson());
class FetchAllPost {
  FetchAllPost({
      this.message,
      this.status, 
      this.statusCode, 
      this.data,});

  FetchAllPost.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? FetchAllPostData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  FetchAllPostData? data;
FetchAllPost copyWith({  String? message,
  bool? status,
  num? statusCode,
  FetchAllPostData? data,
}) => FetchAllPost(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

FetchAllPostData dataFromJson(String str) => FetchAllPostData.fromJson(json.decode(str));
String dataToJson(FetchAllPostData data) => json.encode(data.toJson());
class FetchAllPostData {
  FetchAllPostData({
      this.totalDocs, 
      this.docs, 
      this.limit, 
      this.page, 
      this.totalPages, 
      this.hasNextPage, 
      this.nextPage, 
      this.hasPrevPage, 
      this.prevPage,});

  FetchAllPostData.fromJson(dynamic json) {
    totalDocs = json['totalDocs'];
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(PostModel.fromJson(v));
      });
    }
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
  }
  num? totalDocs;
  List<PostModel>? docs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  FetchAllPostData copyWith({  num? totalDocs,
  List<PostModel>? docs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  num? nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
}) => FetchAllPostData(  totalDocs: totalDocs ?? this.totalDocs,
  docs: docs ?? this.docs,
  limit: limit ?? this.limit,
  page: page ?? this.page,
  totalPages: totalPages ?? this.totalPages,
  hasNextPage: hasNextPage ?? this.hasNextPage,
  nextPage: nextPage ?? this.nextPage,
  hasPrevPage: hasPrevPage ?? this.hasPrevPage,
  prevPage: prevPage ?? this.prevPage,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalDocs'] = totalDocs;
    if (docs != null) {
      map['docs'] = docs?.map((v) => v.toJson()).toList();
    }
    map['limit'] = limit;
    map['page'] = page;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    return map;
  }

}

Docs docsFromJson(String str) => Docs.fromJson(json.decode(str));
String docsToJson(Docs data) => json.encode(data.toJson());
class Docs {
  Docs({
      this.id, 
      this.userId, 
      this.groupId, 
      this.pageId, 
      this.contentType, 
      this.content, 
      this.media, 
      this.hashtags, 
      this.sourceType, 
      this.linkedServiceId, 
      this.privacy, 
      this.url, 
      this.status, 
      this.likeCount, 
      this.commentCount, 
      this.shareCount, 
      this.popularityScore, 
      this.isPromoted, 
      this.isReposted, 
      this.promotionExpiry, 
      this.deletedAt, 
      this.originalPostId, 
      this.createdAt, 
      this.updatedAt, 
      this.comments, 
      this.originalPost,});

  Docs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    groupId = json['groupId'];
    pageId = json['pageId'];
    contentType = json['contentType'];
    content = json['content'];
    media = json['media'] != null ? json['media'].cast<String>() : [];
    hashtags = json['hashtags'] != null ? json['hashtags'].cast<String>() : [];
    sourceType = json['sourceType'];
    linkedServiceId = json['linkedServiceId'];
    privacy = json['privacy'];
    url = json['url'];
    status = json['status'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    popularityScore = json['popularityScore'];
    isPromoted = json['isPromoted'];
    isReposted = json['isReposted'];
    promotionExpiry = json['promotionExpiry'];
    deletedAt = json['deletedAt'];
    originalPostId = json['originalPostId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        //comments?.add(Dynamic.fromJson(v));
      });
    }
    if (json['originalPost'] != null) {
      originalPost = [];
      json['originalPost'].forEach((v) {
        //originalPost?.add(Dynamic.fromJson(v));
      });
    }
  }
  String? id;
  String? userId;
  dynamic groupId;
  dynamic pageId;
  String? contentType;
  String? content;
  List<String>? media;
  List<String>? hashtags;
  String? sourceType;
  dynamic linkedServiceId;
  String? privacy;
  dynamic url;
  String? status;
  num? likeCount;
  num? commentCount;
  num? shareCount;
  num? popularityScore;
  bool? isPromoted;
  bool? isReposted;
  dynamic promotionExpiry;
  dynamic deletedAt;
  dynamic originalPostId;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? comments;
  List<dynamic>? originalPost;
Docs copyWith({  String? id,
  String? userId,
  dynamic groupId,
  dynamic pageId,
  String? contentType,
  String? content,
  List<String>? media,
  List<String>? hashtags,
  String? sourceType,
  dynamic linkedServiceId,
  String? privacy,
  dynamic url,
  String? status,
  num? likeCount,
  num? commentCount,
  num? shareCount,
  num? popularityScore,
  bool? isPromoted,
  bool? isReposted,
  dynamic promotionExpiry,
  dynamic deletedAt,
  dynamic originalPostId,
  String? createdAt,
  String? updatedAt,
  List<dynamic>? comments,
  List<dynamic>? originalPost,
}) => Docs(  id: id ?? this.id,
  userId: userId ?? this.userId,
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
  comments: comments ?? this.comments,
  originalPost: originalPost ?? this.originalPost,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['groupId'] = groupId;
    map['pageId'] = pageId;
    map['contentType'] = contentType;
    map['content'] = content;
    map['media'] = media;
    map['hashtags'] = hashtags;
    map['sourceType'] = sourceType;
    map['linkedServiceId'] = linkedServiceId;
    map['privacy'] = privacy;
    map['url'] = url;
    map['status'] = status;
    map['likeCount'] = likeCount;
    map['commentCount'] = commentCount;
    map['shareCount'] = shareCount;
    map['popularityScore'] = popularityScore;
    map['isPromoted'] = isPromoted;
    map['isReposted'] = isReposted;
    map['promotionExpiry'] = promotionExpiry;
    map['deletedAt'] = deletedAt;
    map['originalPostId'] = originalPostId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    if (originalPost != null) {
      map['originalPost'] = originalPost?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}