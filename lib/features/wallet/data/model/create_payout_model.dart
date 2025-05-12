import 'dart:convert';
CreatePayoutModel createPayoutModelFromJson(String str) => CreatePayoutModel.fromJson(json.decode(str));
String createPayoutModelToJson(CreatePayoutModel data) => json.encode(data.toJson());
class CreatePayoutModel {
  CreatePayoutModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  CreatePayoutModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'];
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  dynamic data;
  num? responseCode;
CreatePayoutModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  dynamic data,
  num? responseCode,
}) => CreatePayoutModel(  message: message ?? this.message,
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
    map['data'] = data;
    map['responseCode'] = responseCode;
    return map;
  }

}