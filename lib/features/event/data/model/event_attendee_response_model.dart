class AttendeeResponse {
  final String message;
  final bool status;
  final int statusCode;
  final ResponseData data;

  AttendeeResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory AttendeeResponse.fromJson(Map<String, dynamic> json) {
    return AttendeeResponse(
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
  final List<Doc> docs;
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
      docs: (json['docs'] as List).map((e) => Doc.fromJson(e)).toList(),
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
      'docs': docs.map((e) => e.toJson()).toList(),
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

class Doc {
  final String id;
  final String userId;
  final String eventId;
  final int amountPaid;
  final String paymentStatus;
  final String status;
  final String eventType;
  final bool isDeleted;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String username;
  final String? bio;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  Doc({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.amountPaid,
    required this.paymentStatus,
    required this.status,
    required this.eventType,
    required this.isDeleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.bio,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory Doc.fromJson(Map<String, dynamic> json) {
    return Doc(
      id: json['id'],
      userId: json['userId'],
      eventId: json['eventId'],
      amountPaid: json['amountPaid'],
      paymentStatus: json['paymentStatus'],
      status: json['status'],
      eventType: json['eventType'],
      isDeleted: json['isDeleted'],
      version: json['_v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      username: json['username'],
      bio: json['bio'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'amountPaid': amountPaid,
      'paymentStatus': paymentStatus,
      'status': status,
      'eventType': eventType,
      'isDeleted': isDeleted,
      '_v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'username': username,
      'bio': bio,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}


class FollowStatusResponse {
  final String message;
  final bool status;
  final int statusCode;
  final FollowStatus data;

  FollowStatusResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory FollowStatusResponse.fromJson(Map<String, dynamic> json) {
    return FollowStatusResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: FollowStatus.fromJson(json['data']),
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

class FollowStatus {
  final bool isFollowing;
  final bool isFollowedBy;
  final bool isMutual;
  final String status;

  FollowStatus({
    required this.isFollowing,
    required this.isFollowedBy,
    required this.isMutual,
    required this.status,
  });

  factory FollowStatus.fromJson(Map<String, dynamic> json) {
    return FollowStatus(
      isFollowing: json['isFollowing'],
      isFollowedBy: json['isFollowedBy'],
      isMutual: json['isMutual'],
      status: json['status'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFollowing': isFollowing,
      'isFollowedBy': isFollowedBy,
      'isMutual': isMutual,
      'status': status,
    };
  }
}
