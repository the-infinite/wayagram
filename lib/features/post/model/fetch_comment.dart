import 'dart:convert';

import 'package:wayagram/shared/features/user/models/default.dart';

FetchComment fetchCommentFromJson(String str) => FetchComment.fromJson(json.decode(str));
String fetchCommentToJson(FetchComment data) => json.encode(data.toJson());

class FetchComment {
  FetchComment({
    this.message,
    this.status,
    this.statusCode,
    this.data,
  });

  FetchComment.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? FetchCommentData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  FetchCommentData? data;
  FetchComment copyWith({
    String? message,
    bool? status,
    num? statusCode,
    FetchCommentData? data,
  }) =>
      FetchComment(
        message: message ?? this.message,
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

FetchCommentData dataFromJson(String str) => FetchCommentData.fromJson(json.decode(str));
String dataToJson(FetchCommentData data) => json.encode(data.toJson());

class FetchCommentData {
  FetchCommentData({
    this.total,
    this.comments,
    this.page,
    this.limit,
    this.totalPages,
    this.hasNextPage,
    this.nextPage,
    this.hasPrevPage,
    this.prevPage,
  });

  FetchCommentData.fromJson(dynamic json) {
    total = json['total'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
  }
  num? total;
  List<Comments>? comments;
  num? page;
  num? limit;
  num? totalPages;
  bool? hasNextPage;
  dynamic nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  FetchCommentData copyWith({
    num? total,
    List<Comments>? comments,
    num? page,
    num? limit,
    num? totalPages,
    bool? hasNextPage,
    dynamic nextPage,
    bool? hasPrevPage,
    dynamic prevPage,
  }) =>
      FetchCommentData(
        total: total ?? this.total,
        comments: comments ?? this.comments,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        totalPages: totalPages ?? this.totalPages,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        nextPage: nextPage ?? this.nextPage,
        hasPrevPage: hasPrevPage ?? this.hasPrevPage,
        prevPage: prevPage ?? this.prevPage,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    return map;
  }
}

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));
String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.parentCommentId,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Comments.fromJson(dynamic json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    content = json['content'];
    parentCommentId = json['parentCommentId'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    deletedAt = json['deletedAt'];
    createdAt = DateTime.tryParse(json['createdAt'].toString());
    updatedAt = DateTime.tryParse(json['updatedAt'].toString());
    user = json['user'] != null ? UserDetailsModel.fromJson(json['user']) : null;
  }
  String? id;
  String? postId;
  String? userId;
  String? content;
  dynamic parentCommentId;
  num? likeCount;
  num? commentCount;
  num? shareCount;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserDetailsModel? user;
  Comments copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    dynamic parentCommentId,
    num? likeCount,
    num? commentCount,
    num? shareCount,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserDetailsModel? user,
  }) =>
      Comments(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        parentCommentId: parentCommentId ?? this.parentCommentId,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        shareCount: shareCount ?? this.shareCount,
        deletedAt: deletedAt ?? this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['postId'] = postId;
    map['userId'] = userId;
    map['content'] = content;
    map['parentCommentId'] = parentCommentId;
    map['likeCount'] = likeCount;
    map['commentCount'] = commentCount;
    map['shareCount'] = shareCount;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}
