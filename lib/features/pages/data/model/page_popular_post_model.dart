import 'dart:convert';
PagePopularPostModel pagePopularPostModelFromJson(String str) => PagePopularPostModel.fromJson(json.decode(str));
String pagePopularPostModelToJson(PagePopularPostModel data) => json.encode(data.toJson());
class PagePopularPostModel {
  PagePopularPostModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  PagePopularPostModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
PagePopularPostModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => PagePopularPostModel(  message: message ?? this.message,
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
        docs?.add(PagePopularPostDocs.fromJson(v));
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
  List<PagePopularPostDocs>? docs;
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
Data copyWith({  List<PagePopularPostDocs>? docs,
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

}

AppliedFilters appliedFiltersFromJson(String str) => AppliedFilters.fromJson(json.decode(str));
String appliedFiltersToJson(AppliedFilters data) => json.encode(data.toJson());
class AppliedFilters {
  AppliedFilters({
      this.pageId, 
      this.privacy,});

  AppliedFilters.fromJson(dynamic json) {
    pageId = json['pageId'];
    privacy = json['privacy'];
  }
  dynamic pageId;
  String? privacy;
AppliedFilters copyWith({  dynamic pageId,
  String? privacy,
}) => AppliedFilters(  pageId: pageId ?? this.pageId,
  privacy: privacy ?? this.privacy,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pageId'] = pageId;
    map['privacy'] = privacy;
    return map;
  }

}

PagePopularPostDocs docsFromJson(String str) => PagePopularPostDocs.fromJson(json.decode(str));
String docsToJson(PagePopularPostDocs data) => json.encode(data.toJson());
class PagePopularPostDocs {
  PagePopularPostDocs({
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
      this.page,});

  PagePopularPostDocs.fromJson(dynamic json) {
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
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
  }
  String? id;
  String? userId;
  List<String>? categories;
  dynamic groupId;
  String? pageId;
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
  Page? page;
  PagePopularPostDocs copyWith({  String? id,
  String? userId,
  List<String>? categories,
  dynamic groupId,
  String? pageId,
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
  Page? page,
}) => PagePopularPostDocs(  id: id ?? this.id,
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
  page: page ?? this.page,
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
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, });

  Page.fromJson(dynamic json) {
    id = json['id'];
    followerCount = json['followerCount'];
    ownerId = json['ownerId'];
    name = json['name'];
    description = json['description'];
    isPublic = json['isPublic'];
    coverImage = json['coverImage'];
    categories = json['categories'];
    url = json['url'];
    profileImage = json['profileImage'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  num? followerCount;
  String? ownerId;
  String? name;
  String? description;
  bool? isPublic;
  String? coverImage;
  dynamic categories;
  dynamic url;
  String? profileImage;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
Page copyWith({  String? id,
  num? followerCount,
  String? ownerId,
  String? name,
  String? description,
  bool? isPublic,
  String? coverImage,
  dynamic categories,
  dynamic url,
  String? profileImage,
  dynamic deletedAt,
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
  deletedAt: deletedAt ?? this.deletedAt,
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
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}