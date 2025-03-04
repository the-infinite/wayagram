import 'package:wayagram/shared/model/base_model.dart';

class MomentResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final ResponseData data;

  MomentResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory MomentResponseModel.fromJson(Map<String, dynamic> json) {
    return MomentResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: ResponseData.fromJson(json['data']),
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

class ResponseData {
  final List<MomentData> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;

  ResponseData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.nextPage,
    required this.hasPrevPage,
    required this.prevPage,
    required this.pagingCounter,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      docs: (json['docs'] as List)
          .map((doc) => MomentData.fromJson(doc))
          .toList(),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      page: json['page'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'],
      prevPage: json['prevPage'],
      pagingCounter: json['pagingCounter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docs': docs.map((doc) => doc.toJson()).toList(),
      'totalDocs': totalDocs,
      'limit': limit,
      'page': page,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'nextPage': nextPage,
      'hasPrevPage': hasPrevPage,
      'prevPage': prevPage,
      'pagingCounter': pagingCounter,
    };
  }
}

class MomentData extends BaseModel<MomentData> {
  final String id;
  final String userId;
  final String name;
  final String image;
  final String contentType;
  final String content;
  final String? color;
  final String? fontType;
  final String? caption;
  final int totalViews;
  final int totalLikes;
  final int totalComments;
  final bool active;
  final bool isDeleted;
  final DateTime expiresAt;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;

  MomentData({
    required this.id,
    required this.userId,
    required this.name,
    required this.image,
    required this.contentType,
    required this.content,
    this.caption,
    this.color,
    this.fontType,
    required this.totalViews,
    required this.totalLikes,
    required this.totalComments,
    required this.active,
    required this.isDeleted,
    required this.expiresAt,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MomentData.fromJson(Map<String, dynamic> json) {
    return MomentData(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      image: json['image'],
      contentType: json['contentType'],
      content: json['content'],
      caption: json['caption'],
      color: json['color'],
      totalViews: json['totalViews'],
      totalLikes: json['totalLikes'],
      totalComments: json['totalComments'],
      active: json['active'],
      isDeleted: json['isDeleted'],
      fontType: json['fontType'],
      expiresAt: DateTime.parse(json['expiresAt']),
      version: json['_v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'image': image,
      'contentType': contentType,
      'content': content,
      'caption': caption,
      'totalViews': totalViews,
      'color': color,
      'fontType': fontType,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'active': active,
      'isDeleted': isDeleted,
      'expiresAt': expiresAt.toIso8601String(),
      '_v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toMap() => {'caption': caption};
}
