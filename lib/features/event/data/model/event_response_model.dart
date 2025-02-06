class EventResponse {
  final String message;
  final bool status;
  final int statusCode;
  final EventData data;

  EventResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      message: json["message"],
      status: json["status"],
      statusCode: json["statusCode"],
      data: EventData.fromJson(json["data"]),
    );
  }
}

class EventData {
  final List<EventDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;

  EventData({
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

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      docs: (json["docs"] as List).map((e) => EventDoc.fromJson(e)).toList(),
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
}

class EventDoc {
  final String id;
  final String userId;
  final String image;
  final String title;
  final String organizerName;
  final String description;
  final String location;
  final String locationAddress;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String payoutStatus;
  final String eventType;
  final String eventStatus;
  final int fee;
  final int totalRevenue;
  final int? maxCapacity;
  final int noOfAttendees;
  final String privacyOption;
  final String version;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  EventDoc({
    required this.id,
    required this.userId,
    required this.image,
    required this.title,
    required this.organizerName,
    required this.description,
    required this.location,
    required this.locationAddress,
    required this.startDate, // DateTime object
    required this.endDate, // DateTime object
    required this.startTime,
    required this.endTime,
    required this.payoutStatus,
    required this.eventType,
    required this.eventStatus,
    required this.fee,
    required this.totalRevenue,
    this.maxCapacity,
    required this.noOfAttendees,
    required this.privacyOption,
    required this.version,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventDoc.fromJson(Map<String, dynamic> json) {
    return EventDoc(
      id: json["id"],
      userId: json["userId"],
      image: json["image"],
      title: json["title"],
      organizerName: json["organizerName"],
      description: json["description"],
      location: json["location"],
      locationAddress: json["locationAddress"],
      startDate: DateTime.parse(json["startDate"]).toIso8601String(),
      endDate: DateTime.parse(json["endDate"]).toIso8601String(),
      startTime: json["startTime"],
      endTime: json["endTime"],
      payoutStatus: json["payoutStatus"],
      eventType: json["eventType"],
      eventStatus: json["eventstatus"],
      fee: json["fee"],
      totalRevenue: json["totalRevenue"],
      maxCapacity: json["maxCapacity"],
      noOfAttendees: json["noOfAttendees"],
      privacyOption: json["privacyOption"],
      version: json["_v"],
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}
