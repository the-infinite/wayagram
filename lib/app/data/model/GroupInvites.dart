import 'dart:convert';
/// id : "87f60332-e4de-4757-a70a-c42b5ce576b5"
/// groupId : "38efe947-2270-4f4a-a53d-21e45df0c241"
/// requestFrom : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// requestTo : "bc63e326-7619-45da-9aab-0876d5e96956"
/// content : "@Vickoflow is inviting you to join hdf"
/// accepted : false
/// _v : "RGBA"
/// declined : false
/// createdAt : "2022-11-29T12:22:35.488Z"
/// updatedAt : "2022-11-29T12:22:35.488Z"
/// Profile : {"id":"c6812b92-b6f8-4953-a9f2-45ef15b15ec7","UserId":"313","avatar":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668454466812.octet-stream","coverImage":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669204457976.jpeg","bio":"Baddest ","notificationCount":53,"posts":93,"groupCount":6,"pageCount":7,"followings":529,"followers":9,"username":"Vickoflow","displayName":"Prince Victor ","notPublic":false,"deleted":false,"simulatedUser":false,"isMuted":false,"isBan":false,"isDisabled":false,"isDeactivate":false,"theme":"light","fontSize":"12px","phone":"2349034724572","email":"princevickolo@gmail.com","style":"italic","stream_key":"LW6FmW6jv","_v":"RGBA","createdAt":"2022-04-19T15:00:41.991Z","updatedAt":"2022-11-29T12:22:05.103Z"}
/// groupInvitationDetails : {"id":"38efe947-2270-4f4a-a53d-21e45df0c241","userId":"c6812b92-b6f8-4953-a9f2-45ef15b15ec7","category":"civil engineering","categoryId":null,"customCategory":"undefined","name":"hdf","description":"fgg","imageUrl":null,"headerImageUrl":null,"isPublic":true,"mute":false,"isDeleted":false,"allowMemberPost":true,"simulated":false,"_v":"RGBA","createdAt":"2022-11-29T12:22:05.080Z","updatedAt":"2022-11-29T12:22:05.080Z","numberOfMembers":1,"isUserAMember":true,"isUserAdmin":true,"isUserOnMute":false}

GroupInvites groupInvitesFromJson(String str) => GroupInvites.fromJson(json.decode(str));
String groupInvitesToJson(GroupInvites data) => json.encode(data.toJson());
class GroupInvites {
  GroupInvites({
      String? id,
      String? groupId, 
      String? requestFrom, 
      String? requestTo, 
      String? content, 
      bool? accepted, 
      String? v, 
      bool? declined, 
      String? createdAt, 
      String? updatedAt, 
      Profile? profile, 
      GroupInvitationDetails? groupInvitationDetails,}){
    _id = id;
    _groupId = groupId;
    _requestFrom = requestFrom;
    _requestTo = requestTo;
    _content = content;
    _accepted = accepted;
    _v = v;
    _declined = declined;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _profile = profile;
    _groupInvitationDetails = groupInvitationDetails;
}

