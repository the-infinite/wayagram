import 'dart:convert';
/// id : "6901080e-2118-4aaa-9b46-1f86b574bb70"
/// PollOptionId : "4f764586-c6e8-4297-abd1-3f13d9157df2"
/// ProfileId : "98622e64-b997-4595-93b1-d516606eb20e"
/// PollId : "158f3b63-13c1-4c56-9086-962b310efccd"
/// choice : "Kanu"
/// _v : "RGBA"
/// millisecCreatedAt : "0"
/// createdAt : "2022-12-06T12:38:21.066Z"
/// updatedAt : "2022-12-06T12:38:21.066Z"
/// VoterProfile : {"id":"98622e64-b997-4595-93b1-d516606eb20e","UserId":"121","avatar":null,"coverImage":null,"bio":null,"notificationCount":0,"posts":7,"groupCount":1,"pageCount":1,"followings":863,"followers":3,"username":"Dare121","displayName":"Aderinola Dare","notPublic":false,"deleted":false,"simulatedUser":false,"isMuted":false,"isBan":false,"isDisabled":false,"isDeactivate":false,"theme":"light","fontSize":"12px","phone":"2348111116818","email":"taiwodavid19@gmail.com","style":"italic","stream_key":"LW6FmW6jv","_v":"RGBA","createdAt":"2022-03-01T07:13:31.456Z","updatedAt":"2022-12-12T07:20:47.251Z","connection":{}}
/// totalAmount : 0

PollVotesProfile pollVotesFromJson(String str) => PollVotesProfile.fromJson(json.decode(str));
String pollVotesToJson(PollVotesProfile data) => json.encode(data.toJson());
class PollVotesProfile {
  PollVotesProfile({
      String? id, 
      String? pollOptionId, 
      String? profileId, 
      String? pollId, 
      String? choice, 
      String? v, 
      String? millisecCreatedAt, 
      String? createdAt, 
      String? updatedAt, 
      VoterProfile? voterProfile, 
      num? totalAmount,}){
    _id = id;
    _pollOptionId = pollOptionId;
    _profileId = profileId;
    _pollId = pollId;
    _choice = choice;
    _v = v;
    _millisecCreatedAt = millisecCreatedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _voterProfile = voterProfile;
    _totalAmount = totalAmount;
}

  PollVotesProfile.fromJson(dynamic json) {
    _id = json['id'];
    _pollOptionId = json['PollOptionId'];
    _profileId = json['ProfileId'];
    _pollId = json['PollId'];
    _choice = json['choice'];
    _v = json['_v'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _voterProfile = json['VoterProfile'] != null ? VoterProfile.fromJson(json['VoterProfile']) : null;
    _totalAmount = json['totalAmount'];
  }
  String? _id;
  String? _pollOptionId;
  String? _profileId;
  String? _pollId;
  String? _choice;
  String? _v;
  String? _millisecCreatedAt;
  String? _createdAt;
  String? _updatedAt;
  VoterProfile? _voterProfile;
  num? _totalAmount;
PollVotesProfile copyWith({  String? id,
  String? pollOptionId,
  String? profileId,
  String? pollId,
  String? choice,
  String? v,
  String? millisecCreatedAt,
  String? createdAt,
  String? updatedAt,
  VoterProfile? voterProfile,
  num? totalAmount,
}) => PollVotesProfile(  id: id ?? _id,
  pollOptionId: pollOptionId ?? _pollOptionId,
  profileId: profileId ?? _profileId,
  pollId: pollId ?? _pollId,
  choice: choice ?? _choice,
  v: v ?? _v,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  voterProfile: voterProfile ?? _voterProfile,
  totalAmount: totalAmount ?? _totalAmount,
);
  String? get id => _id;
  String? get pollOptionId => _pollOptionId;
  String? get profileId => _profileId;
  String? get pollId => _pollId;
  String? get choice => _choice;
  String? get v => _v;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  VoterProfile? get voterProfile => _voterProfile;
  num? get totalAmount => _totalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PollOptionId'] = _pollOptionId;
    map['ProfileId'] = _profileId;
    map['PollId'] = _pollId;
    map['choice'] = _choice;
    map['_v'] = _v;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_voterProfile != null) {
      map['VoterProfile'] = _voterProfile?.toJson();
    }
    map['totalAmount'] = _totalAmount;
    return map;
  }

  static List<PollVotesProfile> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => PollVotesProfile.fromJson(item)).toList();
  }

}

/// id : "98622e64-b997-4595-93b1-d516606eb20e"
/// UserId : "121"
/// avatar : null
/// coverImage : null
/// bio : null
/// notificationCount : 0
/// posts : 7
/// groupCount : 1
/// pageCount : 1
/// followings : 863
/// followers : 3
/// username : "Dare121"
/// displayName : "Aderinola Dare"
/// notPublic : false
/// deleted : false
/// simulatedUser : false
/// isMuted : false
/// isBan : false
/// isDisabled : false
/// isDeactivate : false
/// theme : "light"
/// fontSize : "12px"
/// phone : "2348111116818"
/// email : "taiwodavid19@gmail.com"
/// style : "italic"
/// stream_key : "LW6FmW6jv"
/// _v : "RGBA"
/// createdAt : "2022-03-01T07:13:31.456Z"
/// updatedAt : "2022-12-12T07:20:47.251Z"
/// connection : {}

VoterProfile voterProfileFromJson(String str) => VoterProfile.fromJson(json.decode(str));
String voterProfileToJson(VoterProfile data) => json.encode(data.toJson());
class VoterProfile {
  VoterProfile({
      String? id, 
      String? userId, 
      dynamic avatar, 
      dynamic coverImage, 
      dynamic bio, 
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
      String? phone, 
      String? email, 
      String? style, 
      String? streamKey, 
      String? v, 
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
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _connection = connection;
}

  VoterProfile.fromJson(dynamic json) {
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
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _connection = json['connection'];
  }
  String? _id;
  String? _userId;
  dynamic _avatar;
  dynamic _coverImage;
  dynamic _bio;
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
  String? _phone;
  String? _email;
  String? _style;
  String? _streamKey;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
  dynamic _connection;
VoterProfile copyWith({  String? id,
  String? userId,
  dynamic avatar,
  dynamic coverImage,
  dynamic bio,
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
  String? phone,
  String? email,
  String? style,
  String? streamKey,
  String? v,
  String? createdAt,
  String? updatedAt,
  dynamic connection,
}) => VoterProfile(  id: id ?? _id,
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
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  connection: connection ?? _connection,
);
  String? get id => _id;
  String? get userId => _userId;
  dynamic get avatar => _avatar;
  dynamic get coverImage => _coverImage;
  dynamic get bio => _bio;
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
  String? get phone => _phone;
  String? get email => _email;
  String? get style => _style;
  String? get streamKey => _streamKey;
  String? get v => _v;
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
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['connection'] = _connection;
    return map;
  }

}