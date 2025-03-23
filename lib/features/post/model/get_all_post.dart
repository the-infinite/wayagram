import 'dart:convert';

import 'package:wayagram/shared/features/profile/model/post.dart';

GetAllPost getAllPostFromJson(String str) => GetAllPost.fromJson(json.decode(str));
String getAllPostToJson(GetAllPost data) => json.encode(data.toJson());

class GetAllPost {
  GetAllPost({
    this.message,
    this.status,
    this.statusCode,
    this.data,
  });

  GetAllPost.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? GetAllPostData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  GetAllPostData? data;
  GetAllPost copyWith({
    String? message,
    bool? status,
    num? statusCode,
    GetAllPostData? data,
  }) =>
      GetAllPost(
        message: message ?? this.message,
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

GetAllPostData dataFromJson(String str) => GetAllPostData.fromJson(json.decode(str));
String dataToJson(GetAllPostData data) => json.encode(data.toJson());

class GetAllPostData {
  GetAllPostData({
    this.totalDocs,
    this.docs,
    this.limit,
    this.page,
    this.totalPages,
    this.hasNextPage,
    this.nextPage,
    this.hasPrevPage,
    this.prevPage,
  });

  GetAllPostData.fromJson(dynamic json) {
    totalDocs = json['totalDocs'];
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(PostModel.fromJson(v));
      });
    }
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
  }
  int? totalDocs;
  List<PostModel>? docs;
  int? limit;
  int? page;
  int? totalPages;
  bool? hasNextPage;
  int? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  GetAllPostData copyWith({
    int? totalDocs,
    List<PostModel>? docs,
    int? limit,
    int? page,
    int? totalPages,
    bool? hasNextPage,
    int? nextPage,
    bool? hasPrevPage,
    dynamic prevPage,
  }) =>
      GetAllPostData(
        totalDocs: totalDocs ?? this.totalDocs,
        docs: docs ?? this.docs,
        limit: limit ?? this.limit,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        nextPage: nextPage ?? this.nextPage,
        hasPrevPage: hasPrevPage ?? this.hasPrevPage,
        prevPage: prevPage ?? this.prevPage,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalDocs'] = totalDocs;
    if (docs != null) {
      map['docs'] = docs?.map((v) => v.toJson()).toList();
    }
    map['limit'] = limit;
    map['page'] = page;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    return map;
  }
}

GetAllPostDocs docsFromJson(String str) => GetAllPostDocs.fromJson(json.decode(str));
String docsToJson(GetAllPostDocs data) => json.encode(data.toJson());

class GetAllPostDocs {
  GetAllPostDocs({
    this.id,
    this.userId,
    this.groupId,
    this.pageId,
    this.contentType,
    this.content,
    this.media,
    this.hashtags,
    this.sourceType,
    this.linkedServiceId,
    this.privacy,
    this.url,
    this.status,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.popularityScore,
    this.isPromoted,
    this.isReposted,
    this.promotionExpiry,
    this.deletedAt,
    this.originalPostId,
    this.createdAt,
    this.updatedAt,
    this.originalPost,
    this.user,
  });

  GetAllPostDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    groupId = json['groupId'];
    pageId = json['pageId'];
    contentType = json['contentType'];
    content = json['content'];
    hashtags = json['hashtags'];
    media = json['media'];
    sourceType = json['sourceType'];
    linkedServiceId = json['linkedServiceId'];
    privacy = json['privacy'];
    url = json['url'];
    status = json['status'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    popularityScore = json['popularityScore'];
    isPromoted = json['isPromoted'];
    isReposted = json['isReposted'];
    promotionExpiry = json['promotionExpiry'];
    deletedAt = json['deletedAt'];
    originalPostId = json['originalPostId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['originalPost'] != null) {
      originalPost = [];
      json['originalPost'].forEach((v) {
        //originalPost?.add(Dynamic.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? userId;
  dynamic groupId;
  dynamic pageId;
  String? contentType;
  String? content;
  List<dynamic>? media;
  List<dynamic>? hashtags;
  String? sourceType;
  dynamic linkedServiceId;
  String? privacy;
  dynamic url;
  String? status;
  num? likeCount;
  num? commentCount;
  num? shareCount;
  num? popularityScore;
  bool? isPromoted;
  bool? isReposted;
  dynamic promotionExpiry;
  dynamic deletedAt;
  dynamic originalPostId;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? originalPost;
  User? user;

  GetAllPostDocs copyWith({
    String? id,
    String? userId,
    dynamic groupId,
    dynamic pageId,
    String? contentType,
    String? content,
    List<dynamic>? media,
    List<dynamic>? hashtags,
    String? sourceType,
    dynamic linkedServiceId,
    String? privacy,
    dynamic url,
    String? status,
    num? likeCount,
    num? commentCount,
    num? shareCount,
    num? popularityScore,
    bool? isPromoted,
    bool? isReposted,
    dynamic promotionExpiry,
    dynamic deletedAt,
    dynamic originalPostId,
    String? createdAt,
    String? updatedAt,
    List<dynamic>? originalPost,
    User? user,
  }) =>
      GetAllPostDocs(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        groupId: groupId ?? this.groupId,
        pageId: pageId ?? this.pageId,
        contentType: contentType ?? this.contentType,
        content: content ?? this.content,
        media: media ?? this.media,
        hashtags: hashtags ?? this.hashtags,
        sourceType: sourceType ?? this.sourceType,
        linkedServiceId: linkedServiceId ?? this.linkedServiceId,
        privacy: privacy ?? this.privacy,
        url: url ?? this.url,
        status: status ?? this.status,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        shareCount: shareCount ?? this.shareCount,
        popularityScore: popularityScore ?? this.popularityScore,
        isPromoted: isPromoted ?? this.isPromoted,
        isReposted: isReposted ?? this.isReposted,
        promotionExpiry: promotionExpiry ?? this.promotionExpiry,
        deletedAt: deletedAt ?? this.deletedAt,
        originalPostId: originalPostId ?? this.originalPostId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        originalPost: originalPost ?? this.originalPost,
        user: user ?? this.user,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['groupId'] = groupId;
    map['pageId'] = pageId;
    map['contentType'] = contentType;
    map['content'] = content;
    if (media != null) {
      map['media'] = media?.map((v) => v.toJson()).toList();
    }
    if (hashtags != null) {
      map['hashtags'] = hashtags?.map((v) => v.toJson()).toList();
    }
    map['sourceType'] = sourceType;
    map['linkedServiceId'] = linkedServiceId;
    map['privacy'] = privacy;
    map['url'] = url;
    map['status'] = status;
    map['likeCount'] = likeCount;
    map['commentCount'] = commentCount;
    map['shareCount'] = shareCount;
    map['popularityScore'] = popularityScore;
    map['isPromoted'] = isPromoted;
    map['isReposted'] = isReposted;
    map['promotionExpiry'] = promotionExpiry;
    map['deletedAt'] = deletedAt;
    map['originalPostId'] = originalPostId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (originalPost != null) {
      map['originalPost'] = originalPost?.map((v) => v.toJson()).toList();
    }
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
    this.role,
  });

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
  User copyWith({
    String? id,
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
  }) =>
      User(
        id: id ?? this.id,
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
    this.name,
  });

  Role.fromJson(dynamic json) {
    name = json['name'];
  }
  String? name;
  Role copyWith({
    String? name,
  }) =>
      Role(
        name: name ?? this.name,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
