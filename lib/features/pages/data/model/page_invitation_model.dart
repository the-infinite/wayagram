import 'dart:convert';
PageInvitationModel pageInvitationModelFromJson(String str) => PageInvitationModel.fromJson(json.decode(str));
String pageInvitationModelToJson(PageInvitationModel data) => json.encode(data.toJson());
class PageInvitationModel {
  PageInvitationModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  PageInvitationModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
PageInvitationModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => PageInvitationModel(  message: message ?? this.message,
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
        docs?.add(PageInvitationModelDocs.fromJson(v));
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
  List<PageInvitationModelDocs>? docs;
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
Data copyWith({  List<PageInvitationModelDocs>? docs,
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
      this.rstatus,});

  AppliedFilters.fromJson(dynamic json) {
    rstatus = json['rstatus'];
  }
  String? rstatus;
AppliedFilters copyWith({  String? rstatus,
}) => AppliedFilters(  rstatus: rstatus ?? this.rstatus,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rstatus'] = rstatus;
    return map;
  }

}

PageInvitationModelDocs docsFromJson(String str) => PageInvitationModelDocs.fromJson(json.decode(str));
String docsToJson(PageInvitationModelDocs data) => json.encode(data.toJson());
class PageInvitationModelDocs {
  PageInvitationModelDocs({
      this.id, 
      this.pageId, 
      this.userId, 
      this.rstatus, 
      this.reviewedAt, 
      this.invitedBy, 
      this.role, 
      this.createdAt, 
      this.updatedAt, 
      this.page,});

  PageInvitationModelDocs.fromJson(dynamic json) {
    id = json['id'];
    pageId = json['pageId'];
    userId = json['userId'];
    rstatus = json['rstatus'];
    reviewedAt = json['reviewedAt'];
    invitedBy = json['invitedBy'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
  }
  String? id;
  String? pageId;
  String? userId;
  String? rstatus;
  String? reviewedAt;
  String? invitedBy;
  dynamic role;
  String? createdAt;
  String? updatedAt;
  Page? page;
  PageInvitationModelDocs copyWith({  String? id,
  String? pageId,
  String? userId,
  String? rstatus,
  String? reviewedAt,
  String? invitedBy,
  dynamic role,
  String? createdAt,
  String? updatedAt,
  Page? page,
}) => PageInvitationModelDocs(  id: id ?? this.id,
  pageId: pageId ?? this.pageId,
  userId: userId ?? this.userId,
  rstatus: rstatus ?? this.rstatus,
  reviewedAt: reviewedAt ?? this.reviewedAt,
  invitedBy: invitedBy ?? this.invitedBy,
  role: role ?? this.role,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  page: page ?? this.page,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pageId'] = pageId;
    map['userId'] = userId;
    map['rstatus'] = rstatus;
    map['reviewedAt'] = reviewedAt;
    map['invitedBy'] = invitedBy;
    map['role'] = role;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (page != null) {
      map['page'] = page?.toJson();
    }
    return map;
  }

}

Page pageFromJson(String str) => Page.fromJson(json.decode(str));
String pageToJson(Page data) => json.encode(data.toJson());
class Page {
  Page({
      this.id, 
      this.followerCount, 
      this.ownerId, 
      this.name, 
      this.description, 
      this.isPublic, 
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

  Page.fromJson(dynamic json) {
    id = json['id'];
    followerCount = json['followerCount'];
    ownerId = json['ownerId'];
    name = json['name'];
    description = json['description'];
    isPublic = json['isPublic'];
    coverImage = json['coverImage'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    url = json['url'];
    profileImage = json['profileImage'];
    everyoneCanComment = json['everyoneCanComment'];
    hashtags = json['hashtags'] != null ? json['hashtags'].cast<String>() : [];
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
  String? coverImage;
  List<String>? categories;
  String? url;
  String? profileImage;
  bool? everyoneCanComment;
  List<String>? hashtags;
  dynamic deletedAt;
  dynamic suspendedAt;
  String? createdAt;
  String? updatedAt;
Page copyWith({  String? id,
  num? followerCount,
  String? ownerId,
  String? name,
  String? description,
  bool? isPublic,
  String? coverImage,
  List<String>? categories,
  String? url,
  String? profileImage,
  bool? everyoneCanComment,
  List<String>? hashtags,
  dynamic deletedAt,
  dynamic suspendedAt,
  String? createdAt,
  String? updatedAt,
}) => Page(  id: id ?? this.id,
  followerCount: followerCount ?? this.followerCount,
  ownerId: ownerId ?? this.ownerId,
  name: name ?? this.name,
  description: description ?? this.description,
  isPublic: isPublic ?? this.isPublic,
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
    map['coverImage'] = coverImage;
    map['categories'] = categories;
    map['url'] = url;
    map['profileImage'] = profileImage;
    map['everyoneCanComment'] = everyoneCanComment;
    map['hashtags'] = hashtags;
    map['deletedAt'] = deletedAt;
    map['suspendedAt'] = suspendedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}