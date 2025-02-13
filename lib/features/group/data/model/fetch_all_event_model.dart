import 'dart:convert';
FetchAllEventModel fetchAllEventModelFromJson(String str) => FetchAllEventModel.fromJson(json.decode(str));
String fetchAllEventModelToJson(FetchAllEventModel data) => json.encode(data.toJson());
class FetchAllEventModel {
  FetchAllEventModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  FetchAllEventModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
FetchAllEventModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => FetchAllEventModel(  message: message ?? this.message,
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.docs, 
      this.totalDocs, 
      this.limit, 
      this.page, 
      this.totalPages, 
      this.hasNextPage, 
      this.nextPage, 
      this.hasPrevPage, 
      this.prevPage, 
      this.pagingCounter,});

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(FetchAllEventDocs.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
    pagingCounter = json['pagingCounter'];
  }
  List<FetchAllEventDocs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
Data copyWith({  List<FetchAllEventDocs>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  num? nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
  num? pagingCounter,
}) => Data(  docs: docs ?? this.docs,
  totalDocs: totalDocs ?? this.totalDocs,
  limit: limit ?? this.limit,
  page: page ?? this.page,
  totalPages: totalPages ?? this.totalPages,
  hasNextPage: hasNextPage ?? this.hasNextPage,
  nextPage: nextPage ?? this.nextPage,
  hasPrevPage: hasPrevPage ?? this.hasPrevPage,
  prevPage: prevPage ?? this.prevPage,
  pagingCounter: pagingCounter ?? this.pagingCounter,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (docs != null) {
      map['docs'] = docs?.map((v) => v.toJson()).toList();
    }
    map['totalDocs'] = totalDocs;
    map['limit'] = limit;
    map['page'] = page;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    map['pagingCounter'] = pagingCounter;
    return map;
  }

}

FetchAllEventDocs docsFromJson(String str) => FetchAllEventDocs.fromJson(json.decode(str));
String docsToJson(FetchAllEventDocs data) => json.encode(data.toJson());
class FetchAllEventDocs {
  FetchAllEventDocs({
      this.id, 
      this.userId, 
      this.image, 
      this.title, 
      this.organizerName, 
      this.description, 
      this.location, 
      this.locationAddress, 
      this.startDate, 
      this.endDate, 
      this.startTime, 
      this.endTime, 
      this.payoutStatus, 
      this.eventType, 
      this.eventstatus, 
      this.fee, 
      this.totalRevenue, 
      this.maxCapacity, 
      this.noOfAttendees, 
      this.privacyOption, 
      this.v, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt,});

  FetchAllEventDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    image = json['image'];
    title = json['title'];
    organizerName = json['organizerName'];
    description = json['description'];
    location = json['location'];
    locationAddress = json['locationAddress'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    payoutStatus = json['payoutStatus'];
    eventType = json['eventType'];
    eventstatus = json['eventstatus'];
    fee = json['fee'];
    totalRevenue = json['totalRevenue'];
    maxCapacity = json['maxCapacity'];
    noOfAttendees = json['noOfAttendees'];
    privacyOption = json['privacyOption'];
    v = json['_v'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? image;
  String? title;
  String? organizerName;
  String? description;
  String? location;
  String? locationAddress;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? payoutStatus;
  String? eventType;
  String? eventstatus;
  num? fee;
  num? totalRevenue;
  num? maxCapacity;
  num? noOfAttendees;
  String? privacyOption;
  String? v;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  FetchAllEventDocs copyWith({  String? id,
  String? userId,
  String? image,
  String? title,
  String? organizerName,
  String? description,
  String? location,
  String? locationAddress,
  String? startDate,
  String? endDate,
  String? startTime,
  String? endTime,
  String? payoutStatus,
  String? eventType,
  String? eventstatus,
  num? fee,
  num? totalRevenue,
  num? maxCapacity,
  num? noOfAttendees,
  String? privacyOption,
  String? v,
  bool? isDeleted,
  String? createdAt,
  String? updatedAt,
}) => FetchAllEventDocs(  id: id ?? this.id,
  userId: userId ?? this.userId,
  image: image ?? this.image,
  title: title ?? this.title,
  organizerName: organizerName ?? this.organizerName,
  description: description ?? this.description,
  location: location ?? this.location,
  locationAddress: locationAddress ?? this.locationAddress,
  startDate: startDate ?? this.startDate,
  endDate: endDate ?? this.endDate,
  startTime: startTime ?? this.startTime,
  endTime: endTime ?? this.endTime,
  payoutStatus: payoutStatus ?? this.payoutStatus,
  eventType: eventType ?? this.eventType,
  eventstatus: eventstatus ?? this.eventstatus,
  fee: fee ?? this.fee,
  totalRevenue: totalRevenue ?? this.totalRevenue,
  maxCapacity: maxCapacity ?? this.maxCapacity,
  noOfAttendees: noOfAttendees ?? this.noOfAttendees,
  privacyOption: privacyOption ?? this.privacyOption,
  v: v ?? this.v,
  isDeleted: isDeleted ?? this.isDeleted,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['image'] = image;
    map['title'] = title;
    map['organizerName'] = organizerName;
    map['description'] = description;
    map['location'] = location;
    map['locationAddress'] = locationAddress;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['payoutStatus'] = payoutStatus;
    map['eventType'] = eventType;
    map['eventstatus'] = eventstatus;
    map['fee'] = fee;
    map['totalRevenue'] = totalRevenue;
    map['maxCapacity'] = maxCapacity;
    map['noOfAttendees'] = noOfAttendees;
    map['privacyOption'] = privacyOption;
    map['_v'] = v;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}