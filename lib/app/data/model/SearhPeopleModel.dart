import 'dart:convert';
/// UserId : "135"
/// avatar : null
/// simulatedUser : false
/// deleted : false
/// notificationCount : 0
/// email : null
/// phone : null
/// coverImage : null
/// username : "Kaodiechi"
/// displayName : "Chinonso Kaodiechi"
/// notPublic : false
/// id : "14b4d7e4-f3b7-4808-b5c2-211aa095e4dd"
/// bio : null
/// isMuted : false
/// connection : {"connected":false,"isAccepted":false,"isPending":false,"isDeclined":false,"muted":false,"blocked":false,"following":false,"followsYou":false}

SearchPeopleModel searchPeopleModelFromJson(String str) => SearchPeopleModel.fromJson(json.decode(str));
String searchPeopleModelToJson(SearchPeopleModel data) => json.encode(data.toJson());
class SearchPeopleModel {
  SearchPeopleModel({
      String? userId, 
      dynamic avatar, 
      bool? simulatedUser, 
      bool? deleted, 
      num? notificationCount, 
      dynamic email, 
      dynamic phone, 
      dynamic coverImage, 
      String? username, 
      String? displayName, 
      bool? notPublic, 
      String? id, 
      dynamic bio, 
      bool? isMuted, 
      Connection? connection,}){
    _userId = userId;
    _avatar = avatar;
    _simulatedUser = simulatedUser;
    _deleted = deleted;
    _notificationCount = notificationCount;
    _email = email;
    _phone = phone;
    _coverImage = coverImage;
    _username = username;
    _displayName = displayName;
    _notPublic = notPublic;
    _id = id;
    _bio = bio;
    _isMuted = isMuted;
    _connection = connection;
}

  SearchPeopleModel.fromJson(dynamic json) {
    _userId = json['UserId'];
    _avatar = json['avatar'];
    _simulatedUser = json['simulatedUser'];
    _deleted = json['deleted'];
    _notificationCount = json['notificationCount'];
    _email = json['email'];
    _phone = json['phone'];
    _coverImage = json['coverImage'];
    _username = json['username'];
    _displayName = json['displayName'];
    _notPublic = json['notPublic'];
    _id = json['id'];
    _bio = json['bio'];
    _isMuted = json['isMuted'];
    _connection = json['connection'] != null ? Connection.fromJson(json['connection']) : null;
  }
  String? _userId;
  dynamic _avatar;
  bool? _simulatedUser;
  bool? _deleted;
  num? _notificationCount;
  dynamic _email;
  dynamic _phone;
  dynamic _coverImage;
  String? _username;
  String? _displayName;
  bool? _notPublic;
  String? _id;
  dynamic _bio;
  bool? _isMuted;
  Connection? _connection;
SearchPeopleModel copyWith({  String? userId,
  dynamic avatar,
  bool? simulatedUser,
  bool? deleted,
  num? notificationCount,
  dynamic email,
  dynamic phone,
  dynamic coverImage,
  String? username,
  String? displayName,
  bool? notPublic,
  String? id,
  dynamic bio,
  bool? isMuted,
  Connection? connection,
}) => SearchPeopleModel(  userId: userId ?? _userId,
  avatar: avatar ?? _avatar,
  simulatedUser: simulatedUser ?? _simulatedUser,
  deleted: deleted ?? _deleted,
  notificationCount: notificationCount ?? _notificationCount,
  email: email ?? _email,
  phone: phone ?? _phone,
  coverImage: coverImage ?? _coverImage,
  username: username ?? _username,
  displayName: displayName ?? _displayName,
  notPublic: notPublic ?? _notPublic,
  id: id ?? _id,
  bio: bio ?? _bio,
  isMuted: isMuted ?? _isMuted,
  connection: connection ?? _connection,
);
  String? get userId => _userId;
  dynamic get avatar => _avatar;
  bool? get simulatedUser => _simulatedUser;
  bool? get deleted => _deleted;
  num? get notificationCount => _notificationCount;
  dynamic get email => _email;
  dynamic get phone => _phone;
  dynamic get coverImage => _coverImage;
  String? get username => _username;
  String? get displayName => _displayName;
  bool? get notPublic => _notPublic;
  String? get id => _id;
  dynamic get bio => _bio;
  bool? get isMuted => _isMuted;
  Connection? get connection => _connection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UserId'] = _userId;
    map['avatar'] = _avatar;
    map['simulatedUser'] = _simulatedUser;
    map['deleted'] = _deleted;
    map['notificationCount'] = _notificationCount;
    map['email'] = _email;
    map['phone'] = _phone;
    map['coverImage'] = _coverImage;
    map['username'] = _username;
    map['displayName'] = _displayName;
    map['notPublic'] = _notPublic;
    map['id'] = _id;
    map['bio'] = _bio;
    map['isMuted'] = _isMuted;
    if (_connection != null) {
      map['connection'] = _connection?.toJson();
    }
    return map;
  }

  static List<SearchPeopleModel> getService(List<dynamic> val) {
    return val.map((e) => SearchPeopleModel.fromJson(e)).toList();
  }

}

/// connected : false
/// isAccepted : false
/// isPending : false
/// isDeclined : false
/// muted : false
/// blocked : false
/// following : false
/// followsYou : false

Connection connectionFromJson(String str) => Connection.fromJson(json.decode(str));
String connectionToJson(Connection data) => json.encode(data.toJson());
class Connection {
  Connection({
      bool? connected, 
      bool? isAccepted, 
      bool? isPending, 
      bool? isDeclined, 
      bool? muted, 
      bool? blocked, 
      bool? following, 
      bool? followsYou,}){
    _connected = connected;
    _isAccepted = isAccepted;
    _isPending = isPending;
    _isDeclined = isDeclined;
    _muted = muted;
    _blocked = blocked;
    _following = following;
    _followsYou = followsYou;
}

  Connection.fromJson(dynamic json) {
    _connected = json['connected'];
    _isAccepted = json['isAccepted'];
    _isPending = json['isPending'];
    _isDeclined = json['isDeclined'];
    _muted = json['muted'];
    _blocked = json['blocked'];
    _following = json['following'];
    _followsYou = json['followsYou'];
  }
  bool? _connected;
  bool? _isAccepted;
  bool? _isPending;
  bool? _isDeclined;
  bool? _muted;
  bool? _blocked;
  bool? _following;
  bool? _followsYou;
Connection copyWith({  bool? connected,
  bool? isAccepted,
  bool? isPending,
  bool? isDeclined,
  bool? muted,
  bool? blocked,
  bool? following,
  bool? followsYou,
}) => Connection(  connected: connected ?? _connected,
  isAccepted: isAccepted ?? _isAccepted,
  isPending: isPending ?? _isPending,
  isDeclined: isDeclined ?? _isDeclined,
  muted: muted ?? _muted,
  blocked: blocked ?? _blocked,
  following: following ?? _following,
  followsYou: followsYou ?? _followsYou,
);
  bool? get connected => _connected;
  bool? get isAccepted => _isAccepted;
  bool? get isPending => _isPending;
  bool? get isDeclined => _isDeclined;
  bool? get muted => _muted;
  bool? get blocked => _blocked;
  bool? get following => _following;
  bool? get followsYou => _followsYou;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['connected'] = _connected;
    map['isAccepted'] = _isAccepted;
    map['isPending'] = _isPending;
    map['isDeclined'] = _isDeclined;
    map['muted'] = _muted;
    map['blocked'] = _blocked;
    map['following'] = _following;
    map['followsYou'] = _followsYou;
    return map;
  }

}