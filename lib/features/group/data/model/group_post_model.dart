import 'dart:convert';

import 'package:wayagram/shared/features/profile/model/post.dart';

GroupPostModel groupPostModelFromJson(String str) => GroupPostModel.fromJson(json.decode(str));
String groupPostModelToJson(GroupPostModel data) => json.encode(data.toJson());

class GroupPostModel {
  GroupPostModel({
    this.message,
    this.status,
    this.statusCode,
    this.data,
  });

  GroupPostModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
  GroupPostModel copyWith({
    String? message,
    bool? status,
    num? statusCode,
    Data? data,
  }) =>
      GroupPostModel(
        message: message ?? this.message,
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
    this.metadata,
  });

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(PostModel.fromJson(v));
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
  List<PostModel>? docs;
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
  Data copyWith({
    List<PostModel>? docs,
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
  }) =>
      Data(
        docs: docs ?? this.docs,
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
  });

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
  Metadata copyWith({
    num? offset,
    bool? searchApplied,
    List<String>? searchFields,
    AppliedFilters? appliedFilters,
  }) =>
      Metadata(
        offset: offset ?? this.offset,
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
    this.status,
    this.groupId,
    this.deletedAt,
  });

  AppliedFilters.fromJson(dynamic json) {
    status = json['status'];
    groupId = json['groupId'];
    deletedAt = json['deletedAt'];
  }
  String? status;
  String? groupId;
  dynamic deletedAt;
  AppliedFilters copyWith({
    String? status,
    String? groupId,
    dynamic deletedAt,
  }) =>
      AppliedFilters(
        status: status ?? this.status,
        groupId: groupId ?? this.groupId,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['groupId'] = groupId;
    map['deletedAt'] = deletedAt;
    return map;
  }
}

GroupPostDocs docsFromJson(String str) => GroupPostDocs.fromJson(json.decode(str));
String docsToJson(GroupPostDocs data) => json.encode(data.toJson());

class GroupPostDocs {
  GroupPostDocs({
    this.id,
    this.userId,
    this.categories,
    this.groupId,
    this.pageId,
    this.contentType,
    this.content,
    this.media,
    this.hashtags,
    this.sourceType,
    this.linkedServiceId,
    this.privacy,
    this.url,
    this.status,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.popularityScore,
    this.isPromoted,
    this.isReposted,
    this.promotionExpiry,
    this.deletedAt,
    this.originalPostId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.group,
  });

  GroupPostDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    groupId = json['groupId'];
    pageId = json['pageId'];
    contentType = json['contentType'];
    content = json['content'];
    media = json['media'] != null ? json['media'].cast<String>() : [];
    hashtags = json['hashtags'] != null ? json['hashtags'].cast<String>() : [];
    sourceType = json['sourceType'];
    linkedServiceId = json['linkedServiceId'];
    privacy = json['privacy'];
    url = json['url'];
    status = json['status'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    popularityScore = json['popularityScore'];
    isPromoted = json['isPromoted'];
    isReposted = json['isReposted'];
    promotionExpiry = json['promotionExpiry'];
    deletedAt = json['deletedAt'];
    originalPostId = json['originalPostId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }
  String? id;
  String? userId;
  List<String>? categories;
  String? groupId;
  dynamic pageId;
  String? contentType;
  String? content;
  List<String>? media;
  List<String>? hashtags;
  String? sourceType;
  dynamic linkedServiceId;
  String? privacy;
  String? url;
  String? status;
  num? likeCount;
  num? commentCount;
  num? shareCount;
  num? popularityScore;
  bool? isPromoted;
  bool? isReposted;
  dynamic promotionExpiry;
  dynamic deletedAt;
  dynamic originalPostId;
  String? createdAt;
  String? updatedAt;
  User? user;
  Group? group;
  GroupPostDocs copyWith({
    String? id,
    String? userId,
    List<String>? categories,
    String? groupId,
    dynamic pageId,
    String? contentType,
    String? content,
    List<String>? media,
    List<String>? hashtags,
    String? sourceType,
    dynamic linkedServiceId,
    String? privacy,
    String? url,
    String? status,
    num? likeCount,
    num? commentCount,
    num? shareCount,
    num? popularityScore,
    bool? isPromoted,
    bool? isReposted,
    dynamic promotionExpiry,
    dynamic deletedAt,
    dynamic originalPostId,
    String? createdAt,
    String? updatedAt,
    User? user,
    Group? group,
  }) =>
      GroupPostDocs(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        categories: categories ?? this.categories,
        groupId: groupId ?? this.groupId,
        pageId: pageId ?? this.pageId,
        contentType: contentType ?? this.contentType,
        content: content ?? this.content,
        media: media ?? this.media,
        hashtags: hashtags ?? this.hashtags,
        sourceType: sourceType ?? this.sourceType,
        linkedServiceId: linkedServiceId ?? this.linkedServiceId,
        privacy: privacy ?? this.privacy,
        url: url ?? this.url,
        status: status ?? this.status,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        shareCount: shareCount ?? this.shareCount,
        popularityScore: popularityScore ?? this.popularityScore,
        isPromoted: isPromoted ?? this.isPromoted,
        isReposted: isReposted ?? this.isReposted,
        promotionExpiry: promotionExpiry ?? this.promotionExpiry,
        deletedAt: deletedAt ?? this.deletedAt,
        originalPostId: originalPostId ?? this.originalPostId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        group: group ?? this.group,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['categories'] = categories;
    map['groupId'] = groupId;
    map['pageId'] = pageId;
    map['contentType'] = contentType;
    map['content'] = content;
    map['media'] = media;
    map['hashtags'] = hashtags;
    map['sourceType'] = sourceType;
    map['linkedServiceId'] = linkedServiceId;
    map['privacy'] = privacy;
    map['url'] = url;
    map['status'] = status;
    map['likeCount'] = likeCount;
    map['commentCount'] = commentCount;
    map['shareCount'] = shareCount;
    map['popularityScore'] = popularityScore;
    map['isPromoted'] = isPromoted;
    map['isReposted'] = isReposted;
    map['promotionExpiry'] = promotionExpiry;
    map['deletedAt'] = deletedAt;
    map['originalPostId'] = originalPostId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
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
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Group.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    ownerId = json['ownerId'];
    memberCount = json['memberCount'];
    description = json['description'];
    isOpen = json['isOpen'];
    approveJoinRequest = json['approveJoinRequest'];
    categories = json['categories'];
    url = json['url'];
    isPrivate = json['isPrivate'];
    coverImage = json['coverImage'];
    profileImage = json['profileImage'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? name;
  dynamic ownerId;
  num? memberCount;
  String? description;
  bool? isOpen;
  bool? approveJoinRequest;
  dynamic categories;
  dynamic url;
  bool? isPrivate;
  String? coverImage;
  String? profileImage;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Group copyWith({
    String? id,
    String? name,
    dynamic ownerId,
    num? memberCount,
    String? description,
    bool? isOpen,
    bool? approveJoinRequest,
    dynamic categories,
    dynamic url,
    bool? isPrivate,
    String? coverImage,
    String? profileImage,
    dynamic deletedAt,
    String? createdAt,
    String? updatedAt,
  }) =>
      Group(
        id: id ?? this.id,
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
    map['categories'] = categories;
    map['url'] = url;
    map['isPrivate'] = isPrivate;
    map['coverImage'] = coverImage;
    map['profileImage'] = profileImage;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
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
    this.updatedAt,
  });

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
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
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
