class TransactionPayoutResponse {
  final String message;
  final bool status;
  final int statusCode;
  final TransactionPayoutData data;

  TransactionPayoutResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory TransactionPayoutResponse.fromJson(Map<String, dynamic> json) {
    return TransactionPayoutResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: TransactionPayoutData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'statusCode': statusCode,
        'data': data.toJson(),
      };
}

class TransactionPayoutData {
  final List<TransactionDoc> docs;
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

  TransactionPayoutData({
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

  factory TransactionPayoutData.fromJson(Map<String, dynamic> json) {
    return TransactionPayoutData(
      docs: (json['docs'] as List)
          .map((e) => TransactionDoc.fromJson(e))
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
      metadata: Metadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
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
        'metadata': metadata.toJson(),
      };
}

class TransactionDoc {
  final String id;
  final String eventId;
  final String userId;
  final int totalAmount;
  final int amountToBePaid;
  final int commission;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventTransaction eventTransactions;

  TransactionDoc({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.totalAmount,
    required this.amountToBePaid,
    required this.commission,
    required this.createdAt,
    required this.updatedAt,
    required this.eventTransactions,
  });

  factory TransactionDoc.fromJson(Map<String, dynamic> json) {
    return TransactionDoc(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      totalAmount: json['totalAmount'],
      amountToBePaid: json['amountToBePaid'],
      commission: json['commission'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      eventTransactions: EventTransaction.fromJson(json['eventTransactions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'userId': userId,
        'totalAmount': totalAmount,
        'amountToBePaid': amountToBePaid,
        'commission': commission,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'eventTransactions': eventTransactions.toJson(),
      };
}

class EventTransaction {
  final String id;
  final String userId;
  final String image;
  final String title;
  final String organizerName;
  final String? description;
  final String location;
  final String locationAddress;
  final String startDate;
  final String endDate;
    final DateTime? ticketSalesStartDate;
  final DateTime? ticketSalesEndDate;
  final String startTime;
  final String endTime;
  final String payoutStatus;
  final String eventType;
  final String eventstatus;
  final String status;
  final int fee;
  final int totalRevenue;
  final int? maxCapacity;
  final int noOfAttendees;
  final String privacyOption;
  final String v;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventTransaction({
    required this.id,
    required this.userId,
    required this.image,
    required this.title,
    required this.organizerName,
     this.description,
    required this.location,
    required this.locationAddress,
    required this.startDate,
    required this.endDate,
     this.ticketSalesStartDate,
     this.ticketSalesEndDate,
    required this.startTime,
    required this.endTime,
    required this.payoutStatus,
    required this.eventType,
    required this.eventstatus,
    required this.status,
    required this.fee,
    required this.totalRevenue,
     this.maxCapacity,
    required this.noOfAttendees,
    required this.privacyOption,
    required this.v,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventTransaction.fromJson(Map<String, dynamic> json) {
    return EventTransaction(
      id: json['id'],
      userId: json['userId'],
      image: json['image'],
      title: json['title'],
      organizerName: json['organizerName'],
      description: json['description'],
      location: json['location'],
      locationAddress: json['locationAddress'],
      startDate: json['startDate'],
      endDate: json['endDate'],
        ticketSalesStartDate: json["ticketSalesStartDate"] != null
            ? DateTime.parse(json["ticketSalesStartDate"])
            : null,
        ticketSalesEndDate: json["ticketSalesEndDate"] != null
            ? DateTime.parse(json["ticketSalesEndDate"])
            : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      payoutStatus: json['payoutStatus'],
      eventType: json['eventType'],
      eventstatus: json['eventstatus'],
      status: json['status'],
      fee: json['fee'],
      totalRevenue: json['totalRevenue'],
      maxCapacity: json['maxCapacity'],
      noOfAttendees: json['noOfAttendees'],
      privacyOption: json['privacyOption'],
      v: json['_v'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'image': image,
        'title': title,
        'organizerName': organizerName,
        'description': description,
        'location': location,
        'locationAddress': locationAddress,
        'startDate': startDate,
        'endDate': endDate,
        'ticketSalesStartDate': ticketSalesStartDate,
        'ticketSalesEndDate': ticketSalesEndDate,
        'startTime': startTime,
        'endTime': endTime,
        'payoutStatus': payoutStatus,
        'eventType': eventType,
        'eventstatus': eventstatus,
        'status': status,
        'fee': fee,
        'totalRevenue': totalRevenue,
        'maxCapacity': maxCapacity,
        'noOfAttendees': noOfAttendees,
        'privacyOption': privacyOption,
        '_v': v,
        'isDeleted': isDeleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
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

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'searchApplied': searchApplied,
        'searchFields': searchFields,
        'appliedFilters': appliedFilters,
      };
}
