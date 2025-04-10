import 'dart:convert';
PayoutMethodModel payoutMethodModelFromJson(String str) => PayoutMethodModel.fromJson(json.decode(str));
String payoutMethodModelToJson(PayoutMethodModel data) => json.encode(data.toJson());
class PayoutMethodModel {
  PayoutMethodModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  PayoutMethodModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PayoutMethodData.fromJson(v));
      });
    }
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  List<PayoutMethodData>? data;
  num? responseCode;
PayoutMethodModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  List<PayoutMethodData>? data,
  num? responseCode,
}) => PayoutMethodModel(  message: message ?? this.message,
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

PayoutMethodData dataFromJson(String str) => PayoutMethodData.fromJson(json.decode(str));
String dataToJson(PayoutMethodData data) => json.encode(data.toJson());
class PayoutMethodData {
  PayoutMethodData({
      this.id, 
      this.userId, 
      this.accountName, 
      this.accountNumber, 
      this.bankName, 
      this.bankCode, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  PayoutMethodData.fromJson(dynamic json) {
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
  PayoutMethodData copyWith({  String? id,
  String? userId,
  String? accountName,
  String? accountNumber,
  String? bankName,
  String? bankCode,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
}) => PayoutMethodData(  id: id ?? this.id,
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