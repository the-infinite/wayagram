import 'package:wayagram/features/event/data/model/event_response_model.dart';

class JoinedEventResponse {
  final String message;
  final bool status;
  final int statusCode;
  final ResponseData data;

  JoinedEventResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory JoinedEventResponse.fromJson(Map<String, dynamic> json) {
    return JoinedEventResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: ResponseData.fromJson(json['data']),
    );
  }
}

class ResponseData {
  final List<EDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;
  final Metadata metadata;

  ResponseData({
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
    required this.metadata,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      docs: List<EDoc>.from(json['docs'].map((doc) => EDoc.fromJson(doc))),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      page: json['page'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'],
      prevPage: json['prevPage'],
      pagingCounter: json['pagingCounter'],
      metadata: Metadata.fromJson(json['metadata']),
    );
  }
}

class EDoc {
  final String id;
  final String userId;
  final String eventId;
  final double amountPaid;
  final String paymentStatus;
  final String status;
  final String eventType;
  final bool isDeleted;
  final double version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventDoc eventDetails;
  final String username;
  final String? bio;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  EDoc({
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
    required this.eventDetails,
    required this.username,
    this.bio,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory EDoc.fromJson(Map<String, dynamic> json) {
    return EDoc(
      id: json['id'],
      userId: json['userId'],
      eventId: json['eventId'],
      amountPaid: json['amountPaid'].toDouble(),
      paymentStatus: json['paymentStatus'],
      status: json['status'],
      eventType: json['eventType'],
      isDeleted: json['isDeleted'],
      version: json['_v'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      eventDetails: EventDoc.fromJson(json['eventDetails']),
      username: json['username'],
      bio: json['bio'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }
}


 
class Metadata {
  final int offset;
  final bool searchApplied;
  final List<dynamic> searchFields;
  final Map<String, dynamic> appliedFilters;

  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      offset: json['offset'],
      searchApplied: json['searchApplied'],
      searchFields: json['searchFields'],
      appliedFilters: Map<String, dynamic>.from(json['appliedFilters']),
    );
  }
}
