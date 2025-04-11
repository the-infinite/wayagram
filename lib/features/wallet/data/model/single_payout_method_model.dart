import 'dart:convert';
SinglePayoutMethodModel singlePayoutMethodModelFromJson(String str) => SinglePayoutMethodModel.fromJson(json.decode(str));
String singlePayoutMethodModelToJson(SinglePayoutMethodModel data) => json.encode(data.toJson());
class SinglePayoutMethodModel {
  SinglePayoutMethodModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  SinglePayoutMethodModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? SinglePayoutMethodData.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  SinglePayoutMethodData? data;
  num? responseCode;
SinglePayoutMethodModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  SinglePayoutMethodData? data,
  num? responseCode,
}) => SinglePayoutMethodModel(  message: message ?? this.message,
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
      map['data'] = data?.toJson();
    }
    map['responseCode'] = responseCode;
    return map;
  }

}

SinglePayoutMethodData dataFromJson(String str) => SinglePayoutMethodData.fromJson(json.decode(str));
String dataToJson(SinglePayoutMethodData data) => json.encode(data.toJson());
class SinglePayoutMethodData {
  SinglePayoutMethodData({
      this.id, 
      this.userId, 
      this.accountName, 
      this.accountNumber, 
      this.bankName, 
      this.bankCode, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  SinglePayoutMethodData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    bankCode = json['bankCode'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? bankCode;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  SinglePayoutMethodData copyWith({  String? id,
  String? userId,
  String? accountName,
  String? accountNumber,
  String? bankName,
  String? bankCode,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
}) => SinglePayoutMethodData(  id: id ?? this.id,
  userId: userId ?? this.userId,
  accountName: accountName ?? this.accountName,
  accountNumber: accountNumber ?? this.accountNumber,
  bankName: bankName ?? this.bankName,
  bankCode: bankCode ?? this.bankCode,
  deletedAt: deletedAt ?? this.deletedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['accountName'] = accountName;
    map['accountNumber'] = accountNumber;
    map['bankName'] = bankName;
    map['bankCode'] = bankCode;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}