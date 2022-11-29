import 'dart:convert';

PageInvites pageInvitesFromJson(String str) => PageInvites.fromJson(json.decode(str));
String pageInvitesToJson(PageInvites data) => json.encode(data.toJson());
class PageInvites {
  PageInvites({
      String? id,
      String? pageId, 
      String? requestFrom, 
      String? content, 
      String? requestTo, 
      bool? accepted, 
      String? v, 
      bool? declined, 
      String? createdAt, 
      String? updatedAt, 
      Profile? profile, 
      PageInvitationDetails? pageInvitationDetails,}){
    _id = id;
    _pageId = pageId;
    _requestFrom = requestFrom;
    _content = content;
    _requestTo = requestTo;
    _accepted = accepted;
    _v = v;
    _declined = declined;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _profile = profile;
    _pageInvitationDetails = pageInvitationDetails;
}

  PageInvites.fromJson(dynamic json) {
    _id = json['id'];
    _pageId = json['pageId'];
    _requestFrom = json['requestFrom'];
    _content = json['content'];
    _requestTo = json['requestTo'];
    _accepted = json['accepted'];
    _v = json['_v'];
    _declined = json['declined'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _profile = json['Profile'] != null ? Profile.fromJson(json['Profile']) : null;
    _pageInvitationDetails = json['PageInvitationDetails'] != null ? PageInvitationDetails.fromJson(json['PageInvitationDetails']) : null;
  }
  String? _id;
  String? _pageId;
  String? _requestFrom;
  String? _content;
  String? _requestTo;
  bool? _accepted;
  String? _v;
  bool? _declined;
  String? _createdAt;
  String? _updatedAt;
  Profile? _profile;
  PageInvitationDetails? _pageInvitationDetails;
PageInvites copyWith({  String? id,
  String? pageId,
  String? requestFrom,
  String? content,
  String? requestTo,
  bool? accepted,
  String? v,
  bool? declined,
  String? createdAt,
  String? updatedAt,
  Profile? profile,
  PageInvitationDetails? pageInvitationDetails,
}) => PageInvites(  id: id ?? _id,
  pageId: pageId ?? _pageId,
  requestFrom: requestFrom ?? _requestFrom,
  content: content ?? _content,
  requestTo: requestTo ?? _requestTo,
  accepted: accepted ?? _accepted,
  v: v ?? _v,
  declined: declined ?? _declined,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  profile: profile ?? _profile,
  pageInvitationDetails: pageInvitationDetails ?? _pageInvitationDetails,
);
  String? get id => _id;
  String? get pageId => _pageId;
  String? get requestFrom => _requestFrom;
  String? get content => _content;
  String? get requestTo => _requestTo;
  bool? get accepted => _accepted;
  String? get v => _v;
  bool? get declined => _declined;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Profile? get profile => _profile;
  PageInvitationDetails? get pageInvitationDetails => _pageInvitationDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['pageId'] = _pageId;
    map['requestFrom'] = _requestFrom;
    map['content'] = _content;
    map['requestTo'] = _requestTo;
    map['accepted'] = _accepted;
    map['_v'] = _v;
    map['declined'] = _declined;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_profile != null) {
      map['Profile'] = _profile?.toJson();
    }
    if (_pageInvitationDetails != null) {
      map['PageInvitationDetails'] = _pageInvitationDetails?.toJson();
    }
    return map;
  }

  static List<PageInvites> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => PageInvites.fromJson(item)).toList();
  }

}

/// id : "2f3c3dbf-be5e-4c9e-ad0f-806f618e10cf"
/// userId : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// categoryId : "d4592666-5dfc-47e6-87f6-bd6c38dd2854"
/// category : "chemistry"
/// customCategory : "undefined"
/// username : "HIghwr"
/// title : "HIghwr"
/// description : "sc,xc"
/// websiteUrl : null
/// imageUrl : null
/// lastActivityDate : "2022-11-24T18:36:25.963Z"
/// headerImageUrl : null
/// isPublic : false
/// isDeleted : false
/// simulated : false
/// _v : "RG"
/// createdAt : "2022-11-29T12:21:40.704Z"
/// updatedAt : "2022-11-29T12:21:40.704Z"
/// numberOfFollowers : 1
/// pageLIkes : 0
/// isFollowing : true
/// hasLikedThisPage : false
/// isAdmin : true

PageInvitationDetails pageInvitationDetailsFromJson(String str) => PageInvitationDetails.fromJson(json.decode(str));
String pageInvitationDetailsToJson(PageInvitationDetails data) => json.encode(data.toJson());
class PageInvitationDetails {
  PageInvitationDetails({
      String? id, 
      String? userId, 
      String? categoryId, 
      String? category, 
      String? customCategory, 
      String? username, 
      String? title, 
      String? description, 
      dynamic websiteUrl, 
      dynamic imageUrl, 
      String? lastActivityDate, 
      dynamic headerImageUrl, 
      bool? isPublic, 
      bool? isDeleted, 
      bool? simulated, 
      String? v, 
      String? createdAt, 
      String? updatedAt, 
      num? numberOfFollowers, 
      num? pageLIkes, 
      bool? isFollowing, 
      bool? hasLikedThisPage, 
      bool? isAdmin,}){
    _id = id;
    _userId = userId;
    _categoryId = categoryId;
    _category = category;
    _customCategory = customCategory;
    _username = username;
    _title = title;
    _description = description;
    _websiteUrl = websiteUrl;
    _imageUrl = imageUrl;
    _lastActivityDate = lastActivityDate;
    _headerImageUrl = headerImageUrl;
    _isPublic = isPublic;
    _isDeleted = isDeleted;
    _simulated = simulated;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _numberOfFollowers = numberOfFollowers;
    _pageLIkes = pageLIkes;
    _isFollowing = isFollowing;
    _hasLikedThisPage = hasLikedThisPage;
    _isAdmin = isAdmin;
}

