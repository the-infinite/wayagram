import 'dart:convert';
FollowersModel followersModelFromJson(String str) => FollowersModel.fromJson(json.decode(str));
String followersModelToJson(FollowersModel data) => json.encode(data.toJson());
class FollowersModel {
  FollowersModel({
      this.message,
      this.status, 
      this.statusCode, 
      this.data,});

  FollowersModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
FollowersModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => FollowersModel(  message: message ?? this.message,
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
        //docs?.add(Dynamic.fromJson(v));
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
  List<dynamic>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  dynamic nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
Data copyWith({  List<dynamic>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  dynamic nextPage,
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