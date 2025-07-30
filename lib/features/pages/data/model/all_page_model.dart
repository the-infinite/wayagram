import 'dart:convert';
AllPageModel allPageModelFromJson(String str) => AllPageModel.fromJson(json.decode(str));
String allPageModelToJson(AllPageModel data) => json.encode(data.toJson());
class AllPageModel {
  AllPageModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  AllPageModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
AllPageModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
}) => AllPageModel(  message: message ?? this.message,
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.docs, 
      this.totalDocs, 
      this.limit, 
      this.page, 
      this.totalPages, 
      this.hasNextPage, 
      this.nextPage, 
      this.hasPrevPage, 
      this.prevPage, 
      this.pagingCounter,});

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(AllPageModel.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
    pagingCounter = json['pagingCounter'];
  }
  List<AllPageModel>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  dynamic nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
Data copyWith({  List<AllPageModel>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  dynamic nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
  num? pagingCounter,
}) => Data(  docs: docs ?? this.docs,
  totalDocs: totalDocs ?? this.totalDocs,
  limit: limit ?? this.limit,
  page: page ?? this.page,
  totalPages: totalPages ?? this.totalPages,
  hasNextPage: hasNextPage ?? this.hasNextPage,
  nextPage: nextPage ?? this.nextPage,
  hasPrevPage: hasPrevPage ?? this.hasPrevPage,
  prevPage: prevPage ?? this.prevPage,
  pagingCounter: pagingCounter ?? this.pagingCounter,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (docs != null) {
      map['docs'] = docs?.map((v) => v.toJson()).toList();
    }
    map['totalDocs'] = totalDocs;
    map['limit'] = limit;
    map['page'] = page;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    map['pagingCounter'] = pagingCounter;
    return map;
  }

}

AllPageModelDocs docsFromJson(String str) => AllPageModelDocs.fromJson(json.decode(str));
String docsToJson(AllPageModelDocs data) => json.encode(data.toJson());
class AllPageModelDocs {
  AllPageModelDocs({
      this.id, 
      this.followerCount, 
      this.ownerId, 
      this.name, 
      this.description, 
      this.isPublic, 
      this.coverImage, 
      this.categories, 
      this.url, 
      this.profileImage, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,
      this.owner,});

  AllPageModelDocs.fromJson(dynamic json) {
    id = json['id'];
    followerCount = json['followerCount'];
    ownerId = json['ownerId'];
    name = json['name'];
    description = json['description'];
    isPublic = json['isPublic'];
    coverImage = json['coverImage'];
    categories = json['categories'];
    url = json['url'];
    profileImage = json['profileImage'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }
  String? id;
  num? followerCount;
  String? ownerId;
  String? name;
  String? description;
  bool? isPublic;
  String? coverImage;
  dynamic categories;
  dynamic url;
  String? profileImage;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  Owner? owner;
  AllPageModelDocs copyWith({  String? id,
  num? followerCount,
  String? ownerId,
  String? name,
  String? description,
  bool? isPublic,
  String? coverImage,
  dynamic categories,
  dynamic url,
  String? profileImage,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
  Owner? owner,
}) => AllPageModelDocs(  id: id ?? this.id,
  followerCount: followerCount ?? this.followerCount,
  ownerId: ownerId ?? this.ownerId,
  name: name ?? this.name,
  description: description ?? this.description,
  isPublic: isPublic ?? this.isPublic,
  coverImage: coverImage ?? this.coverImage,
  categories: categories ?? this.categories,
  url: url ?? this.url,
  profileImage: profileImage ?? this.profileImage,
  deletedAt: deletedAt ?? this.deletedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  owner: owner ?? this.owner,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['followerCount'] = followerCount;
    map['ownerId'] = ownerId;
    map['name'] = name;
    map['description'] = description;
    map['isPublic'] = isPublic;
    map['coverImage'] = coverImage;
    map['categories'] = categories;
    map['url'] = url;
    map['profileImage'] = profileImage;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (owner != null) {
      map['owner'] = owner?.toJson();
    }
    return map;
  }

}

Owner ownerFromJson(String str) => Owner.fromJson(json.decode(str));
String ownerToJson(Owner data) => json.encode(data.toJson());
class Owner {
  Owner({
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

  Owner.fromJson(dynamic json) {
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
Owner copyWith({  String? id,
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
}) => Owner(  id: id ?? this.id,
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