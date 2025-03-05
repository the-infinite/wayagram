import 'dart:convert';
LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
class LoginResponse {
  LoginResponse({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  LoginResponse.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
  num? responseCode;
LoginResponse copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => LoginResponse(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
  responseCode: responseCode ?? this.responseCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['responseCode'] = responseCode;
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.userdata, 
      this.token,});

  Data.fromJson(dynamic json) {
    userdata = json['userdata'] != null ? Userdata.fromJson(json['userdata']) : null;
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
  }
  Userdata? userdata;
  Token? token;
Data copyWith({  Userdata? userdata,
  Token? token,
}) => Data(  userdata: userdata ?? this.userdata,
  token: token ?? this.token,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userdata != null) {
      map['userdata'] = userdata?.toJson();
    }
    if (token != null) {
      map['token'] = token?.toJson();
    }
    return map;
  }

}

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));
String tokenToJson(Token data) => json.encode(data.toJson());
class Token {
  Token({
      this.token, 
      this.refreshToken,});

  Token.fromJson(dynamic json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
  }
  String? token;
  String? refreshToken;
Token copyWith({  String? token,
  String? refreshToken,
}) => Token(  token: token ?? this.token,
  refreshToken: refreshToken ?? this.refreshToken,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['refreshToken'] = refreshToken;
    return map;
  }

}

Userdata userdataFromJson(String str) => Userdata.fromJson(json.decode(str));
String userdataToJson(Userdata data) => json.encode(data.toJson());
class Userdata {
  Userdata({
      this.user, 
      this.profile, 
      this.business,});

  Userdata.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    business = json['business'];
  }
  User? user;
  Profile? profile;
  dynamic business;
Userdata copyWith({  User? user,
  Profile? profile,
  dynamic business,
}) => Userdata(  user: user ?? this.user,
  profile: profile ?? this.profile,
  business: business ?? this.business,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (profile != null) {
      map['profile'] = profile?.toJson();
    }
    map['business'] = business;
    return map;
  }

}

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));
String profileToJson(Profile data) => json.encode(data.toJson());
class Profile {
  Profile({
      this.id, 
      this.userId, 
      this.avatar, 
      this.coverImage, 
      this.bio, 
      this.username, 
      this.displayName, 
      this.isPublic, 
      this.isBanned, 
      this.deletedAt, 
      this.simulatedUser, 
      this.isMuted, 
      this.referenceCode, 
      this.referredBy, 
      this.streamKey, 
      this.hasFollowedAll, 
      this.theme, 
      this.fontSize, 
      this.style, 
      this.v, 
      this.createdAt, 
      this.updatedAt,});