  GroupInvites.fromJson(dynamic json) {
    _id = json['id'];
    _groupId = json['groupId'];
    _requestFrom = json['requestFrom'];
    _requestTo = json['requestTo'];
    _content = json['content'];
    _accepted = json['accepted'];
    _v = json['_v'];
    _declined = json['declined'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _profile = json['Profile'] != null ? Profile.fromJson(json['Profile']) : null;
    _groupInvitationDetails = json['groupInvitationDetails'] != null ? GroupInvitationDetails.fromJson(json['groupInvitationDetails']) : null;
  }
  String? _id;
  String? _groupId;
  String? _requestFrom;
  String? _requestTo;
  String? _content;
  bool? _accepted;
  String? _v;
  bool? _declined;
  String? _createdAt;
  String? _updatedAt;
  Profile? _profile;
  GroupInvitationDetails? _groupInvitationDetails;
GroupInvites copyWith({  String? id,
  String? groupId,
  String? requestFrom,
  String? requestTo,
  String? content,
  bool? accepted,
  String? v,
  bool? declined,
  String? createdAt,
  String? updatedAt,
  Profile? profile,
  GroupInvitationDetails? groupInvitationDetails,
}) => GroupInvites(  id: id ?? _id,
  groupId: groupId ?? _groupId,
  requestFrom: requestFrom ?? _requestFrom,
  requestTo: requestTo ?? _requestTo,
  content: content ?? _content,
  accepted: accepted ?? _accepted,
  v: v ?? _v,
  declined: declined ?? _declined,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  profile: profile ?? _profile,
  groupInvitationDetails: groupInvitationDetails ?? _groupInvitationDetails,
);
  String? get id => _id;
  String? get groupId => _groupId;
  String? get requestFrom => _requestFrom;
  String? get requestTo => _requestTo;
  String? get content => _content;
  bool? get accepted => _accepted;
  String? get v => _v;
  bool? get declined => _declined;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Profile? get profile => _profile;
  GroupInvitationDetails? get groupInvitationDetails => _groupInvitationDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['groupId'] = _groupId;
    map['requestFrom'] = _requestFrom;
    map['requestTo'] = _requestTo;
    map['content'] = _content;
    map['accepted'] = _accepted;
    map['_v'] = _v;
    map['declined'] = _declined;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_profile != null) {
      map['Profile'] = _profile?.toJson();
    }
    if (_groupInvitationDetails != null) {
      map['groupInvitationDetails'] = _groupInvitationDetails?.toJson();
    }
    return map;
  }

  static List<GroupInvites> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => GroupInvites.fromJson(item)).toList();
  }
}

/// id : "38efe947-2270-4f4a-a53d-21e45df0c241"
/// userId : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// category : "civil engineering"
/// categoryId : null
/// customCategory : "undefined"
/// name : "hdf"
/// description : "fgg"
/// imageUrl : null
/// headerImageUrl : null
/// isPublic : true
/// mute : false
/// isDeleted : false
/// allowMemberPost : true
/// simulated : false
/// _v : "RGBA"
/// createdAt : "2022-11-29T12:22:05.080Z"
/// updatedAt : "2022-11-29T12:22:05.080Z"
/// numberOfMembers : 1
/// isUserAMember : true
/// isUserAdmin : true
/// isUserOnMute : false

GroupInvitationDetails groupInvitationDetailsFromJson(String str) => GroupInvitationDetails.fromJson(json.decode(str));
String groupInvitationDetailsToJson(GroupInvitationDetails data) => json.encode(data.toJson());
class GroupInvitationDetails {
  GroupInvitationDetails({
      String? id, 
      String? userId, 
      String? category, 
      dynamic categoryId, 
      String? customCategory, 
      String? name, 
      String? description, 
      dynamic imageUrl, 
      dynamic headerImageUrl, 
      bool? isPublic, 
      bool? mute, 
      bool? isDeleted, 
      bool? allowMemberPost, 
      bool? simulated, 
      String? v, 
      String? createdAt, 
      String? updatedAt, 
      num? numberOfMembers, 
      bool? isUserAMember, 
      bool? isUserAdmin, 
      bool? isUserOnMute,}){
    _id = id;
    _userId = userId;
    _category = category;
    _categoryId = categoryId;
    _customCategory = customCategory;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _headerImageUrl = headerImageUrl;
    _isPublic = isPublic;
    _mute = mute;
    _isDeleted = isDeleted;
    _allowMemberPost = allowMemberPost;
    _simulated = simulated;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _numberOfMembers = numberOfMembers;
    _isUserAMember = isUserAMember;
    _isUserAdmin = isUserAdmin;
    _isUserOnMute = isUserOnMute;
}

