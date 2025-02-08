import 'dart:convert';
ShareModel shareModelFromJson(String str) => ShareModel.fromJson(json.decode(str));
String shareModelToJson(ShareModel data) => json.encode(data.toJson());
class ShareModel {
  ShareModel({
      this.message, 
      this.status,
      this.statusCode, 
      this.data,});

  ShareModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? ShareModelData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  ShareModelData? data;
ShareModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  ShareModelData? data,
}) => ShareModel(  message: message ?? this.message,
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

ShareModelData dataFromJson(String str) => ShareModelData.fromJson(json.decode(str));
String dataToJson(ShareModelData data) => json.encode(data.toJson());
class ShareModelData {
  ShareModelData({
      this.deepLink, 
      this.universalLink, 
      this.playStoreUrl, 
      this.appStoreUrl,});

  ShareModelData.fromJson(dynamic json) {
    deepLink = json['deepLink'];
    universalLink = json['universalLink'];
    playStoreUrl = json['playStoreUrl'];
    appStoreUrl = json['appStoreUrl'];
  }
  String? deepLink;
  String? universalLink;
  String? playStoreUrl;
  String? appStoreUrl;
  ShareModelData copyWith({  String? deepLink,
  String? universalLink,
  String? playStoreUrl,
  String? appStoreUrl,
}) => ShareModelData(  deepLink: deepLink ?? this.deepLink,
  universalLink: universalLink ?? this.universalLink,
  playStoreUrl: playStoreUrl ?? this.playStoreUrl,
  appStoreUrl: appStoreUrl ?? this.appStoreUrl,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deepLink'] = deepLink;
    map['universalLink'] = universalLink;
    map['playStoreUrl'] = playStoreUrl;
    map['appStoreUrl'] = appStoreUrl;
    return map;
  }

}