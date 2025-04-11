import 'dart:convert';
SingleRequestModel singleRequestModelFromJson(String str) => SingleRequestModel.fromJson(json.decode(str));
String singleRequestModelToJson(SingleRequestModel data) => json.encode(data.toJson());
class SingleRequestModel {
  SingleRequestModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  SingleRequestModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
  num? responseCode;
SingleRequestModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => SingleRequestModel(  message: message ?? this.message,
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.userId, 
      this.amount, 
      this.status, 
      this.referenceId, 
      this.deletedAt, 
      this.completedAt, 
      this.requestedAt, 
      this.payoutMethodId, 
      this.metadata, 
      this.statusHistory, 
      this.createdAt, 
      this.updatedAt, 
      this.payoutMethod,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    amount = json['amount'];
    status = json['status'];
    referenceId = json['referenceId'];
    deletedAt = json['deletedAt'];
    completedAt = json['completedAt'];
    requestedAt = json['requestedAt'];
    payoutMethodId = json['payoutMethodId'];
    metadata = json['metadata'];
    statusHistory = json['statusHistory'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    payoutMethod = json['payoutMethod'] != null ? PayoutMethod.fromJson(json['payoutMethod']) : null;
  }
  String? id;
  String? userId;
  String? amount;
  String? status;
  String? referenceId;
  dynamic deletedAt;
  dynamic completedAt;
  String? requestedAt;
  String? payoutMethodId;
  dynamic metadata;
  dynamic statusHistory;
  String? createdAt;
  String? updatedAt;
  PayoutMethod? payoutMethod;
Data copyWith({  String? id,
  String? userId,
  String? amount,
  String? status,
  String? referenceId,
  dynamic deletedAt,
  dynamic completedAt,
  String? requestedAt,
  String? payoutMethodId,
  dynamic metadata,
  dynamic statusHistory,
  String? createdAt,
  String? updatedAt,
  PayoutMethod? payoutMethod,
}) => Data(  id: id ?? this.id,
  userId: userId ?? this.userId,
  amount: amount ?? this.amount,
  status: status ?? this.status,
  referenceId: referenceId ?? this.referenceId,
  deletedAt: deletedAt ?? this.deletedAt,
  completedAt: completedAt ?? this.completedAt,
  requestedAt: requestedAt ?? this.requestedAt,
  payoutMethodId: payoutMethodId ?? this.payoutMethodId,
  metadata: metadata ?? this.metadata,
  statusHistory: statusHistory ?? this.statusHistory,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  payoutMethod: payoutMethod ?? this.payoutMethod,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['amount'] = amount;
    map['status'] = status;
    map['referenceId'] = referenceId;
    map['deletedAt'] = deletedAt;
    map['completedAt'] = completedAt;
    map['requestedAt'] = requestedAt;
    map['payoutMethodId'] = payoutMethodId;
    map['metadata'] = metadata;
    map['statusHistory'] = statusHistory;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (payoutMethod != null) {
      map['payoutMethod'] = payoutMethod?.toJson();
    }
    return map;
  }

}

PayoutMethod payoutMethodFromJson(String str) => PayoutMethod.fromJson(json.decode(str));
String payoutMethodToJson(PayoutMethod data) => json.encode(data.toJson());
class PayoutMethod {
  PayoutMethod({
      this.id, 
      this.userId, 
      this.accountName, 
      this.accountNumber, 
      this.bankName, 
      this.bankCode, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  PayoutMethod.fromJson(dynamic json) {
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
PayoutMethod copyWith({  String? id,
  String? userId,
  String? accountName,
  String? accountNumber,
  String? bankName,
  String? bankCode,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
}) => PayoutMethod(  id: id ?? this.id,
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