import 'dart:convert';

import 'package:wayagram/shared/features/profile/model/pages.dart';
GetAllPages getAllPagesFromJson(String str) => GetAllPages.fromJson(json.decode(str));
String getAllPagesToJson(GetAllPages data) => json.encode(data.toJson());
class GetAllPages {
  GetAllPages({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  GetAllPages.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
GetAllPages copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => GetAllPages(  message: message ?? this.message,
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
        docs?.add(PageModel.fromJson(v));
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
  List<PageModel>? docs;
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
Data copyWith({  List<PageModel>? docs,
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
      this.appliedFilters, 
      this.appliedDateRanges,});

  Metadata.fromJson(dynamic json) {
    offset = json['offset'];
    searchApplied = json['searchApplied'];
    searchFields = json['searchFields'];
    appliedFilters = json['appliedFilters'] != null ? AppliedFilters.fromJson(json['appliedFilters']) : null;
    if (json['appliedDateRanges'] != null) {
      appliedDateRanges = [];
      json['appliedDateRanges'].forEach((v) {
        appliedDateRanges?.add(AppliedDateRanges.fromJson(v));
      });
    }
  }
  num? offset;
  bool? searchApplied;
  List<dynamic>? searchFields;
  AppliedFilters? appliedFilters;
  List<AppliedDateRanges>? appliedDateRanges;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<dynamic>? searchFields,
  AppliedFilters? appliedFilters,
  List<AppliedDateRanges>? appliedDateRanges,
}) => Metadata(  offset: offset ?? this.offset,
  searchApplied: searchApplied ?? this.searchApplied,
  searchFields: searchFields ?? this.searchFields,
  appliedFilters: appliedFilters ?? this.appliedFilters,
  appliedDateRanges: appliedDateRanges ?? this.appliedDateRanges,
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
    if (appliedDateRanges != null) {
      map['appliedDateRanges'] = appliedDateRanges?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

AppliedDateRanges appliedDateRangesFromJson(String str) => AppliedDateRanges.fromJson(json.decode(str));
String appliedDateRangesToJson(AppliedDateRanges data) => json.encode(data.toJson());
class AppliedDateRanges {
  AppliedDateRanges({
      this.field,});

  AppliedDateRanges.fromJson(dynamic json) {
    field = json['field'];
  }
  String? field;
AppliedDateRanges copyWith({  String? field,
}) => AppliedDateRanges(  field: field ?? this.field,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['field'] = field;
    return map;
  }

}

AppliedFilters appliedFiltersFromJson(String str) => AppliedFilters.fromJson(json.decode(str));
String appliedFiltersToJson(AppliedFilters data) => json.encode(data.toJson());
class AppliedFilters {
  AppliedFilters({
      this.id,});

  AppliedFilters.fromJson(dynamic json) {
    id = json['id'];
  }
  dynamic id;
AppliedFilters copyWith({  dynamic id,
}) => AppliedFilters(  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

}

Docs docsFromJson(String str) => Docs.fromJson(json.decode(str));
String docsToJson(Docs data) => json.encode(data.toJson());
class Docs {
  Docs({
      this.id, 
      this.followerCount, 
      this.ownerId, 
      this.name, 
      this.description, 
      this.isPublic, 
      this.isOpen, 
      this.adminsCanCreate, 
      this.coverImage, 
      this.categories, 
      this.url, 
      this.profileImage, 
      this.everyoneCanComment, 
      this.hashtags, 
      this.deletedAt, 
      this.suspendedAt, 
      this.createdAt, 
      this.updatedAt,});

  Docs.fromJson(dynamic json) {
    id = json['id'];
    followerCount = json['followerCount'];
    ownerId = json['ownerId'];
    name = json['name'];
    description = json['description'];
    isPublic = json['isPublic'];
    isOpen = json['isOpen'];
    adminsCanCreate = json['adminsCanCreate'];
    coverImage = json['coverImage'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    url = json['url'];
    profileImage = json['profileImage'];
    everyoneCanComment = json['everyoneCanComment'];
    hashtags = json['hashtags'];
    deletedAt = json['deletedAt'];
    suspendedAt = json['suspendedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  num? followerCount;
  String? ownerId;
  String? name;
  String? description;
  bool? isPublic;
  bool? isOpen;
  bool? adminsCanCreate;
  String? coverImage;
  List<String>? categories;
  String? url;
  String? profileImage;
  bool? everyoneCanComment;
  List<dynamic>? hashtags;
  dynamic deletedAt;
  dynamic suspendedAt;
  String? createdAt;
  String? updatedAt;
Docs copyWith({  String? id,
  num? followerCount,
  String? ownerId,
  String? name,
  String? description,
  bool? isPublic,
  bool? isOpen,
  bool? adminsCanCreate,
  String? coverImage,
  List<String>? categories,
  String? url,
  String? profileImage,
  bool? everyoneCanComment,
  List<dynamic>? hashtags,
  dynamic deletedAt,
  dynamic suspendedAt,
  String? createdAt,
  String? updatedAt,
}) => Docs(  id: id ?? this.id,
  followerCount: followerCount ?? this.followerCount,
  ownerId: ownerId ?? this.ownerId,
  name: name ?? this.name,
  description: description ?? this.description,
  isPublic: isPublic ?? this.isPublic,
  isOpen: isOpen ?? this.isOpen,
  adminsCanCreate: adminsCanCreate ?? this.adminsCanCreate,
  coverImage: coverImage ?? this.coverImage,
  categories: categories ?? this.categories,
  url: url ?? this.url,
  profileImage: profileImage ?? this.profileImage,
  everyoneCanComment: everyoneCanComment ?? this.everyoneCanComment,
  hashtags: hashtags ?? this.hashtags,
  deletedAt: deletedAt ?? this.deletedAt,
  suspendedAt: suspendedAt ?? this.suspendedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['followerCount'] = followerCount;
    map['ownerId'] = ownerId;
    map['name'] = name;
    map['description'] = description;
    map['isPublic'] = isPublic;
    map['isOpen'] = isOpen;
    map['adminsCanCreate'] = adminsCanCreate;
    map['coverImage'] = coverImage;
    map['categories'] = categories;
    map['url'] = url;
    map['profileImage'] = profileImage;
    map['everyoneCanComment'] = everyoneCanComment;
    if (hashtags != null) {
      map['hashtags'] = hashtags?.map((v) => v.toJson()).toList();
    }
    map['deletedAt'] = deletedAt;
    map['suspendedAt'] = suspendedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}