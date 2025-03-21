import 'package:wayagram/shared/features/profile/model/post.dart';

class PostResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  PostResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    return PostResponseModel(
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
  final List<PostModel> docs;
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
      docs: (json['docs'] as List).map((e) => PostModel.fromJson(e)).toList(),
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