  Profile.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    avatar = json['avatar'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    username = json['username'];
    displayName = json['displayName'];
    isPublic = json['isPublic'];
    isBanned = json['isBanned'];
    deletedAt = json['deletedAt'];
    simulatedUser = json['simulatedUser'];
    isMuted = json['isMuted'];
    referenceCode = json['referenceCode'];
    referredBy = json['referredBy'];
    streamKey = json['streamKey'];
    hasFollowedAll = json['hasFollowedAll'];
    theme = json['theme'];
    fontSize = json['fontSize'];
    style = json['style'];
    v = json['_v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? avatar;
  dynamic coverImage;
  dynamic bio;
  String? username;
  String? displayName;
  bool? isPublic;
  bool? isBanned;
  dynamic deletedAt;
  bool? simulatedUser;
  bool? isMuted;
  String? referenceCode;
  dynamic referredBy;
  String? streamKey;
  bool? hasFollowedAll;
  String? theme;
  String? fontSize;
  dynamic style;
  String? v;
  String? createdAt;
  String? updatedAt;
Profile copyWith({  String? id,
  String? userId,
  String? avatar,
  dynamic coverImage,
  dynamic bio,
  String? username,
  String? displayName,
  bool? isPublic,
  bool? isBanned,
  dynamic deletedAt,
  bool? simulatedUser,
  bool? isMuted,
  String? referenceCode,
  dynamic referredBy,
  String? streamKey,
  bool? hasFollowedAll,
  String? theme,
  String? fontSize,
  dynamic style,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => Profile(  id: id ?? this.id,
  userId: userId ?? this.userId,
  avatar: avatar ?? this.avatar,
  coverImage: coverImage ?? this.coverImage,
  bio: bio ?? this.bio,
  username: username ?? this.username,
  displayName: displayName ?? this.displayName,
  isPublic: isPublic ?? this.isPublic,
  isBanned: isBanned ?? this.isBanned,
  deletedAt: deletedAt ?? this.deletedAt,
  simulatedUser: simulatedUser ?? this.simulatedUser,
  isMuted: isMuted ?? this.isMuted,
  referenceCode: referenceCode ?? this.referenceCode,
  referredBy: referredBy ?? this.referredBy,
  streamKey: streamKey ?? this.streamKey,
  hasFollowedAll: hasFollowedAll ?? this.hasFollowedAll,
  theme: theme ?? this.theme,
  fontSize: fontSize ?? this.fontSize,
  style: style ?? this.style,
  v: v ?? this.v,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['avatar'] = avatar;
    map['coverImage'] = coverImage;
    map['bio'] = bio;
    map['username'] = username;
    map['displayName'] = displayName;
    map['isPublic'] = isPublic;
    map['isBanned'] = isBanned;
    map['deletedAt'] = deletedAt;
    map['simulatedUser'] = simulatedUser;
    map['isMuted'] = isMuted;
    map['referenceCode'] = referenceCode;
    map['referredBy'] = referredBy;
    map['streamKey'] = streamKey;
    map['hasFollowedAll'] = hasFollowedAll;
    map['theme'] = theme;
    map['fontSize'] = fontSize;
    map['style'] = style;
    map['_v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.id, 
      this.phoneNumber, 
      this.email, 
      this.passwordHash, 
      this.firstName, 
      this.lastName, 
      this.gender, 
      this.address, 
      this.city, 
      this.lga, 
      this.state, 
      this.country, 
      this.countryCode, 
      this.postalCode, 
      this.middleName, 
      this.dateOfBirth, 
      this.twoFactorEnabled, 
      this.profilePicture, 
      this.fcmToken, 
      this.emailVerified, 
      this.phoneVerified, 
      this.accountStatus, 
      this.tcAgreement, 
      this.policyAgreement, 
      this.emailVerifiedDate, 
      this.deletedAt, 
      this.roleId, 
      this.accountTypeId, 
      this.v, 
      this.createdAt, 
      this.updatedAt,});

  User.fromJson(dynamic json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    passwordHash = json['passwordHash'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    address = json['address'];
    city = json['city'];
    lga = json['lga'];
    state = json['state'];
    country = json['country'];
    countryCode = json['countryCode'];
    postalCode = json['postalCode'];
    middleName = json['middleName'];
    dateOfBirth = json['dateOfBirth'];
    twoFactorEnabled = json['twoFactorEnabled'];
    profilePicture = json['profilePicture'];
    fcmToken = json['fcmToken'];
    emailVerified = json['emailVerified'];
    phoneVerified = json['phoneVerified'];
    accountStatus = json['accountStatus'];
    tcAgreement = json['tcAgreement'];
    policyAgreement = json['policyAgreement'];
    emailVerifiedDate = json['emailVerifiedDate'];
    deletedAt = json['deletedAt'];
    roleId = json['roleId'];
    accountTypeId = json['accountTypeId'];
    v = json['_v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? phoneNumber;
  String? email;
  String? passwordHash;
  String? firstName;
  String? lastName;
  String? gender;
  String? address;
  String? city;
  dynamic lga;
  String? state;
  String? country;
  dynamic countryCode;
  dynamic postalCode;
  dynamic middleName;
  String? dateOfBirth;
  bool? twoFactorEnabled;
  String? profilePicture;
  dynamic fcmToken;
  bool? emailVerified;
  bool? phoneVerified;
  String? accountStatus;
  bool? tcAgreement;
  bool? policyAgreement;
  String? emailVerifiedDate;
  dynamic deletedAt;
  String? roleId;
  String? accountTypeId;
  String? v;
  String? createdAt;
  String? updatedAt;
User copyWith({  String? id,
  String? phoneNumber,
  String? email,
  String? passwordHash,
  String? firstName,
  String? lastName,
  String? gender,
  String? address,
  String? city,
  dynamic lga,
  String? state,
  String? country,
  dynamic countryCode,
  dynamic postalCode,
  dynamic middleName,
  String? dateOfBirth,
  bool? twoFactorEnabled,
  String? profilePicture,
  dynamic fcmToken,
  bool? emailVerified,
  bool? phoneVerified,
  String? accountStatus,
  bool? tcAgreement,
  bool? policyAgreement,
  String? emailVerifiedDate,
  dynamic deletedAt,
  String? roleId,
  String? accountTypeId,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => User(  id: id ?? this.id,
  phoneNumber: phoneNumber ?? this.phoneNumber,
  email: email ?? this.email,
  passwordHash: passwordHash ?? this.passwordHash,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  gender: gender ?? this.gender,
  address: address ?? this.address,
  city: city ?? this.city,
  lga: lga ?? this.lga,
  state: state ?? this.state,
  country: country ?? this.country,
  countryCode: countryCode ?? this.countryCode,
  postalCode: postalCode ?? this.postalCode,
  middleName: middleName ?? this.middleName,
  dateOfBirth: dateOfBirth ?? this.dateOfBirth,
  twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
  profilePicture: profilePicture ?? this.profilePicture,
  fcmToken: fcmToken ?? this.fcmToken,
  emailVerified: emailVerified ?? this.emailVerified,
  phoneVerified: phoneVerified ?? this.phoneVerified,
  accountStatus: accountStatus ?? this.accountStatus,
  tcAgreement: tcAgreement ?? this.tcAgreement,
  policyAgreement: policyAgreement ?? this.policyAgreement,
  emailVerifiedDate: emailVerifiedDate ?? this.emailVerifiedDate,
  deletedAt: deletedAt ?? this.deletedAt,
  roleId: roleId ?? this.roleId,
  accountTypeId: accountTypeId ?? this.accountTypeId,
  v: v ?? this.v,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['email'] = email;
    map['passwordHash'] = passwordHash;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['address'] = address;
    map['city'] = city;
    map['lga'] = lga;
    map['state'] = state;
    map['country'] = country;
    map['countryCode'] = countryCode;
    map['postalCode'] = postalCode;
    map['middleName'] = middleName;
    map['dateOfBirth'] = dateOfBirth;
    map['twoFactorEnabled'] = twoFactorEnabled;
    map['profilePicture'] = profilePicture;
    map['fcmToken'] = fcmToken;
    map['emailVerified'] = emailVerified;
    map['phoneVerified'] = phoneVerified;
    map['accountStatus'] = accountStatus;
    map['tcAgreement'] = tcAgreement;
    map['policyAgreement'] = policyAgreement;
    map['emailVerifiedDate'] = emailVerifiedDate;
    map['deletedAt'] = deletedAt;
    map['roleId'] = roleId;
    map['accountTypeId'] = accountTypeId;
    map['_v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}