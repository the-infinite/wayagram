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
      this.code, 
      this.name, 
      this.id, 
      this.status, 
      this.requestStatus,});

  Data.fromJson(dynamic json) {
    code = json['Code'];
    name = json['Name'];
    id = json['ID'];
    status = json['Status'];
    requestStatus = json['RequestStatus'];
  }
  String? code;
  String? name;
  String? id;
  bool? status;
  bool? requestStatus;
Data copyWith({  String? code,
  String? name,
  String? id,
  bool? status,
  bool? requestStatus,
}) => Data(  code: code ?? this.code,
  name: name ?? this.name,
  id: id ?? this.id,
  status: status ?? this.status,
  requestStatus: requestStatus ?? this.requestStatus,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = code;
    map['Name'] = name;
    map['ID'] = id;
    map['Status'] = status;
    map['RequestStatus'] = requestStatus;
    return map;
  }

}