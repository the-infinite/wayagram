import 'dart:convert';
/// id : "de51dfc7-ce98-42be-93b3-7c634eaec5a1"
/// userId : "b42be7f6-e0c2-45d9-8458-d38c9957afaa"
/// groupId : "2494d720-b667-4813-bbe2-206d92054ad9"
/// isActive : true
/// isAdmin : true
/// _v : "RGBA"
/// onMute : false
/// createdAt : "2022-08-10T01:05:01.431Z"
/// updatedAt : "2022-08-10T01:05:01.431Z"
/// Profile : {"id":"b42be7f6-e0c2-45d9-8458-d38c9957afaa","UserId":"407","avatar":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1658969001394.jpeg","coverImage":null,"bio":"null","notificationCount":3,"posts":28,"groupCount":0,"pageCount":0,"followings":10,"followers":4,"username":"Waya407","displayName":"Adeyanju Waya","notPublic":true,"deleted":false,"simulatedUser":false,"isMuted":false,"isBan":false,"isDisabled":false,"isDeactivate":false,"theme":"light","fontSize":"12px","phone":null,"email":null,"style":"italic","stream_key":"LW6FmW6jv","_niu":"RGBA","createdAt":"2022-05-04T02:30:20.863Z","updatedAt":"2022-11-14T06:53:17.661Z","connection":{}}

GroupMembersModel groupMembersModelFromJson(String str) => GroupMembersModel.fromJson(json.decode(str));
String groupMembersModelToJson(GroupMembersModel data) => json.encode(data.toJson());
class GroupMembersModel {
  GroupMembersModel({
      String? id, 
      String? userId, 
      String? groupId, 
      bool? isActive, 
      bool? isAdmin, 
      String? v, 
      bool? onMute, 
      String? createdAt, 
      String? updatedAt, 
      Profile? profile,}){
    _id = id;
    _userId = userId;
    _groupId = groupId;
    _isActive = isActive;
    _isAdmin = isAdmin;
    _v = v;
    _onMute = onMute;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _profile = profile;
}

  GroupMembersModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _groupId = json['groupId'];
    _isActive = json['isActive'];
    _isAdmin = json['isAdmin'];
    _v = json['_v'];
    _onMute = json['onMute'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _profile = json['Profile'] != null ? Profile.fromJson(json['Profile']) : null;
  }
  String? _id;
  String? _userId;
  String? _groupId;
  bool? _isActive;
  bool? _isAdmin;
  String? _v;
  bool? _onMute;
  String? _createdAt;
  String? _updatedAt;
  Profile? _profile;
GroupMembersModel copyWith({  String? id,
  String? userId,
  String? groupId,
  bool? isActive,
  bool? isAdmin,
  String? v,
  bool? onMute,
  String? createdAt,
  String? updatedAt,
  Profile? profile,
}) => GroupMembersModel(  id: id ?? _id,
  userId: userId ?? _userId,
  groupId: groupId ?? _groupId,
  isActive: isActive ?? _isActive,
  isAdmin: isAdmin ?? _isAdmin,
  v: v ?? _v,
  onMute: onMute ?? _onMute,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  profile: profile ?? _profile,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get groupId => _groupId;
  bool? get isActive => _isActive;
  bool? get isAdmin => _isAdmin;
  String? get v => _v;
  bool? get onMute => _onMute;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Profile? get profile => _profile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['groupId'] = _groupId;
    map['isActive'] = _isActive;
    map['isAdmin'] = _isAdmin;
    map['_v'] = _v;
    map['onMute'] = _onMute;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_profile != null) {
      map['Profile'] = _profile?.toJson();
    }
    return map;
  }

  static List<GroupMembersModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => GroupMembersModel.fromJson(item)).toList();
  }

}

