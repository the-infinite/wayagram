import 'dart:convert';
FetchAllPolls fetchAllPollsFromJson(String str) => FetchAllPolls.fromJson(json.decode(str));
String fetchAllPollsToJson(FetchAllPolls data) => json.encode(data.toJson());
class FetchAllPolls {
  FetchAllPolls({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  FetchAllPolls.fromJson(dynamic json) {
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
FetchAllPolls copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => FetchAllPolls(  message: message ?? this.message,
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
        docs?.add(Docs.fromJson(v));
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
  List<Docs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
Data copyWith({  List<Docs>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  num? nextPage,
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

Docs docsFromJson(String str) => Docs.fromJson(json.decode(str));
String docsToJson(Docs data) => json.encode(data.toJson());
class Docs {
  Docs({
      this.id, 
      this.creatorId, 
      this.isPaid, 
      this.isSettled, 
      this.question, 
      this.url, 
      this.startDate, 
      this.endDate, 
      this.maxVotesPerUser, 
      this.pollType, 
      this.feePerVote, 
      this.createdAt, 
      this.updatedAt,
      this.choices, 
      this.userData,});

  Docs.fromJson(dynamic json) {
    id = json['id'];
    creatorId = json['creatorId'];
    isPaid = json['isPaid'];
    isSettled = json['isSettled'];
    question = json['question'];
    url = json['url'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    maxVotesPerUser = json['maxVotesPerUser'];
    pollType = json['pollType'];
    feePerVote = json['feePerVote'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['choices'] != null) {
      choices = [];
      json['choices'].forEach((v) {
        choices?.add(Choices.fromJson(v));
      });
    }
    userData = json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
  }
  String? id;
  String? creatorId;
  bool? isPaid;
  bool? isSettled;
  String? question;
  String? url;
  String? startDate;
  String? endDate;
  num? maxVotesPerUser;
  String? pollType;
  String? feePerVote;
  String? createdAt;
  String? updatedAt;
  List<Choices>? choices;
  UserData? userData;
Docs copyWith({  String? id,
  String? creatorId,
  bool? isPaid,
  bool? isSettled,
  String? question,
  String? url,
  String? startDate,
  String? endDate,
  num? maxVotesPerUser,
  String? pollType,
  String? feePerVote,
  String? createdAt,
  String? updatedAt,
  List<Choices>? choices,
  UserData? userData,
}) => Docs(  id: id ?? this.id,
  creatorId: creatorId ?? this.creatorId,
  isPaid: isPaid ?? this.isPaid,
  isSettled: isSettled ?? this.isSettled,
  question: question ?? this.question,
  url: url ?? this.url,
  startDate: startDate ?? this.startDate,
  endDate: endDate ?? this.endDate,
  maxVotesPerUser: maxVotesPerUser ?? this.maxVotesPerUser,
  pollType: pollType ?? this.pollType,
  feePerVote: feePerVote ?? this.feePerVote,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  choices: choices ?? this.choices,
  userData: userData ?? this.userData,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creatorId'] = creatorId;
    map['isPaid'] = isPaid;
    map['isSettled'] = isSettled;
    map['question'] = question;
    map['url'] = url;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['maxVotesPerUser'] = maxVotesPerUser;
    map['pollType'] = pollType;
    map['feePerVote'] = feePerVote;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (choices != null) {
      map['choices'] = choices?.map((v) => v.toJson()).toList();
    }
    if (userData != null) {
      map['user_data'] = userData?.toJson();
    }
    return map;
  }

}

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));
String userDataToJson(UserData data) => json.encode(data.toJson());
class UserData {
  UserData({
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

  UserData.fromJson(dynamic json) {
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
UserData copyWith({  String? id,
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
}) => UserData(  id: id ?? this.id,
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

Choices choicesFromJson(String str) => Choices.fromJson(json.decode(str));
String choicesToJson(Choices data) => json.encode(data.toJson());
class Choices {
  Choices({
      this.id, 
      this.pollId, 
      this.text, 
      this.description, 
      this.imageUrl, 
      this.order, 
      this.createdAt, 
      this.updatedAt, 
      this.voteCount, 
      this.uniqueVoters, 
      this.votePercentage, 
      this.uniqueVotersPercentage,});

  Choices.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    text = json['text'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    order = json['order'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    voteCount = json['voteCount'];
    uniqueVoters = json['uniqueVoters'];
    votePercentage = json['votePercentage'];
    uniqueVotersPercentage = json['uniqueVotersPercentage'];
  }
  String? id;
  String? pollId;
  String? text;
  String? description;
  String? imageUrl;
  num? order;
  String? createdAt;
  String? updatedAt;
  num? voteCount;
  num? uniqueVoters;
  num? votePercentage;
  num? uniqueVotersPercentage;
Choices copyWith({  String? id,
  String? pollId,
  String? text,
  String? description,
  String? imageUrl,
  num? order,
  String? createdAt,
  String? updatedAt,
  num? voteCount,
  num? uniqueVoters,
  num? votePercentage,
  num? uniqueVotersPercentage,
}) => Choices(  id: id ?? this.id,
  pollId: pollId ?? this.pollId,
  text: text ?? this.text,
  description: description ?? this.description,
  imageUrl: imageUrl ?? this.imageUrl,
  order: order ?? this.order,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  voteCount: voteCount ?? this.voteCount,
  uniqueVoters: uniqueVoters ?? this.uniqueVoters,
  votePercentage: votePercentage ?? this.votePercentage,
  uniqueVotersPercentage: uniqueVotersPercentage ?? this.uniqueVotersPercentage,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pollId'] = pollId;
    map['text'] = text;
    map['description'] = description;
    map['imageUrl'] = imageUrl;
    map['order'] = order;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['voteCount'] = voteCount;
    map['uniqueVoters'] = uniqueVoters;
    map['votePercentage'] = votePercentage;
    map['uniqueVotersPercentage'] = uniqueVotersPercentage;
    return map;
  }

}