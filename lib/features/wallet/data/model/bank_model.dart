import 'dart:convert';
BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));
String bankModelToJson(BankModel data) => json.encode(data.toJson());
class BankModel {
  BankModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  BankModel.fromJson(dynamic json) {
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
BankModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  List<Data>? data,
  num? responseCode,
}) => BankModel(  message: message ?? this.message,
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
      this.institutionCode, 
      this.institutionName,});

  Data.fromJson(dynamic json) {
    institutionCode = json['institutionCode'];
    institutionName = json['institutionName'];
  }
  String? institutionCode;
  String? institutionName;
Data copyWith({  String? institutionCode,
  String? institutionName,
}) => Data(  institutionCode: institutionCode ?? this.institutionCode,
  institutionName: institutionName ?? this.institutionName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['institutionCode'] = institutionCode;
    map['institutionName'] = institutionName;
    return map;
  }

}