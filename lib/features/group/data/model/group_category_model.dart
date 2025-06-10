import 'dart:convert';
GroupCategoryModel groupCategoryModelFromJson(String str) => GroupCategoryModel.fromJson(json.decode(str));
String groupCategoryModelToJson(GroupCategoryModel data) => json.encode(data.toJson());
class GroupCategoryModel {
  GroupCategoryModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  GroupCategoryModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  String? message;
  bool? status;
  num? statusCode;
  List<Data>? data;
GroupCategoryModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  List<Data>? data,
}) => GroupCategoryModel(  message: message ?? this.message,
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
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.name, 
      this.parentId, 
      this.category, 
      this.score, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parentId'];
    category = json['category'];
    score = json['score'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? name;
  dynamic parentId;
  String? category;
  num? score;
  String? createdAt;
  String? updatedAt;
Data copyWith({  String? id,
  String? name,
  dynamic parentId,
  String? category,
  num? score,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? this.id,
  name: name ?? this.name,
  parentId: parentId ?? this.parentId,
  category: category ?? this.category,
  score: score ?? this.score,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['parentId'] = parentId;
    map['category'] = category;
    map['score'] = score;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}