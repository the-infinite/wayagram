class ContestContestantModelMean {
  String? message;
  bool? status;
  int? statusCode;
  List<MyContestContestantModel>? data;

  ContestContestantModelMean({this.message, this.status, this.statusCode, this.data});

  ContestContestantModelMean.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <MyContestContestantModel>[];
      json['data'].forEach((v) {
        data!.add(new MyContestContestantModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyContestContestantModel {
  String? id;
  String? profileId;
  String? contestApplicationId;
  String? contestId;
  String? profilePhoto;
  String? bio;
  String? expectationFromVoters;
  String? introVideo;
  String? status;
  String? createdAt;
  String? updatedAt;
  ContestApplicant? contestApplicant;
  int? votes;

  MyContestContestantModel(
      {this.id,
      this.profileId,
      this.contestApplicationId,
      this.contestId,
      this.profilePhoto,
      this.bio,
      this.expectationFromVoters,
      this.introVideo,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.contestApplicant,
      this.votes});

  MyContestContestantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profileId'];
    contestApplicationId = json['contestApplicationId'];
    contestId = json['contestId'];
    profilePhoto = json['profilePhoto'];
    bio = json['bio'];
    expectationFromVoters = json['expectationFromVoters'];
    introVideo = json['introVideo'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    contestApplicant =
        json['contestApplicant'] != null ? new ContestApplicant.fromJson(json['contestApplicant']) : null;
    votes = json['votes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['profileId'] = profileId;
    data['contestApplicationId'] = contestApplicationId;
    data['contestId'] = contestId;
    data['profilePhoto'] = profilePhoto;
    data['bio'] = bio;
    data['expectationFromVoters'] = expectationFromVoters;
    data['introVideo'] = introVideo;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (contestApplicant != null) {
      data['contestApplicant'] = contestApplicant!.toJson();
    }
    data['votes'] = votes;
    return data;
  }
}

class ContestApplicant {
  String? id;
  String? contestId;
  String? userId;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? address;
  ApplicationData? applicationData;
  String? status;
  Null rejectionReason;
  String? createdAt;
  String? updatedAt;

  ContestApplicant({
    this.id,
    this.contestId,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.applicationData,
    this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  ContestApplicant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contestId = json['contestId'];
    userId = json['userId'];
    fullName = json['fullName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    applicationData = json['applicationData'] != null ? ApplicationData.fromJson(json['applicationData']) : null;
    status = json['status'];
    rejectionReason = json['rejectionReason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['contestId'] = contestId;
    data['userId'] = userId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    if (applicationData != null) {
      data['applicationData'] = applicationData!.toJson();
    }
    data['status'] = status;
    data['rejectionReason'] = rejectionReason;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ApplicationData {
  String? fullName;
  String? portfolio;
  String? emailAddress;

  ApplicationData({this.fullName, this.portfolio, this.emailAddress});

  ApplicationData.fromJson(Map<String, dynamic> json) {
    fullName = json['Full Name'];
    portfolio = json['Portfolio'];
    emailAddress = json['Email Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Full Name'] = fullName;
    data['Portfolio'] = portfolio;
    data['Email Address'] = emailAddress;
    return data;
  }
}
