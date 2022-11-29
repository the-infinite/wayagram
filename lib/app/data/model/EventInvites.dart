import 'dart:convert';
/// id : "6f416a1d-22d4-49f9-8d9f-0995e582b37b"
/// ProfileId : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// InviteeId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// EventId : "e4821632-902f-4fac-99aa-b41d33a68d63"
/// content : "Vickoflow is inviting you to attend an event: Testing Invite"
/// accept : false
/// reject : false
/// _v : "RGBA"
/// createdAt : "2022-11-29T12:51:46.903Z"
/// updatedAt : "2022-11-29T12:51:46.903Z"
/// Profile : {"id":"c6812b92-b6f8-4953-a9f2-45ef15b15ec7","UserId":"313","avatar":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668454466812.octet-stream","coverImage":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669204457976.jpeg","bio":"Baddest ","notificationCount":54,"posts":92,"groupCount":6,"pageCount":7,"followings":529,"followers":9,"username":"Vickoflow","displayName":"Prince Victor ","notPublic":false,"deleted":false,"simulatedUser":false,"isMuted":false,"isBan":false,"isDisabled":false,"isDeactivate":false,"theme":"light","fontSize":"12px","phone":"2349034724572","email":"princevickolo@gmail.com","style":"italic","stream_key":"LW6FmW6jv","_v":"RGBA","createdAt":"2022-04-19T15:00:41.991Z","updatedAt":"2022-11-29T12:51:24.456Z","connection":{"connected":true,"isAccepted":true,"isPending":false,"isDeclined":true,"muted":true,"blocked":false,"following":true,"followsYou":true}}

EventInvites eventInvitesFromJson(String str) => EventInvites.fromJson(json.decode(str));
String eventInvitesToJson(EventInvites data) => json.encode(data.toJson());
class EventInvites {
  EventInvites({
      String? id,
      String? profileId, 
      String? inviteeId, 
      String? eventId, 
      String? content, 
      bool? accept, 
      bool? reject, 
      String? v, 
      String? createdAt, 
      String? updatedAt, 
      Profile? profile,}){
    _id = id;
    _profileId = profileId;
    _inviteeId = inviteeId;
    _eventId = eventId;
    _content = content;
    _accept = accept;
    _reject = reject;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _profile = profile;
}

  EventInvites.fromJson(dynamic json) {
    _id = json['id'];
    _profileId = json['ProfileId'];
    _inviteeId = json['InviteeId'];
    _eventId = json['EventId'];
    _content = json['content'];
    _accept = json['accept'];
    _reject = json['reject'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _profile = json['Profile'] != null ? Profile.fromJson(json['Profile']) : null;
  }
  String? _id;
  String? _profileId;
  String? _inviteeId;
  String? _eventId;
  String? _content;
  bool? _accept;
  bool? _reject;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
  Profile? _profile;
EventInvites copyWith({  String? id,
  String? profileId,
  String? inviteeId,
  String? eventId,
  String? content,
  bool? accept,
  bool? reject,
  String? v,
  String? createdAt,
  String? updatedAt,
  Profile? profile,
}) => EventInvites(  id: id ?? _id,
  profileId: profileId ?? _profileId,
  inviteeId: inviteeId ?? _inviteeId,
  eventId: eventId ?? _eventId,
  content: content ?? _content,
  accept: accept ?? _accept,
  reject: reject ?? _reject,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  profile: profile ?? _profile,
);
  String? get id => _id;
  String? get profileId => _profileId;
  String? get inviteeId => _inviteeId;
  String? get eventId => _eventId;
  String? get content => _content;
  bool? get accept => _accept;
  bool? get reject => _reject;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Profile? get profile => _profile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProfileId'] = _profileId;
    map['InviteeId'] = _inviteeId;
    map['EventId'] = _eventId;
    map['content'] = _content;
    map['accept'] = _accept;
    map['reject'] = _reject;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_profile != null) {
      map['Profile'] = _profile?.toJson();
    }
    return map;
  }

  static List<EventInvites> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => EventInvites.fromJson(item)).toList();
  }

}

/// id : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// UserId : "313"
/// avatar : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668454466812.octet-stream"
/// coverImage : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669204457976.jpeg"
/// bio : "Baddest "
/// notificationCount : 54
/// posts : 92
/// groupCount : 6
/// pageCount : 7
/// followings : 529
/// followers : 9
/// username : "Vickoflow"
/// displayName : "Prince Victor "
/// notPublic : false
/// deleted : false
/// simulatedUser : false
/// isMuted : false
/// isBan : false
/// isDisabled : false
/// isDeactivate : false
/// theme : "light"
/// fontSize : "12px"
/// phone : "2349034724572"
/// email : "princevickolo@gmail.com"
/// style : "italic"
/// stream_key : "LW6FmW6jv"
/// _v : "RGBA"
/// createdAt : "2022-04-19T15:00:41.991Z"
/// updatedAt : "2022-11-29T12:51:24.456Z"
/// connection : {"connected":true,"isAccepted":true,"isPending":false,"isDeclined":true,"muted":true,"blocked":false,"following":true,"followsYou":true}

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));
String profileToJson(Profile data) => json.encode(data.toJson());
class Profile {
  Profile({
      String? id, 
      String? userId, 
      String? avatar, 
      String? coverImage, 
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
      String? phone, 
      String? email, 
      String? style, 
      String? streamKey, 
      String? v, 
      String? createdAt, 
      String? updatedAt, 
      Connection? connection,}){
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
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _connection = json['connection'] != null ? Connection.fromJson(json['connection']) : null;
  }
  String? _id;
  String? _userId;
  String? _avatar;
  String? _coverImage;
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
  String? _phone;
  String? _email;
  String? _style;
  String? _streamKey;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
  Connection? _connection;
Profile copyWith({  String? id,
  String? userId,
  String? avatar,
  String? coverImage,
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
  String? phone,
  String? email,
  String? style,
  String? streamKey,
  String? v,
  String? createdAt,
  String? updatedAt,
  Connection? connection,
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
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  connection: connection ?? _connection,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get avatar => _avatar;
  String? get coverImage => _coverImage;
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
  String? get phone => _phone;
  String? get email => _email;
  String? get style => _style;
  String? get streamKey => _streamKey;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Connection? get connection => _connection;

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
    if (_connection != null) {
      map['connection'] = _connection?.toJson();
    }
    return map;
  }

}

/// connected : true
/// isAccepted : true
/// isPending : false
/// isDeclined : true
/// muted : true
/// blocked : false
/// following : true
/// followsYou : true

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