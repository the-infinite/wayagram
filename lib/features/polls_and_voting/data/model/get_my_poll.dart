import 'dart:convert';
GetMyPoll getMyPollFromJson(String str) => GetMyPoll.fromJson(json.decode(str));
String getMyPollToJson(GetMyPoll data) => json.encode(data.toJson());
class GetMyPoll {
  GetMyPoll({
      this.success, 
      this.data, 
      this.meta,});

  GetMyPoll.fromJson(dynamic json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PollData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  bool? success;
  List<PollData>? data;
  Meta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    return map;
  }

}

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
String metaToJson(Meta data) => json.encode(data.toJson());
class Meta {
  Meta({
      this.timestamp,});

  Meta.fromJson(dynamic json) {
    timestamp = json['timestamp'];
  }
  String? timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    return map;
  }

}

PollData dataFromJson(String str) => PollData.fromJson(json.decode(str));
String dataToJson(PollData data) => json.encode(data.toJson());
class PollData {
  PollData({
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

  PollData.fromJson(dynamic json) {
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
    userData = json['user_data'] != null ? GetMyPollData.fromJson(json['user_data']) : null;
  }
  String? id;
  String? creatorId;
  bool? isPaid;
  bool? isSettled;
  String? question;
  String? url;
  String? startDate;
  String? endDate;
  int? maxVotesPerUser;
  String? pollType;
  String? feePerVote;
  String? createdAt;
  String? updatedAt;
  List<Choices>? choices;
  GetMyPollData? userData;

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

GetMyPollData userDataFromJson(String str) => GetMyPollData.fromJson(json.decode(str));
String userDataToJson(GetMyPollData data) => json.encode(data.toJson());
class GetMyPollData {
  GetMyPollData({
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

  GetMyPollData.fromJson(dynamic json) {
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
      });

  Choices.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    text = json['text'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    order = json['order'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? pollId;
  String? text;
  String? description;
  dynamic imageUrl;
  int? order;
  String? createdAt;
  String? updatedAt;

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
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}