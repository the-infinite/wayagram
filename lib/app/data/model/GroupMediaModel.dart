import 'dart:convert';
/// id : "06db88c2-06a2-4622-9388-6ddb66d71af9"
/// email : "cephasarowolo@gmail.com"
/// item_id : null
/// ProfileId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// item_type : "PROFILE_IMAGE"
/// media_type : "IMAGE"
/// fileUrl : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1667993435506.jpeg"
/// _v : "RGB"
/// updatedAt : "2022-11-09T11:30:35.637Z"

GroupMediaModel groupMediaModelFromJson(String str) => GroupMediaModel.fromJson(json.decode(str));
String groupMediaModelToJson(GroupMediaModel data) => json.encode(data.toJson());

class GroupMediaModel {
  GroupMediaModel({
      String? id, 
      String? email, 
      dynamic itemId, 
      String? profileId, 
      String? itemType, 
      String? mediaType, 
      String? fileUrl, 
      String? v,
      String? updatedAt,}){
    _id = id;
    _email = email;
    _itemId = itemId;
    _profileId = profileId;
    _itemType = itemType;
    _mediaType = mediaType;
    _fileUrl = fileUrl;
    _v = v;
    _updatedAt = updatedAt;
}

  GroupMediaModel.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _itemId = json['item_id'];
    _profileId = json['ProfileId'];
    _itemType = json['item_type'];
    _mediaType = json['media_type'];
    _fileUrl = json['fileUrl'];
    _v = json['_v'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _email;
  dynamic _itemId;
  String? _profileId;
  String? _itemType;
  String? _mediaType;
  String? _fileUrl;
  String? _v;
  String? _updatedAt;
GroupMediaModel copyWith({  String? id,
  String? email,
  dynamic itemId,
  String? profileId,
  String? itemType,
  String? mediaType,
  String? fileUrl,
  String? v,
  String? updatedAt,
}) => GroupMediaModel(  id: id ?? _id,
  email: email ?? _email,
  itemId: itemId ?? _itemId,
  profileId: profileId ?? _profileId,
  itemType: itemType ?? _itemType,
  mediaType: mediaType ?? _mediaType,
  fileUrl: fileUrl ?? _fileUrl,
  v: v ?? _v,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get email => _email;
  dynamic get itemId => _itemId;
  String? get profileId => _profileId;
  String? get itemType => _itemType;
  String? get mediaType => _mediaType;
  String? get fileUrl => _fileUrl;
  String? get v => _v;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['item_id'] = _itemId;
    map['ProfileId'] = _profileId;
    map['item_type'] = _itemType;
    map['media_type'] = _mediaType;
    map['fileUrl'] = _fileUrl;
    map['_v'] = _v;
    map['updatedAt'] = _updatedAt;
    return map;
  }

  static List<GroupMediaModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => GroupMediaModel.fromJson(item)).toList();
  }
}