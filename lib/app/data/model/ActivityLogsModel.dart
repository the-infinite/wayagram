import 'dart:convert';
/// id : "e6e35113-1de4-43ee-92ff-0109bdaabc86"
/// ProfileId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// activity : "You view your products"
/// jsonRequest : ""
/// jsonResponse : ""
/// isDeleted : false
/// _v : "RGBA"
/// createdAt : "2022-11-26T13:18:11.515Z"
/// updatedAt : "2022-11-26T13:18:11.515Z"

ActivityLogsModel activityLogsModelFromJson(String str) => ActivityLogsModel.fromJson(json.decode(str));
String activityLogsModelToJson(ActivityLogsModel data) => json.encode(data.toJson());
class ActivityLogsModel {
  ActivityLogsModel({
      String? id,
      String? profileId, 
      String? activity, 
      String? jsonRequest, 
      String? jsonResponse, 
      bool? isDeleted, 
      String? v, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _profileId = profileId;
    _activity = activity;
    _jsonRequest = jsonRequest;
    _jsonResponse = jsonResponse;
    _isDeleted = isDeleted;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  ActivityLogsModel.fromJson(dynamic json) {
    _id = json['id'];
    _profileId = json['ProfileId'];
    _activity = json['activity'];
    _jsonRequest = json['jsonRequest'];
    _jsonResponse = json['jsonResponse'];
    _isDeleted = json['isDeleted'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _profileId;
  String? _activity;
  String? _jsonRequest;
  String? _jsonResponse;
  bool? _isDeleted;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
ActivityLogsModel copyWith({  String? id,
  String? profileId,
  String? activity,
  String? jsonRequest,
  String? jsonResponse,
  bool? isDeleted,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => ActivityLogsModel(  id: id ?? _id,
  profileId: profileId ?? _profileId,
  activity: activity ?? _activity,
  jsonRequest: jsonRequest ?? _jsonRequest,
  jsonResponse: jsonResponse ?? _jsonResponse,
  isDeleted: isDeleted ?? _isDeleted,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get profileId => _profileId;
  String? get activity => _activity;
  String? get jsonRequest => _jsonRequest;
  String? get jsonResponse => _jsonResponse;
  bool? get isDeleted => _isDeleted;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProfileId'] = _profileId;
    map['activity'] = _activity;
    map['jsonRequest'] = _jsonRequest;
    map['jsonResponse'] = _jsonResponse;
    map['isDeleted'] = _isDeleted;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

  static List<ActivityLogsModel> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => ActivityLogsModel.fromJson(item)).toList();
  }
}