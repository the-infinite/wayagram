import 'dart:convert';
VerifyAccountNameModel verifyAccountModelFromJson(String str) => VerifyAccountNameModel.fromJson(json.decode(str));
String verifyAccountModelToJson(VerifyAccountNameModel data) => json.encode(data.toJson());
class VerifyAccountNameModel {
  VerifyAccountNameModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  VerifyAccountNameModel.fromJson(dynamic json) {
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
VerifyAccountNameModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => VerifyAccountNameModel(  message: message ?? this.message,
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
      this.name, 
      this.bvn, 
      this.kyc, 
      this.isSuccessful, 
      this.sessionID, 
      this.responseMessage, 
      this.defaultGateWay, 
      this.institutionCode,});

  Data.fromJson(dynamic json) {
    name = json['Name'];
    bvn = json['BVN'];
    kyc = json['KYC'];
    isSuccessful = json['IsSuccessful'];
    sessionID = json['SessionID'];
    responseMessage = json['ResponseMessage'];
    defaultGateWay = json['DefaultGateWay'];
    institutionCode = json['InstitutionCode'];
  }
  String? name;
  dynamic bvn;
  dynamic kyc;
  bool? isSuccessful;
  String? sessionID;
  String? responseMessage;
  String? defaultGateWay;
  dynamic institutionCode;
Data copyWith({  String? name,
  dynamic bvn,
  dynamic kyc,
  bool? isSuccessful,
  String? sessionID,
  String? responseMessage,
  String? defaultGateWay,
  dynamic institutionCode,
}) => Data(  name: name ?? this.name,
  bvn: bvn ?? this.bvn,
  kyc: kyc ?? this.kyc,
  isSuccessful: isSuccessful ?? this.isSuccessful,
  sessionID: sessionID ?? this.sessionID,
  responseMessage: responseMessage ?? this.responseMessage,
  defaultGateWay: defaultGateWay ?? this.defaultGateWay,
  institutionCode: institutionCode ?? this.institutionCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = name;
    map['BVN'] = bvn;
    map['KYC'] = kyc;
    map['IsSuccessful'] = isSuccessful;
    map['SessionID'] = sessionID;
    map['ResponseMessage'] = responseMessage;
    map['DefaultGateWay'] = defaultGateWay;
    map['InstitutionCode'] = institutionCode;
    return map;
  }

}