/// id : "b42be7f6-e0c2-45d9-8458-d38c9957afaa"
/// UserId : "407"
/// avatar : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1658969001394.jpeg"
/// coverImage : null
/// bio : "null"
/// notificationCount : 3
/// posts : 28
/// groupCount : 0
/// pageCount : 0
/// followings : 10
/// followers : 4
/// username : "Waya407"
/// displayName : "Adeyanju Waya"
/// notPublic : true
/// deleted : false
/// simulatedUser : false
/// isMuted : false
/// isBan : false
/// isDisabled : false
/// isDeactivate : false
/// theme : "light"
/// fontSize : "12px"
/// phone : null
/// email : null
/// style : "italic"
/// stream_key : "LW6FmW6jv"
/// _niu : "RGBA"
/// createdAt : "2022-05-04T02:30:20.863Z"
/// updatedAt : "2022-11-14T06:53:17.661Z"
/// connection : {}

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));
String profileToJson(Profile data) => json.encode(data.toJson());
class Profile {
  Profile({
      String? id, 
      String? userId, 
      String? avatar, 
      dynamic coverImage, 
      String? bio, 
      num? notificationCount, 
      num? posts, 
      num? groupCount, 
      num? pageCount, 
      num? followings, 
      num? followers, 
      String? username, 
      String? displayName, 
      bool? notPublic, 
      bool? deleted, 
      bool? simulatedUser, 
      bool? isMuted, 
      bool? isBan, 
      bool? isDisabled, 
      bool? isDeactivate, 
      String? theme, 
      String? fontSize, 
      dynamic phone, 
      dynamic email, 
      String? style, 
      String? streamKey, 
      String? niu, 
      String? createdAt, 
      String? updatedAt, 
      dynamic connection,}){
    _id = id;
    _userId = userId;
    _avatar = avatar;
    _coverImage = coverImage;
    _bio = bio;
    _notificationCount = notificationCount;
    _posts = posts;
    _groupCount = groupCount;
    _pageCount = pageCount;
    _followings = followings;
    _followers = followers;
    _username = username;
    _displayName = displayName;
    _notPublic = notPublic;
    _deleted = deleted;
    _simulatedUser = simulatedUser;
    _isMuted = isMuted;
    _isBan = isBan;
    _isDisabled = isDisabled;
    _isDeactivate = isDeactivate;
    _theme = theme;
    _fontSize = fontSize;
    _phone = phone;
    _email = email;
    _style = style;
    _streamKey = streamKey;
    _niu = niu;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _connection = connection;
}

