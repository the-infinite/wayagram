import 'dart:convert';
SearchLogModel searchLogModelFromJson(String str) => SearchLogModel.fromJson(json.decode(str));
String searchLogModelToJson(SearchLogModel data) => json.encode(data.toJson());
class SearchLogModel {
  SearchLogModel({
      this.message, 
      this.status, 
      this.statusCode,
      this.data, 
      this.responseCode,});

  SearchLogModel.fromJson(dynamic json) {
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
SearchLogModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => SearchLogModel(  message: message ?? this.message,
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
        docs?.add(SearchLogDocs.fromJson(v));
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
  List<SearchLogDocs>? docs;
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
Data copyWith({  List<SearchLogDocs>? docs,
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

/*Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
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
    // if (json['searchFields'] != null) {
    //   searchFields = [];
    //   json['searchFields'].forEach((v) {
    //     searchFields?.add(Dynamic.fromJson(v));
    //   });
    // }
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

}*/

AppliedFilters appliedFiltersFromJson(String str) => AppliedFilters.fromJson(json.decode(str));
String appliedFiltersToJson(AppliedFilters data) => json.encode(data.toJson());
class AppliedFilters {
  AppliedFilters({
      this.logType, 
      this.userId,});

  AppliedFilters.fromJson(dynamic json) {
    logType = json['logType'];
    userId = json['userId'];
  }
  String? logType;
  String? userId;
AppliedFilters copyWith({  String? logType,
  String? userId,
}) => AppliedFilters(  logType: logType ?? this.logType,
  userId: userId ?? this.userId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['logType'] = logType;
    map['userId'] = userId;
    return map;
  }

}

SearchLogDocs docsFromJson(String str) => SearchLogDocs.fromJson(json.decode(str));
String docsToJson(SearchLogDocs data) => json.encode(data.toJson());
class SearchLogDocs {
  SearchLogDocs({
      this.id, 
      this.userId, 
      this.logType, 
      this.description, 
      this.actionType, 
      this.metadata, 
      this.createdAt, 
      this.updatedAt,});

  SearchLogDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    logType = json['logType'];
    description = json['description'];
    actionType = json['actionType'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? logType;
  String? description;
  String? actionType;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;
  SearchLogDocs copyWith({  String? id,
  String? userId,
  String? logType,
  String? description,
  String? actionType,
  Metadata? metadata,
  String? createdAt,
  String? updatedAt,
}) => SearchLogDocs(  id: id ?? this.id,
  userId: userId ?? this.userId,
  logType: logType ?? this.logType,
  description: description ?? this.description,
  actionType: actionType ?? this.actionType,
  metadata: metadata ?? this.metadata,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['logType'] = logType;
    map['description'] = description;
    map['actionType'] = actionType;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
      this.query, 
      this.filters, 
      this.resultsFound,});

  Metadata.fromJson(dynamic json) {
    query = json['query'];
    filters = json['filters'] != null ? json['filters'].cast<String>() : [];
    resultsFound = json['resultsFound'];
  }
  String? query;
  List<String>? filters;
  num? resultsFound;
Metadata copyWith({  String? query,
  List<String>? filters,
  num? resultsFound,
}) => Metadata(  query: query ?? this.query,
  filters: filters ?? this.filters,
  resultsFound: resultsFound ?? this.resultsFound,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['query'] = query;
    map['filters'] = filters;
    map['resultsFound'] = resultsFound;
    return map;
  }

}
