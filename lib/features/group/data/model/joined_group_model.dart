import 'dart:convert';

import 'package:wayagram/shared/features/profile/model/groups.dart';

JoinedGroupModel joinedGroupModelFromJson(String str) => JoinedGroupModel.fromJson(json.decode(str));
String joinedGroupModelToJson(JoinedGroupModel data) => json.encode(data.toJson());

class JoinedGroupModel {
  JoinedGroupModel({
    this.message,
    this.status,
    this.statusCode,
    this.data,
  });

  JoinedGroupModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
  JoinedGroupModel copyWith({
    String? message,
    bool? status,
    num? statusCode,
    Data? data,
  }) =>
      JoinedGroupModel(
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
  });

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(GroupModel.fromJson(v));
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
  List<GroupModel>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
  Data copyWith({
    List<GroupModel>? docs,
    num? totalDocs,
    num? limit,
    num? page,
    num? totalPages,
    bool? hasNextPage,
    num? nextPage,
    bool? hasPrevPage,
    dynamic prevPage,
    num? pagingCounter,
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

JoinedGroupDocs docsFromJson(String str) => JoinedGroupDocs.fromJson(json.decode(str));
String docsToJson(JoinedGroupDocs data) => json.encode(data.toJson());

class JoinedGroupDocs {
  JoinedGroupDocs({
    this.id,
    this.name,
    this.memberCount,
    this.description,
    this.isOpen,
    this.approveJoinRequest,
    this.isPrivate,
    this.coverImage,
    this.profileImage,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  JoinedGroupDocs.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    memberCount = json['memberCount'];
    description = json['description'];
    isOpen = json['isOpen'];
    approveJoinRequest = json['approveJoinRequest'];
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
  num? memberCount;
  String? description;
  bool? isOpen;
  bool? approveJoinRequest;
  bool? isPrivate;
  String? coverImage;
  String? profileImage;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  JoinedGroupDocs copyWith({
    String? id,
    String? name,
    num? memberCount,
    String? description,
    bool? isOpen,
    bool? approveJoinRequest,
    bool? isPrivate,
    String? coverImage,
    String? profileImage,
    dynamic deletedAt,
    String? createdAt,
    String? updatedAt,
  }) =>
      JoinedGroupDocs(
        id: id ?? this.id,
        name: name ?? this.name,
        memberCount: memberCount ?? this.memberCount,
        description: description ?? this.description,
        isOpen: isOpen ?? this.isOpen,
        approveJoinRequest: approveJoinRequest ?? this.approveJoinRequest,
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
    map['memberCount'] = memberCount;
    map['description'] = description;
    map['isOpen'] = isOpen;
    map['approveJoinRequest'] = approveJoinRequest;
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