  PageInvitationDetails.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _categoryId = json['categoryId'];
    _category = json['category'];
    _customCategory = json['customCategory'];
    _username = json['username'];
    _title = json['title'];
    _description = json['description'];
    _websiteUrl = json['websiteUrl'];
    _imageUrl = json['imageUrl'];
    _lastActivityDate = json['lastActivityDate'];
    _headerImageUrl = json['headerImageUrl'];
    _isPublic = json['isPublic'];
    _isDeleted = json['isDeleted'];
    _simulated = json['simulated'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _numberOfFollowers = json['numberOfFollowers'];
    _pageLIkes = json['pageLIkes'];
    _isFollowing = json['isFollowing'];
    _hasLikedThisPage = json['hasLikedThisPage'];
    _isAdmin = json['isAdmin'];
  }
  String? _id;
  String? _userId;
  String? _categoryId;
  String? _category;
  String? _customCategory;
  String? _username;
  String? _title;
  String? _description;
  dynamic _websiteUrl;
  dynamic _imageUrl;
  String? _lastActivityDate;
  dynamic _headerImageUrl;
  bool? _isPublic;
  bool? _isDeleted;
  bool? _simulated;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
  num? _numberOfFollowers;
  num? _pageLIkes;
  bool? _isFollowing;
  bool? _hasLikedThisPage;
  bool? _isAdmin;
PageInvitationDetails copyWith({  String? id,
  String? userId,
  String? categoryId,
  String? category,
  String? customCategory,
  String? username,
  String? title,
  String? description,
  dynamic websiteUrl,
  dynamic imageUrl,
  String? lastActivityDate,
  dynamic headerImageUrl,
  bool? isPublic,
  bool? isDeleted,
  bool? simulated,
  String? v,
  String? createdAt,
  String? updatedAt,
  num? numberOfFollowers,
  num? pageLIkes,
  bool? isFollowing,
  bool? hasLikedThisPage,
  bool? isAdmin,
}) => PageInvitationDetails(  id: id ?? _id,
  userId: userId ?? _userId,
  categoryId: categoryId ?? _categoryId,
  category: category ?? _category,
  customCategory: customCategory ?? _customCategory,
  username: username ?? _username,
  title: title ?? _title,
  description: description ?? _description,
  websiteUrl: websiteUrl ?? _websiteUrl,
  imageUrl: imageUrl ?? _imageUrl,
  lastActivityDate: lastActivityDate ?? _lastActivityDate,
  headerImageUrl: headerImageUrl ?? _headerImageUrl,
  isPublic: isPublic ?? _isPublic,
  isDeleted: isDeleted ?? _isDeleted,
  simulated: simulated ?? _simulated,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  numberOfFollowers: numberOfFollowers ?? _numberOfFollowers,
  pageLIkes: pageLIkes ?? _pageLIkes,
  isFollowing: isFollowing ?? _isFollowing,
  hasLikedThisPage: hasLikedThisPage ?? _hasLikedThisPage,
  isAdmin: isAdmin ?? _isAdmin,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get categoryId => _categoryId;
  String? get category => _category;
  String? get customCategory => _customCategory;
  String? get username => _username;
  String? get title => _title;
  String? get description => _description;
  dynamic get websiteUrl => _websiteUrl;
  dynamic get imageUrl => _imageUrl;
  String? get lastActivityDate => _lastActivityDate;
  dynamic get headerImageUrl => _headerImageUrl;
  bool? get isPublic => _isPublic;
  bool? get isDeleted => _isDeleted;
  bool? get simulated => _simulated;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get numberOfFollowers => _numberOfFollowers;
  num? get pageLIkes => _pageLIkes;
  bool? get isFollowing => _isFollowing;
  bool? get hasLikedThisPage => _hasLikedThisPage;
  bool? get isAdmin => _isAdmin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['categoryId'] = _categoryId;
    map['category'] = _category;
    map['customCategory'] = _customCategory;
    map['username'] = _username;
    map['title'] = _title;
    map['description'] = _description;
    map['websiteUrl'] = _websiteUrl;
    map['imageUrl'] = _imageUrl;
    map['lastActivityDate'] = _lastActivityDate;
    map['headerImageUrl'] = _headerImageUrl;
    map['isPublic'] = _isPublic;
    map['isDeleted'] = _isDeleted;
    map['simulated'] = _simulated;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['numberOfFollowers'] = _numberOfFollowers;
    map['pageLIkes'] = _pageLIkes;
    map['isFollowing'] = _isFollowing;
    map['hasLikedThisPage'] = _hasLikedThisPage;
    map['isAdmin'] = _isAdmin;
    return map;
  }



}

/// id : "c6812b92-b6f8-4953-a9f2-45ef15b15ec7"
/// UserId : "313"
/// avatar : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668454466812.octet-stream"
/// coverImage : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669204457976.jpeg"
/// bio : "Baddest "
/// notificationCount : 54
/// posts : 94
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
/// updatedAt : "2022-11-29T12:36:56.348Z"

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