import 'dart:convert';
GroupInvitationModel groupInvitationModelFromJson(String str) => GroupInvitationModel.fromJson(json.decode(str));
String groupInvitationModelToJson(GroupInvitationModel data) => json.encode(data.toJson());
class GroupInvitationModel {
  GroupInvitationModel({
      this.message, 
      this.status, 
      this.statusCode,
      this.data,});

  GroupInvitationModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
GroupInvitationModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => GroupInvitationModel(  message: message ?? this.message,
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
        docs?.add(GroupInvitationModelDocs.fromJson(v));
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
  List<GroupInvitationModelDocs>? docs;
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
Data copyWith({  List<GroupInvitationModelDocs>? docs,
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
      this.userId, 
      this.rstatus,});

  AppliedFilters.fromJson(dynamic json) {
    userId = json['userId'];
    rstatus = json['rstatus'];
  }
  String? userId;
  String? rstatus;
AppliedFilters copyWith({  String? userId,
  String? rstatus,
}) => AppliedFilters(  userId: userId ?? this.userId,
  rstatus: rstatus ?? this.rstatus,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['rstatus'] = rstatus;
    return map;
  }

}

GroupInvitationModelDocs docsFromJson(String str) => GroupInvitationModelDocs.fromJson(json.decode(str));
String docsToJson(GroupInvitationModelDocs data) => json.encode(data.toJson());
class GroupInvitationModelDocs {
  GroupInvitationModelDocs({
      this.id, 
      this.groupId, 
      this.userId, 
      this.rstatus, 
      this.message, 
      this.reviewedAt, 
      this.reviewedBy, 
      this.createdAt, 
      this.updatedAt,
      this.group,});

  GroupInvitationModelDocs.fromJson(dynamic json) {
    id = json['id'];
    groupId = json['groupId'];
    userId = json['userId'];
    rstatus = json['rstatus'];
    message = json['message'];
    reviewedAt = json['reviewedAt'];
    reviewedBy = json['reviewedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }
  String? id;
  String? groupId;
  String? userId;
  String? rstatus;
  String? message;
  String? reviewedAt;
  String? reviewedBy;
  String? createdAt;
  String? updatedAt;
  Group? group;
  GroupInvitationModelDocs copyWith({  String? id,
  String? groupId,
  String? userId,
  String? rstatus,
  String? message,
  String? reviewedAt,
  String? reviewedBy,
  String? createdAt,
  String? updatedAt,
  Group? group,
}) => GroupInvitationModelDocs(  id: id ?? this.id,
  groupId: groupId ?? this.groupId,
  userId: userId ?? this.userId,
  rstatus: rstatus ?? this.rstatus,
  message: message ?? this.message,
  reviewedAt: reviewedAt ?? this.reviewedAt,
  reviewedBy: reviewedBy ?? this.reviewedBy,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  group: group ?? this.group,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['groupId'] = groupId;
    map['userId'] = userId;
    map['rstatus'] = rstatus;
    map['message'] = message;
    map['reviewedAt'] = reviewedAt;
    map['reviewedBy'] = reviewedBy;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (group != null) {
      map['group'] = group?.toJson();
    }
    return map;
  }

}

Group groupFromJson(String str) => Group.fromJson(json.decode(str));
String groupToJson(Group data) => json.encode(data.toJson());
class Group {
  Group({
      this.id, 
      this.name, 
      this.ownerId, 
      this.memberCount, 
      this.description, 
      this.isOpen, 
      this.approveJoinRequest,
      this.categories,
      this.url, 
      this.isPrivate, 
      this.coverImage, 
      this.profileImage, 
      this.hashtags, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  Group.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    ownerId = json['ownerId'];
    memberCount = json['memberCount'];
    description = json['description'];
    isOpen = json['isOpen'];
    approveJoinRequest = json['approveJoinRequest'];
    categories = json['categories'];
    // if (json['categories'] != null) {
    //   categories = [];
    //   json['categories'].forEach((v) {
    //     categories?.add(Dynamic.fromJson(v));
    //   });
    // }
    url = json['url'];
    isPrivate = json['isPrivate'];
    coverImage = json['coverImage'];
    profileImage = json['profileImage'];
    hashtags = json['hashtags'];
    // if (json['hashtags'] != null) {
    //   hashtags = [];
    //   json['hashtags'].forEach((v) {
    //     hashtags?.add(Dynamic.fromJson(v));
    //   });
    // }
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? name;
  String? ownerId;
  num? memberCount;
  String? description;
  bool? isOpen;
  bool? approveJoinRequest;
  List<dynamic>? categories;
  String? url;
  bool? isPrivate;
  String? coverImage;
  String? profileImage;
  List<dynamic>? hashtags;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
Group copyWith({  String? id,
  String? name,
  String? ownerId,
  num? memberCount,
  String? description,
  bool? isOpen,
  bool? approveJoinRequest,
  List<dynamic>? categories,
  String? url,
  bool? isPrivate,
  String? coverImage,
  String? profileImage,
  List<dynamic>? hashtags,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
}) => Group(  id: id ?? this.id,
  name: name ?? this.name,
  ownerId: ownerId ?? this.ownerId,
  memberCount: memberCount ?? this.memberCount,
  description: description ?? this.description,
  isOpen: isOpen ?? this.isOpen,
  approveJoinRequest: approveJoinRequest ?? this.approveJoinRequest,
  categories: categories ?? this.categories,
  url: url ?? this.url,
  isPrivate: isPrivate ?? this.isPrivate,
  coverImage: coverImage ?? this.coverImage,
  profileImage: profileImage ?? this.profileImage,
  hashtags: hashtags ?? this.hashtags,
  deletedAt: deletedAt ?? this.deletedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['ownerId'] = ownerId;
    map['memberCount'] = memberCount;
    map['description'] = description;
    map['isOpen'] = isOpen;
    map['approveJoinRequest'] = approveJoinRequest;
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    map['url'] = url;
    map['isPrivate'] = isPrivate;
    map['coverImage'] = coverImage;
    map['profileImage'] = profileImage;
    if (hashtags != null) {
      map['hashtags'] = hashtags?.map((v) => v.toJson()).toList();
    }
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}