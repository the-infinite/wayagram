import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

part 'fetch_comment.g.dart';

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
        comments?.add(CommentModel.fromJson(v));
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
  List<CommentModel>? comments;
  num? page;
  num? limit;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  FetchCommentData copyWith({
    num? total,
    List<CommentModel>? comments,
    num? page,
    num? limit,
    num? totalPages,
    bool? hasNextPage,
    num? nextPage,
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

@JsonSerializable()
class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final bool? isLiked;
  final String? parentCommentId;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserDetailsModel? user;
  
  CommentModel({
    required this.id,
    required this.isLiked,
    required this.postId,
    required this.userId,
    required this.content,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.parentCommentId,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    bool? isLiked,
    String? parentCommentId,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserDetailsModel? user,
  }) =>
      CommentModel(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        isLiked: isLiked ?? this.isLiked,
        parentCommentId: parentCommentId ?? this.parentCommentId,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        shareCount: shareCount ?? this.shareCount,
        deletedAt: deletedAt ?? this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );
}