  Profile.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['UserId'];
    _avatar = json['avatar'];
    _coverImage = json['coverImage'];
    _bio = json['bio'];
    _notificationCount = json['notificationCount'];
    _posts = json['posts'];
    _groupCount = json['groupCount'];
    _pageCount = json['pageCount'];
    _followings = json['followings'];
    _followers = json['followers'];
    _username = json['username'];
    _displayName = json['displayName'];
    _notPublic = json['notPublic'];
    _deleted = json['deleted'];
    _simulatedUser = json['simulatedUser'];
    _isMuted = json['isMuted'];
    _isBan = json['isBan'];
    _isDisabled = json['isDisabled'];
    _isDeactivate = json['isDeactivate'];
    _theme = json['theme'];
    _fontSize = json['fontSize'];
    _phone = json['phone'];
    _email = json['email'];
    _style = json['style'];
    _streamKey = json['stream_key'];
    _niu = json['_niu'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _connection = json['connection'];
  }
  String? _id;
  String? _userId;
  String? _avatar;
  dynamic _coverImage;
  String? _bio;
  num? _notificationCount;
  num? _posts;
  num? _groupCount;
  num? _pageCount;
  num? _followings;
  num? _followers;
  String? _username;
  String? _displayName;
  bool? _notPublic;
  bool? _deleted;
  bool? _simulatedUser;
  bool? _isMuted;
  bool? _isBan;
  bool? _isDisabled;
  bool? _isDeactivate;
  String? _theme;
  String? _fontSize;
  dynamic _phone;
  dynamic _email;
  String? _style;
  String? _streamKey;
  String? _niu;
  String? _createdAt;
  String? _updatedAt;
  dynamic _connection;
Profile copyWith({  String? id,
  String? userId,
  String? avatar,
  dynamic coverImage,
  String? bio,
  num? notificationCount,
  num? posts,
  num? groupCount,
  num? pageCount,
  num? followings,
  num? followers,
  String? username,
  String? displayName,
  bool? notPublic,
  bool? deleted,
  bool? simulatedUser,
  bool? isMuted,
  bool? isBan,
  bool? isDisabled,
  bool? isDeactivate,
  String? theme,
  String? fontSize,
  dynamic phone,
  dynamic email,
  String? style,
  String? streamKey,
  String? niu,
  String? createdAt,
  String? updatedAt,
  dynamic connection,
}) => Profile(  id: id ?? _id,
  userId: userId ?? _userId,
  avatar: avatar ?? _avatar,
  coverImage: coverImage ?? _coverImage,
  bio: bio ?? _bio,
  notificationCount: notificationCount ?? _notificationCount,
  posts: posts ?? _posts,
  groupCount: groupCount ?? _groupCount,
  pageCount: pageCount ?? _pageCount,
  followings: followings ?? _followings,
  followers: followers ?? _followers,
  username: username ?? _username,
  displayName: displayName ?? _displayName,
  notPublic: notPublic ?? _notPublic,
  deleted: deleted ?? _deleted,
  simulatedUser: simulatedUser ?? _simulatedUser,
  isMuted: isMuted ?? _isMuted,
  isBan: isBan ?? _isBan,
  isDisabled: isDisabled ?? _isDisabled,
  isDeactivate: isDeactivate ?? _isDeactivate,
  theme: theme ?? _theme,
  fontSize: fontSize ?? _fontSize,
  phone: phone ?? _phone,
  email: email ?? _email,
  style: style ?? _style,
  streamKey: streamKey ?? _streamKey,
  niu: niu ?? _niu,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  connection: connection ?? _connection,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get avatar => _avatar;
  dynamic get coverImage => _coverImage;
  String? get bio => _bio;
  num? get notificationCount => _notificationCount;
  num? get posts => _posts;
  num? get groupCount => _groupCount;
  num? get pageCount => _pageCount;
  num? get followings => _followings;
  num? get followers => _followers;
  String? get username => _username;
  String? get displayName => _displayName;
  bool? get notPublic => _notPublic;
  bool? get deleted => _deleted;
  bool? get simulatedUser => _simulatedUser;
  bool? get isMuted => _isMuted;
  bool? get isBan => _isBan;
  bool? get isDisabled => _isDisabled;
  bool? get isDeactivate => _isDeactivate;
  String? get theme => _theme;
  String? get fontSize => _fontSize;
  dynamic get phone => _phone;
  dynamic get email => _email;
  String? get style => _style;
  String? get streamKey => _streamKey;
  String? get niu => _niu;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get connection => _connection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UserId'] = _userId;
    map['avatar'] = _avatar;
    map['coverImage'] = _coverImage;
    map['bio'] = _bio;
    map['notificationCount'] = _notificationCount;
    map['posts'] = _posts;
    map['groupCount'] = _groupCount;
    map['pageCount'] = _pageCount;
    map['followings'] = _followings;
    map['followers'] = _followers;
    map['username'] = _username;
    map['displayName'] = _displayName;
    map['notPublic'] = _notPublic;
    map['deleted'] = _deleted;
    map['simulatedUser'] = _simulatedUser;
    map['isMuted'] = _isMuted;
    map['isBan'] = _isBan;
    map['isDisabled'] = _isDisabled;
    map['isDeactivate'] = _isDeactivate;
    map['theme'] = _theme;
    map['fontSize'] = _fontSize;
    map['phone'] = _phone;
    map['email'] = _email;
    map['style'] = _style;
    map['stream_key'] = _streamKey;
    map['_niu'] = _niu;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['connection'] = _connection;
    return map;
  }

}