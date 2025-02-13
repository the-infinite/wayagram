import 'dart:convert';
RecommendedGroupModel recommendedGroupModelFromJson(String str) => RecommendedGroupModel.fromJson(json.decode(str));
String recommendedGroupModelToJson(RecommendedGroupModel data) => json.encode(data.toJson());
class RecommendedGroupModel {
  RecommendedGroupModel({
      this.message, 
      this.status, 
      this.statusCode,
      this.data,});

  RecommendedGroupModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
RecommendedGroupModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => RecommendedGroupModel(  message: message ?? this.message,
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
        docs?.add(RecommendedGroupDocs.fromJson(v));
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
  List<RecommendedGroupDocs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
Data copyWith({  List<RecommendedGroupDocs>? docs,
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

RecommendedGroupDocs docsFromJson(String str) => RecommendedGroupDocs.fromJson(json.decode(str));
String docsToJson(RecommendedGroupDocs data) => json.encode(data.toJson());
class RecommendedGroupDocs {
  RecommendedGroupDocs({
      this.id, 
      this.name, 
      this.ownerId, 
      this.memberCount, 
      this.description, 
      this.isOpen, 
      this.categories, 
      this.url, 
      this.isPrivate, 
      this.coverImage, 
      this.profileImage, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      });

  RecommendedGroupDocs.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    ownerId = json['ownerId'];
    memberCount = json['memberCount'];
    description = json['description'];
    isOpen = json['isOpen'];
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
  dynamic categories;
  dynamic url;
  bool? isPrivate;
  String? coverImage;
  String? profileImage;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  RecommendedGroupDocs copyWith({  String? id,
  String? name,
  dynamic ownerId,
  num? memberCount,
  String? description,
  bool? isOpen,
  dynamic categories,
  dynamic url,
  bool? isPrivate,
  String? coverImage,
  String? profileImage,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
}) => RecommendedGroupDocs(  id: id ?? this.id,
  name: name ?? this.name,
  ownerId: ownerId ?? this.ownerId,
  memberCount: memberCount ?? this.memberCount,
  description: description ?? this.description,
  isOpen: isOpen ?? this.isOpen,
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