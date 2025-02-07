import 'dart:convert';
MediaUploadModel mediaUploadModelFromJson(String str) => MediaUploadModel.fromJson(json.decode(str));
String mediaUploadModelToJson(MediaUploadModel data) => json.encode(data.toJson());
class MediaUploadModel {
  MediaUploadModel({
      this.message, 
      this.status,
      this.statusCode, 
      this.data,});

  MediaUploadModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? MediaUploadData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  MediaUploadData? data;
MediaUploadModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  MediaUploadData? data,
}) => MediaUploadModel(  message: message ?? this.message,
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

MediaUploadData dataFromJson(String str) => MediaUploadData.fromJson(json.decode(str));
String dataToJson(MediaUploadData data) => json.encode(data.toJson());
class MediaUploadData {
  MediaUploadData({
      this.url, this.publicUrl});

  MediaUploadData.fromJson(dynamic json) {
    url = json['url'];
    publicUrl = json['publicUrl'];
  }
  String? url;
  String? publicUrl;
  MediaUploadData copyWith({  String? url, String? publicUrl
}) => MediaUploadData(  url: url ?? this.url, publicUrl: publicUrl ?? this.publicUrl
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['publicUrl'] = publicUrl;
    return map;
  }

}