  GroupInvitationDetails.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _category = json['category'];
    _categoryId = json['categoryId'];
    _customCategory = json['customCategory'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _headerImageUrl = json['headerImageUrl'];
    _isPublic = json['isPublic'];
    _mute = json['mute'];
    _isDeleted = json['isDeleted'];
    _allowMemberPost = json['allowMemberPost'];
    _simulated = json['simulated'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _numberOfMembers = json['numberOfMembers'];
    _isUserAMember = json['isUserAMember'];
    _isUserAdmin = json['isUserAdmin'];
    _isUserOnMute = json['isUserOnMute'];
  }
  String? _id;
  String? _userId;
  String? _category;
  dynamic _categoryId;
  String? _customCategory;
  String? _name;
  String? _description;
  dynamic _imageUrl;
  dynamic _headerImageUrl;
  bool? _isPublic;
  bool? _mute;
  bool? _isDeleted;
  bool? _allowMemberPost;
  bool? _simulated;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
  num? _numberOfMembers;
  bool? _isUserAMember;
  bool? _isUserAdmin;
  bool? _isUserOnMute;
GroupInvitationDetails copyWith({  String? id,
  String? userId,
  String? category,
  dynamic categoryId,
  String? customCategory,
  String? name,
  String? description,
  dynamic imageUrl,
  dynamic headerImageUrl,
  bool? isPublic,
  bool? mute,
  bool? isDeleted,
  bool? allowMemberPost,
  bool? simulated,
  String? v,
  String? createdAt,
  String? updatedAt,
  num? numberOfMembers,
  bool? isUserAMember,
  bool? isUserAdmin,
  bool? isUserOnMute,
}) => GroupInvitationDetails(  id: id ?? _id,
  userId: userId ?? _userId,
  category: category ?? _category,
  categoryId: categoryId ?? _categoryId,
  customCategory: customCategory ?? _customCategory,
  name: name ?? _name,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  headerImageUrl: headerImageUrl ?? _headerImageUrl,
  isPublic: isPublic ?? _isPublic,
  mute: mute ?? _mute,
  isDeleted: isDeleted ?? _isDeleted,
  allowMemberPost: allowMemberPost ?? _allowMemberPost,
  simulated: simulated ?? _simulated,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  numberOfMembers: numberOfMembers ?? _numberOfMembers,
  isUserAMember: isUserAMember ?? _isUserAMember,
  isUserAdmin: isUserAdmin ?? _isUserAdmin,
  isUserOnMute: isUserOnMute ?? _isUserOnMute,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get category => _category;
  dynamic get categoryId => _categoryId;
  String? get customCategory => _customCategory;
  String? get name => _name;
  String? get description => _description;
  dynamic get imageUrl => _imageUrl;
  dynamic get headerImageUrl => _headerImageUrl;
  bool? get isPublic => _isPublic;
  bool? get mute => _mute;
  bool? get isDeleted => _isDeleted;
  bool? get allowMemberPost => _allowMemberPost;
  bool? get simulated => _simulated;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get numberOfMembers => _numberOfMembers;
  bool? get isUserAMember => _isUserAMember;
  bool? get isUserAdmin => _isUserAdmin;
  bool? get isUserOnMute => _isUserOnMute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['category'] = _category;
    map['categoryId'] = _categoryId;
    map['customCategory'] = _customCategory;
    map['name'] = _name;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['headerImageUrl'] = _headerImageUrl;
    map['isPublic'] = _isPublic;
    map['mute'] = _mute;
    map['isDeleted'] = _isDeleted;
    map['allowMemberPost'] = _allowMemberPost;
    map['simulated'] = _simulated;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['numberOfMembers'] = _numberOfMembers;
    map['isUserAMember'] = _isUserAMember;
    map['isUserAdmin'] = _isUserAdmin;
    map['isUserOnMute'] = _isUserOnMute;
    return map;
  }

}

/// id : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// UserId : "313"
/// avatar : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668454466812.octet-stream"
/// coverImage : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669204457976.jpeg"
/// bio : "Baddest "
/// notificationCount : 53
/// posts : 93
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
/// updatedAt : "2022-11-29T12:22:05.103Z"

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
      String? updatedAt,}){
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
    return map;
  }

}