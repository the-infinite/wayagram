import 'dart:convert';
/// id : "389ec23e-a19d-449e-8dab-36f153e9ff0e"
/// ProfileId : "0df63179-53de-45cb-96d7-45a827ac9947"
/// DonationId : "4471087b-2328-457f-bafa-151989595898"
/// millisecCreatedAt : "1669972421000"
/// millisecUpdatedAt : "1669890578554"
/// amount : 200
/// currentAmount : 0
/// previousAmount : 0
/// _v : "RGBA"
/// paymentRef : "WDDLA683954258"
/// createdAt : "2022-12-02T09:10:38.825Z"
/// updatedAt : "2022-12-02T09:10:38.825Z"
/// DonatorProfile : {"id":"0df63179-53de-45cb-96d7-45a827ac9947","UserId":"440","avatar":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1658744739983.jpeg","coverImage":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1658744740400.jpeg","bio":"Android engineer || DevOps engineer || Flutter Developer ","notificationCount":4,"posts":57,"groupCount":1,"pageCount":1,"followings":150,"followers":13,"username":"Oluwaphemmy","displayName":"Folarin Isaac ","notPublic":false,"deleted":false,"simulatedUser":false,"isMuted":false,"isBan":false,"isDisabled":false,"isDeactivate":false,"theme":"light","fontSize":"12px","phone":"2348115049208","email":"oluwaphemmyisaac@gmail.com","style":"italic","stream_key":"LW6FmW6jv","_v":"RGBA","createdAt":"2022-05-15T10:25:57.198Z","updatedAt":"2022-12-06T21:18:28.976Z","connection":{}}

PeopleWhoDonated peopleWhoDonatedFromJson(String str) => PeopleWhoDonated.fromJson(json.decode(str));
String peopleWhoDonatedToJson(PeopleWhoDonated data) => json.encode(data.toJson());
class PeopleWhoDonated {
  PeopleWhoDonated({
      String? id, 
      String? profileId, 
      String? donationId, 
      String? millisecCreatedAt, 
      String? millisecUpdatedAt, 
      num? amount, 
      num? currentAmount, 
      num? previousAmount, 
      String? v, 
      String? paymentRef, 
      String? createdAt, 
      String? updatedAt, 
      DonatorProfile? donatorProfile,}){
    _id = id;
    _profileId = profileId;
    _donationId = donationId;
    _millisecCreatedAt = millisecCreatedAt;
    _millisecUpdatedAt = millisecUpdatedAt;
    _amount = amount;
    _currentAmount = currentAmount;
    _previousAmount = previousAmount;
    _v = v;
    _paymentRef = paymentRef;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _donatorProfile = donatorProfile;
}

  PeopleWhoDonated.fromJson(dynamic json) {
    _id = json['id'];
    _profileId = json['ProfileId'];
    _donationId = json['DonationId'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _millisecUpdatedAt = json['millisecUpdatedAt'];
    _amount = json['amount'];
    _currentAmount = json['currentAmount'];
    _previousAmount = json['previousAmount'];
    _v = json['_v'];
    _paymentRef = json['paymentRef'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _donatorProfile = json['DonatorProfile'] != null ? DonatorProfile.fromJson(json['DonatorProfile']) : null;
  }
  String? _id;
  String? _profileId;
  String? _donationId;
  String? _millisecCreatedAt;
  String? _millisecUpdatedAt;
  num? _amount;
  num? _currentAmount;
  num? _previousAmount;
  String? _v;
  String? _paymentRef;
  String? _createdAt;
  String? _updatedAt;
  DonatorProfile? _donatorProfile;
PeopleWhoDonated copyWith({  String? id,
  String? profileId,
  String? donationId,
  String? millisecCreatedAt,
  String? millisecUpdatedAt,
  num? amount,
  num? currentAmount,
  num? previousAmount,
  String? v,
  String? paymentRef,
  String? createdAt,
  String? updatedAt,
  DonatorProfile? donatorProfile,
}) => PeopleWhoDonated(  id: id ?? _id,
  profileId: profileId ?? _profileId,
  donationId: donationId ?? _donationId,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  millisecUpdatedAt: millisecUpdatedAt ?? _millisecUpdatedAt,
  amount: amount ?? _amount,
  currentAmount: currentAmount ?? _currentAmount,
  previousAmount: previousAmount ?? _previousAmount,
  v: v ?? _v,
  paymentRef: paymentRef ?? _paymentRef,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  donatorProfile: donatorProfile ?? _donatorProfile,
);
  String? get id => _id;
  String? get profileId => _profileId;
  String? get donationId => _donationId;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get millisecUpdatedAt => _millisecUpdatedAt;
  num? get amount => _amount;
  num? get currentAmount => _currentAmount;
  num? get previousAmount => _previousAmount;
  String? get v => _v;
  String? get paymentRef => _paymentRef;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  DonatorProfile? get donatorProfile => _donatorProfile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProfileId'] = _profileId;
    map['DonationId'] = _donationId;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['millisecUpdatedAt'] = _millisecUpdatedAt;
    map['amount'] = _amount;
    map['currentAmount'] = _currentAmount;
    map['previousAmount'] = _previousAmount;
    map['_v'] = _v;
    map['paymentRef'] = _paymentRef;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_donatorProfile != null) {
      map['DonatorProfile'] = _donatorProfile?.toJson();
    }
    return map;
  }

  static List<PeopleWhoDonated> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => PeopleWhoDonated.fromJson(item)).toList();
  }
}

/// id : "0df63179-53de-45cb-96d7-45a827ac9947"
/// UserId : "440"
/// avatar : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1658744739983.jpeg"
/// coverImage : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1658744740400.jpeg"
/// bio : "Android engineer || DevOps engineer || Flutter Developer "
/// notificationCount : 4
/// posts : 57
/// groupCount : 1
/// pageCount : 1
/// followings : 150
/// followers : 13
/// username : "Oluwaphemmy"
/// displayName : "Folarin Isaac "
/// notPublic : false
/// deleted : false
/// simulatedUser : false
/// isMuted : false
/// isBan : false
/// isDisabled : false
/// isDeactivate : false
/// theme : "light"
/// fontSize : "12px"
/// phone : "2348115049208"
/// email : "oluwaphemmyisaac@gmail.com"
/// style : "italic"
/// stream_key : "LW6FmW6jv"
/// _v : "RGBA"
/// createdAt : "2022-05-15T10:25:57.198Z"
/// updatedAt : "2022-12-06T21:18:28.976Z"
/// connection : {}

DonatorProfile donatorProfileFromJson(String str) => DonatorProfile.fromJson(json.decode(str));
String donatorProfileToJson(DonatorProfile data) => json.encode(data.toJson());
class DonatorProfile {
  DonatorProfile({
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

  DonatorProfile.fromJson(dynamic json) {
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
DonatorProfile copyWith({  String? id,
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
}) => DonatorProfile(  id: id ?? _id,
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