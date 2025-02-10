import 'dart:convert';
FetchComment fetchCommentFromJson(String str) => FetchComment.fromJson(json.decode(str));
String fetchCommentToJson(FetchComment data) => json.encode(data.toJson());
class FetchComment {
  FetchComment({
      this.message, 
      this.status,
      this.statusCode, 
      this.data,});

  FetchComment.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? FetchCommentData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  FetchCommentData? data;
FetchComment copyWith({  String? message,
  bool? status,
  num? statusCode,
  FetchCommentData? data,
}) => FetchComment(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

FetchCommentData dataFromJson(String str) => FetchCommentData.fromJson(json.decode(str));
String dataToJson(FetchCommentData data) => json.encode(data.toJson());
class FetchCommentData {
  FetchCommentData({
      this.total, 
      this.comments, 
      this.page, 
      this.limit, 
      this.totalPages, 
      this.hasNextPage, 
      this.nextPage, 
      this.hasPrevPage, 
      this.prevPage,});

  FetchCommentData.fromJson(dynamic json) {
    total = json['total'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
  }
  num? total;
  List<Comments>? comments;
  num? page;
  num? limit;
  num? totalPages;
  bool? hasNextPage;
  dynamic nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  FetchCommentData copyWith({  num? total,
  List<Comments>? comments,
  num? page,
  num? limit,
  num? totalPages,
  bool? hasNextPage,
  dynamic nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
}) => FetchCommentData(  total: total ?? this.total,
  comments: comments ?? this.comments,
  page: page ?? this.page,
  limit: limit ?? this.limit,
  totalPages: totalPages ?? this.totalPages,
  hasNextPage: hasNextPage ?? this.hasNextPage,
  nextPage: nextPage ?? this.nextPage,
  hasPrevPage: hasPrevPage ?? this.hasPrevPage,
  prevPage: prevPage ?? this.prevPage,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    return map;
  }

}

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));
String commentsToJson(Comments data) => json.encode(data.toJson());
class Comments {
  Comments({
      this.id, 
      this.postId, 
      this.userId, 
      this.content, 
      this.parentCommentId, 
      this.likeCount, 
      this.commentCount, 
      this.shareCount, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,
      this.user,});

  Comments.fromJson(dynamic json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    content = json['content'];
    parentCommentId = json['parentCommentId'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? postId;
  String? userId;
  String? content;
  dynamic parentCommentId;
  num? likeCount;
  num? commentCount;
  num? shareCount;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  User? user;
Comments copyWith({  String? id,
  String? postId,
  String? userId,
  String? content,
  dynamic parentCommentId,
  num? likeCount,
  num? commentCount,
  num? shareCount,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
  User? user,
}) => Comments(  id: id ?? this.id,
  postId: postId ?? this.postId,
  userId: userId ?? this.userId,
  content: content ?? this.content,
  parentCommentId: parentCommentId ?? this.parentCommentId,
  likeCount: likeCount ?? this.likeCount,
  commentCount: commentCount ?? this.commentCount,
  shareCount: shareCount ?? this.shareCount,
  deletedAt: deletedAt ?? this.deletedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  user: user ?? this.user,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['postId'] = postId;
    map['userId'] = userId;
    map['content'] = content;
    map['parentCommentId'] = parentCommentId;
    map['likeCount'] = likeCount;
    map['commentCount'] = commentCount;
    map['shareCount'] = shareCount;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
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
      this.updatedAt, 
      this.role,});

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
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
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
  Role? role;
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
  Role? role,
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
  role: role ?? this.role,
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
    if (role != null) {
      map['role'] = role?.toJson();
    }
    return map;
  }

}

Role roleFromJson(String str) => Role.fromJson(json.decode(str));
String roleToJson(Role data) => json.encode(data.toJson());
class Role {
  Role({
      this.name,});

  Role.fromJson(dynamic json) {
    name = json['name'];
  }
  String? name;
Role copyWith({  String? name,
}) => Role(  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }

}