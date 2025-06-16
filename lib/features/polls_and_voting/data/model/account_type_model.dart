import 'dart:convert';
AccountTypeModel accountTypeModelFromJson(String str) => AccountTypeModel.fromJson(json.decode(str));
String accountTypeModelToJson(AccountTypeModel data) => json.encode(data.toJson());
class AccountTypeModel {
  AccountTypeModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  AccountTypeModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  List<Data>? data;
  num? responseCode;
AccountTypeModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  List<Data>? data,
  num? responseCode,
}) => AccountTypeModel(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
  responseCode: responseCode ?? this.responseCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['responseCode'] = responseCode;
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.name, 
      this.action, 
      this.roleId, 
      this.description, 
      this.v, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    action = json['action'];
    roleId = json['roleId'];
    description = json['description'];
    v = json['_v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? name;
  String? action;
  String? roleId;
  String? description;
  String? v;
  String? createdAt;
  String? updatedAt;
Data copyWith({  String? id,
  String? name,
  String? action,
  String? roleId,
  String? description,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? this.id,
  name: name ?? this.name,
  action: action ?? this.action,
  roleId: roleId ?? this.roleId,
  description: description ?? this.description,
  v: v ?? this.v,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['action'] = action;
    map['roleId'] = roleId;
    map['description'] = description;
    map['_v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}