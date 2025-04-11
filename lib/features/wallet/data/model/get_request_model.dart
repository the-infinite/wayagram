import 'dart:convert';
GetRequestModel getRequestModelFromJson(String str) => GetRequestModel.fromJson(json.decode(str));
String getRequestModelToJson(GetRequestModel data) => json.encode(data.toJson());
class GetRequestModel {
  GetRequestModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  GetRequestModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
  num? responseCode;
GetRequestModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => GetRequestModel(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
  responseCode: responseCode ?? this.responseCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['responseCode'] = responseCode;
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
      this.pagingCounter, 
      this.metadata,});

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(RequestDocs.fromJson(v));
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
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }
  List<RequestDocs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  dynamic nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
  Metadata? metadata;
Data copyWith({  List<RequestDocs>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  dynamic nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
  num? pagingCounter,
  Metadata? metadata,
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
  metadata: metadata ?? this.metadata,
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
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    return map;
  }

}

Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
      this.offset, 
      this.searchApplied, 
      this.searchFields, 
      this.appliedFilters,});

  Metadata.fromJson(dynamic json) {
    offset = json['offset'];
    searchApplied = json['searchApplied'];
    searchFields = json['searchFields'];
    appliedFilters = json['appliedFilters'] != null ? AppliedFilters.fromJson(json['appliedFilters']) : null;
  }
  num? offset;
  bool? searchApplied;
  List<dynamic>? searchFields;
  AppliedFilters? appliedFilters;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<dynamic>? searchFields,
  AppliedFilters? appliedFilters,
}) => Metadata(  offset: offset ?? this.offset,
  searchApplied: searchApplied ?? this.searchApplied,
  searchFields: searchFields ?? this.searchFields,
  appliedFilters: appliedFilters ?? this.appliedFilters,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = offset;
    map['searchApplied'] = searchApplied;
    if (searchFields != null) {
      map['searchFields'] = searchFields?.map((v) => v.toJson()).toList();
    }
    if (appliedFilters != null) {
      map['appliedFilters'] = appliedFilters?.toJson();
    }
    return map;
  }

}

AppliedFilters appliedFiltersFromJson(String str) => AppliedFilters.fromJson(json.decode(str));
String appliedFiltersToJson(AppliedFilters data) => json.encode(data.toJson());
class AppliedFilters {
  AppliedFilters({
      this.userId, 
      this.deletedAt,});

  AppliedFilters.fromJson(dynamic json) {
    userId = json['userId'];
    deletedAt = json['deletedAt'];
  }
  String? userId;
  dynamic deletedAt;
AppliedFilters copyWith({  String? userId,
  dynamic deletedAt,
}) => AppliedFilters(  userId: userId ?? this.userId,
  deletedAt: deletedAt ?? this.deletedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['deletedAt'] = deletedAt;
    return map;
  }

}

RequestDocs docsFromJson(String str) => RequestDocs.fromJson(json.decode(str));
String docsToJson(RequestDocs data) => json.encode(data.toJson());
class RequestDocs {
  RequestDocs({
      this.id, 
      this.userId, 
      this.amount, 
      this.status, 
      this.referenceId, 
      this.deletedAt, 
      this.completedAt, 
      this.requestedAt, 
      this.payoutMethodId, 
      this.metadata, 
      this.statusHistory, 
      this.createdAt, 
      this.updatedAt,});

  RequestDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    amount = json['amount'];
    status = json['status'];
    referenceId = json['referenceId'];
    deletedAt = json['deletedAt'];
    completedAt = json['completedAt'];
    requestedAt = json['requestedAt'];
    payoutMethodId = json['payoutMethodId'];
    metadata = json['metadata'];
    statusHistory = json['statusHistory'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? amount;
  String? status;
  String? referenceId;
  dynamic deletedAt;
  dynamic completedAt;
  String? requestedAt;
  String? payoutMethodId;
  dynamic metadata;
  dynamic statusHistory;
  String? createdAt;
  String? updatedAt;
  RequestDocs copyWith({  String? id,
  String? userId,
  String? amount,
  String? status,
  String? referenceId,
  dynamic deletedAt,
  dynamic completedAt,
  String? requestedAt,
  String? payoutMethodId,
  dynamic metadata,
  dynamic statusHistory,
  String? createdAt,
  String? updatedAt,
}) => RequestDocs(  id: id ?? this.id,
  userId: userId ?? this.userId,
  amount: amount ?? this.amount,
  status: status ?? this.status,
  referenceId: referenceId ?? this.referenceId,
  deletedAt: deletedAt ?? this.deletedAt,
  completedAt: completedAt ?? this.completedAt,
  requestedAt: requestedAt ?? this.requestedAt,
  payoutMethodId: payoutMethodId ?? this.payoutMethodId,
  metadata: metadata ?? this.metadata,
  statusHistory: statusHistory ?? this.statusHistory,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['amount'] = amount;
    map['status'] = status;
    map['referenceId'] = referenceId;
    map['deletedAt'] = deletedAt;
    map['completedAt'] = completedAt;
    map['requestedAt'] = requestedAt;
    map['payoutMethodId'] = payoutMethodId;
    map['metadata'] = metadata;
    map['statusHistory'] = statusHistory;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}