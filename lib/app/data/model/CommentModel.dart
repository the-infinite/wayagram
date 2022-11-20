import 'dart:convert';
/// id : "97a1f014-e455-4206-9d38-a0f34304b7a2"
/// type : "user"
/// comment : "really nice"
/// PostId : "483abf01-2edb-4f35-ae9a-4cdc6b8987de"
/// ProfileId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// ParentId : null
/// likeCount : 0
/// unLikeCount : "0"
/// isDeleted : false
/// millisecCreatedAt : "1668798367253"
/// millisecUpdatedAt : "1668798367253"
/// _v : "RGBA"
/// createdAt : "2022-11-20T20:39:13.978Z"
/// updatedAt : "2022-11-20T20:39:13.978Z"
/// Profile : {"id":"bc63e326-7619-45da-9aab-0876d5e96956","UserId":"639","avatar":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668666554831.octet-stream","coverImage":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668444308492.jpeg","bio":"Everything","notificationCount":5,"posts":60,"groupCount":8,"pageCount":2,"followings":22,"followers":2,"username":"Arowolo","displayName":"Cephas Peter","notPublic":false,"deleted":false,"simulatedUser":false,"isMuted":false,"isBan":false,"isDisabled":false,"isDeactivate":false,"theme":"light","fontSize":"12px","phone":"2348116074308","email":"cephasarowolo@gmail.com","style":"italic","stream_key":"LW6FmW6jv","_v":"RGBA","createdAt":"2022-07-07T08:31:33.608Z","updatedAt":"2022-11-20T20:36:43.116Z","connection":{}}
/// isLiked : false
/// isOwner : true

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));
String commentModelToJson(CommentModel data) => json.encode(data.toJson());
class CommentModel {
  CommentModel({
      String? id, 
      String? type, 
      String? comment, 
      String? postId, 
      String? profileId, 
      dynamic parentId, 
      num? likeCount, 
      String? unLikeCount, 
      bool? isDeleted, 
      String? millisecCreatedAt, 
      String? millisecUpdatedAt, 
      String? v,
      String? createdAt, 
      String? updatedAt, 
      Profile? profile, 
      bool? isLiked, 
      bool? isOwner,}){
    _id = id;
    _type = type;
    _comment = comment;
    _postId = postId;
    _profileId = profileId;
    _parentId = parentId;
    _likeCount = likeCount;
    _unLikeCount = unLikeCount;
    _isDeleted = isDeleted;
    _millisecCreatedAt = millisecCreatedAt;
    _millisecUpdatedAt = millisecUpdatedAt;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _profile = profile;
    _isLiked = isLiked;
    _isOwner = isOwner;
}

  CommentModel.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _comment = json['comment'];
    _postId = json['PostId'];
    _profileId = json['ProfileId'];
    _parentId = json['ParentId'];
    _likeCount = json['likeCount'];
    _unLikeCount = json['unLikeCount'];
    _isDeleted = json['isDeleted'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _millisecUpdatedAt = json['millisecUpdatedAt'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _profile = json['Profile'] != null ? Profile.fromJson(json['Profile']) : null;
    _isLiked = json['isLiked'];
    _isOwner = json['isOwner'];
  }
  String? _id;
  String? _type;
  String? _comment;
  String? _postId;
  String? _profileId;
  dynamic _parentId;
  num? _likeCount;
  String? _unLikeCount;
  bool? _isDeleted;
  String? _millisecCreatedAt;
  String? _millisecUpdatedAt;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
  Profile? _profile;
  bool? _isLiked;
  bool? _isOwner;
CommentModel copyWith({  String? id,
  String? type,
  String? comment,
  String? postId,
  String? profileId,
  dynamic parentId,
  num? likeCount,
  String? unLikeCount,
  bool? isDeleted,
  String? millisecCreatedAt,
  String? millisecUpdatedAt,
  String? v,
  String? createdAt,
  String? updatedAt,
  Profile? profile,
  bool? isLiked,
  bool? isOwner,
}) => CommentModel(  id: id ?? _id,
  type: type ?? _type,
  comment: comment ?? _comment,
  postId: postId ?? _postId,
  profileId: profileId ?? _profileId,
  parentId: parentId ?? _parentId,
  likeCount: likeCount ?? _likeCount,
  unLikeCount: unLikeCount ?? _unLikeCount,
  isDeleted: isDeleted ?? _isDeleted,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  millisecUpdatedAt: millisecUpdatedAt ?? _millisecUpdatedAt,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  profile: profile ?? _profile,
  isLiked: isLiked ?? _isLiked,
  isOwner: isOwner ?? _isOwner,
);
  String? get id => _id;
  String? get type => _type;
  String? get comment => _comment;
  String? get postId => _postId;
  String? get profileId => _profileId;
  dynamic get parentId => _parentId;
  num? get likeCount => _likeCount;
  String? get unLikeCount => _unLikeCount;
  bool? get isDeleted => _isDeleted;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get millisecUpdatedAt => _millisecUpdatedAt;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Profile? get profile => _profile;
  bool? get isLiked => _isLiked;
  bool? get isOwner => _isOwner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['comment'] = _comment;
    map['PostId'] = _postId;
    map['ProfileId'] = _profileId;
    map['ParentId'] = _parentId;
    map['likeCount'] = _likeCount;
    map['unLikeCount'] = _unLikeCount;
    map['isDeleted'] = _isDeleted;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['millisecUpdatedAt'] = _millisecUpdatedAt;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_profile != null) {
      map['Profile'] = _profile?.toJson();
    }
    map['isLiked'] = _isLiked;
    map['isOwner'] = _isOwner;
    return map;
  }

  static List<CommentModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => CommentModel.fromJson(item)).toList();
  }
}

/// id : "bc63e326-7619-45da-9aab-0876d5e96956"
/// UserId : "639"
/// avatar : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668666554831.octet-stream"
/// coverImage : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668444308492.jpeg"
/// bio : "Everything"
/// notificationCount : 5
/// posts : 60
/// groupCount : 8
/// pageCount : 2
/// followings : 22
/// followers : 2
/// username : "Arowolo"
/// displayName : "Cephas Peter"
/// notPublic : false
/// deleted : false
/// simulatedUser : false
/// isMuted : false
/// isBan : false
/// isDisabled : false
/// isDeactivate : false
/// theme : "light"
/// fontSize : "12px"
/// phone : "2348116074308"
/// email : "cephasarowolo@gmail.com"
/// style : "italic"
/// stream_key : "LW6FmW6jv"
/// _v : "RGBA"
/// createdAt : "2022-07-07T08:31:33.608Z"
/// updatedAt : "2022-11-20T20:36:43.116Z"
/// connection : {}

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
    _connection = json['connection'];
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
  dynamic _connection;
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