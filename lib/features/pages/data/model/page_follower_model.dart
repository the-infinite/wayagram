import 'dart:convert';
PageFollowerModel pageFollowerModelFromJson(String str) => PageFollowerModel.fromJson(json.decode(str));
String pageFollowerModelToJson(PageFollowerModel data) => json.encode(data.toJson());
class PageFollowerModel {
  PageFollowerModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  PageFollowerModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
PageFollowerModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => PageFollowerModel(  message: message ?? this.message,
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
      this.pagingCounter, 
      this.metadata,});

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(PageFollowerDocs.fromJson(v));
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
  List<PageFollowerDocs>? docs;
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
Data copyWith({  List<PageFollowerDocs>? docs,
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
    searchFields = json['searchFields'] != null ? json['searchFields'].cast<String>() : [];
    appliedFilters = json['appliedFilters'] != null ? AppliedFilters.fromJson(json['appliedFilters']) : null;
  }
  num? offset;
  bool? searchApplied;
  List<String>? searchFields;
  AppliedFilters? appliedFilters;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<String>? searchFields,
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
    map['searchFields'] = searchFields;
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
      this.pageId, 
      this.status,});

  AppliedFilters.fromJson(dynamic json) {
    pageId = json['pageId'];
    status = json['status'];
  }
  String? pageId;
  String? status;
AppliedFilters copyWith({  String? pageId,
  String? status,
}) => AppliedFilters(  pageId: pageId ?? this.pageId,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pageId'] = pageId;
    map['status'] = status;
    return map;
  }

}

PageFollowerDocs docsFromJson(String str) => PageFollowerDocs.fromJson(json.decode(str));
String docsToJson(PageFollowerDocs data) => json.encode(data.toJson());
class PageFollowerDocs {
  PageFollowerDocs({
      this.id, 
      this.pageId, 
      this.followerId, 
      this.status, 
      this.followedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.user,});

  PageFollowerDocs.fromJson(dynamic json) {
    id = json['id'];
    pageId = json['pageId'];
    followerId = json['followerId'];
    status = json['status'];
    followedAt = json['followedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? pageId;
  String? followerId;
  String? status;
  String? followedAt;
  String? createdAt;
  String? updatedAt;
  User? user;
  PageFollowerDocs copyWith({  String? id,
  String? pageId,
  String? followerId,
  String? status,
  String? followedAt,
  String? createdAt,
  String? updatedAt,
  User? user,
}) => PageFollowerDocs(  id: id ?? this.id,
  pageId: pageId ?? this.pageId,
  followerId: followerId ?? this.followerId,
  status: status ?? this.status,
  followedAt: followedAt ?? this.followedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  user: user ?? this.user,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pageId'] = pageId;
    map['followerId'] = followerId;
    map['status'] = status;
    map['followedAt'] = followedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.profilePicture, 
      this.createdAt, 
      this.updatedAt,});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;
  String? createdAt;
  String? updatedAt;
User copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? email,
  String? profilePicture,
  String? createdAt,
  String? updatedAt,
}) => User(  id: id ?? this.id,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  email: email ?? this.email,
  profilePicture: profilePicture ?? this.profilePicture,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['profilePicture'] = profilePicture;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}