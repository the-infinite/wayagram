
class MomentViewerResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  MomentViewerResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory MomentViewerResponseModel.fromJson(Map<String, dynamic> json) {
    return MomentViewerResponseModel(
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
  final List<MomentViewer> docs;
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
    required this.nextPage,
    required this.hasPrevPage,
    required this.prevPage,
    required this.pagingCounter,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      docs: (json['docs'] as List).map((doc) => MomentViewer.fromJson(doc)).toList(),
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

class MomentViewer {
  final String id;
  final String momentId;
  final String userId;
  final String? name;
  final String? username;
  final String? image;
  final bool likeMoment;
  final bool comment;
  final DateTime viewedAt;

  MomentViewer({
    required this.id,
    required this.momentId,
    required this.userId,
    this.name,
    this.username,
    this.image,
    required this.likeMoment,
    required this.comment,
    required this.viewedAt,
  });

  factory MomentViewer.fromJson(Map<String, dynamic> json) {
    return MomentViewer(
      id: json['id'],
      momentId: json['momentId'],
      userId: json['userId'],
      name: json['name'],
      username: json['username'],
      image: json['image'],
      likeMoment: json['likeMoment'],
      comment: json['comment'],
      viewedAt: DateTime.parse(json['viewedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'momentId': momentId,
      'userId': userId,
      'name': name,
      'username': username,
      'image': image,
      'likeMoment': likeMoment,
      'comment': comment,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }

  MomentViewer copyWith({
    String? name,
    String? username,
    String? image,
  }) {
    return MomentViewer(
      id: id,
      momentId: momentId,
      userId: userId,
      name: name ?? this.name,
      username: username ?? this.username,
      image: image ?? this.image,
      likeMoment: likeMoment,
      comment: comment,
      viewedAt: viewedAt,
    );
  }
}
