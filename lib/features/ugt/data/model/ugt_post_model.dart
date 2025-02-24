import 'dart:convert';

class ContestResponse {
  final String message;
  final bool status;
  final int statusCode;
  final ContestData data;

  ContestResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ContestResponse.fromJson(Map<String, dynamic> json) {
    return ContestResponse(
      message: json["message"],
      status: json["status"],
      statusCode: json["statusCode"],
      data: ContestData.fromJson(json["data"]),
    );
  }

  ContestResponse copyWith({
    String? message,
    bool? status,
    int? statusCode,
    ContestData? data,
  }) {
    return ContestResponse(
      message: message ?? this.message,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }
}

class ContestData {
  final List<Contest> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final dynamic nextPage;
  final bool hasPrevPage;
  final dynamic prevPage;
  final int pagingCounter;

  ContestData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    this.nextPage,
    required this.hasPrevPage,
    this.prevPage,
    required this.pagingCounter,
  });

  factory ContestData.fromJson(Map<String, dynamic> json) {
    return ContestData(
      docs: List<Contest>.from(json["docs"].map((x) => Contest.fromJson(x))),
      totalDocs: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      nextPage: json["nextPage"],
      hasPrevPage: json["hasPrevPage"],
      prevPage: json["prevPage"],
      pagingCounter: json["pagingCounter"],
    );
  }

  ContestData copyWith({
    List<Contest>? docs,
    int? totalDocs,
    int? limit,
    int? page,
    int? totalPages,
    bool? hasNextPage,
    dynamic nextPage,
    bool? hasPrevPage,
    dynamic prevPage,
    int? pagingCounter,
  }) {
    return ContestData(
      docs: docs ?? this.docs,
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
  }
}

// Similar copyWith methods added for Contest, ContestSettings, Stage, and FormRequirement classes...

class Contest {
  String? id;
  String? profileId;
  String? hostId;
  String? title;
  String? category;
  String? state;
  String? description;
  String? voteCountToQualify;
  String? winnerPrize;
  String? publicity;
  String? overallResult;
  String? type;
  int? amountPerVote;
  int? numberOfWeeks;
  String? uploadCoverImages;
  String? howItWorks;
  String? entryType;
  int? amount;
  String? durationType;
  String? numberOfDuration;
  String? participationStartDate;
  String? descriptionOfAwards;
  String? startDate;
  String? endDate;
  String? multipleStages;
  String? currentStage;
  String? contestStatus;
  String? rejectedReason;
  String? status;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? categoryName;
  int? likeCount;
  int? shareCount;
  int? followCount;
  int? applicantCount;
  ContestSettings? contestSettings;
  bool? isLiked;
  bool? isFollowing;
  bool? isShared;

  Contest({
    this.id,
    this.profileId,
    this.hostId,
    this.title,
    this.category,
    this.state,
    this.description,
    this.voteCountToQualify,
    this.winnerPrize,
    this.publicity,
    this.overallResult,
    this.type,
    this.amountPerVote,
    this.numberOfWeeks,
    this.uploadCoverImages,
    this.howItWorks,
    this.entryType,
    this.amount,
    this.durationType,
    this.numberOfDuration,
    this.participationStartDate,
    this.descriptionOfAwards,
    this.startDate,
    this.endDate,
    this.multipleStages,
    this.currentStage,
    this.contestStatus,
    this.rejectedReason,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categoryName,
    this.likeCount = 0,
    this.shareCount,
    this.followCount,
    this.applicantCount,
    this.contestSettings,
    this.isLiked,
    this.isFollowing,
    this.isShared,
  });

  Contest.fromJson(Map<String, dynamic> json)
      : likeCount = json['likeCount'] ?? 0 {
    id = json['id'];
    profileId = json['profileId'];
    hostId = json['hostId'];
    title = json['title'];
    isLiked = false;
    isFollowing = false;
    isShared = false;
    category = json['category'];
    state = json['state'];
    description = json['description'];
    voteCountToQualify = json['voteCountToQualify'];
    winnerPrize = json['winnerPrize'];
    publicity = json['publicity'];
    overallResult = json['overallResult'];
    type = json['type'];
    amountPerVote = json['amountPerVote'];
    numberOfWeeks = json['numberOfWeeks'];
    uploadCoverImages = json['uploadCoverImages'];
    howItWorks = json['howItWorks'];
    entryType = json['entryType'];
    amount = json['amount'];
    durationType = json['durationType'];
    numberOfDuration = json['numberOfDuration'];
    participationStartDate = json['participationStartDate'];
    descriptionOfAwards = json['descriptionOfAwards'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    multipleStages = json['multipleStages'];
    currentStage = json['currentStage'];
    contestStatus = json['contestStatus'];
    rejectedReason = json['rejectedReason'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    categoryName = json['categoryName'];
    likeCount = json['likeCount'] ?? 0;
    shareCount = json['shareCount'];
    followCount = json['followCount'];
    applicantCount = json['applicantCount'];

    contestSettings = json['contestSettings'] != null
        ? ContestSettings.fromJson(json['contestSettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profileId'] = profileId;
    data['hostId'] = hostId;
    data['title'] = title;
    data['category'] = category;
    data['state'] = state;
    data['description'] = description;
    data['voteCountToQualify'] = voteCountToQualify;
    data['winnerPrize'] = winnerPrize;
    data['publicity'] = publicity;
    data['overallResult'] = overallResult;
    data['type'] = type;
    data['amountPerVote'] = amountPerVote;
    data['numberOfWeeks'] = numberOfWeeks;
    data['uploadCoverImages'] = uploadCoverImages;
    data['howItWorks'] = howItWorks;
    data['entryType'] = entryType;
    data['amount'] = amount;
    data['durationType'] = durationType;
    data['numberOfDuration'] = numberOfDuration;
    data['participationStartDate'] = participationStartDate;
    data['descriptionOfAwards'] = descriptionOfAwards;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['multipleStages'] = multipleStages;
    data['currentStage'] = currentStage;
    data['contestStatus'] = contestStatus;
    data['rejectedReason'] = rejectedReason;
    data['status'] = status;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['categoryName'] = categoryName;
    data['likeCount'] = likeCount;
    data['shareCount'] = shareCount;
    data['followCount'] = followCount;
    data['applicantCount'] = applicantCount;
    if (contestSettings != null) {
      data['contestSettings'] = contestSettings!.toJson();
    }
    return data;
  }

  Contest copyWith({
    String? id,
    String? profileId,
    String? hostId,
    String? title,
    String? category,
    String? state,
    String? description,
    String? voteCountToQualify,
    String? winnerPrize,
    String? publicity,
    String? overallResult,
    String? type,
    int? amountPerVote,
    int? numberOfWeeks,
    String? uploadCoverImages,
    String? howItWorks,
    String? entryType,
    int? amount,
    String? durationType,
    String? numberOfDuration,
    String? participationStartDate,
    String? descriptionOfAwards,
    String? startDate,
    String? endDate,
    String? multipleStages,
    String? currentStage,
    String? contestStatus,
    String? rejectedReason,
    String? status,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? categoryName,
    int? likeCount,
    int? shareCount,
    int? followCount,
    int? applicantCount,
    ContestSettings? contestSettings,
    bool? isLiked,
    bool? isFollowing,
    bool? isShared,
  }) {
    return Contest(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      hostId: hostId ?? this.hostId,
      title: title ?? this.title,
      category: category ?? this.category,
      state: state ?? this.state,
      description: description ?? this.description,
      voteCountToQualify: voteCountToQualify ?? this.voteCountToQualify,
      winnerPrize: winnerPrize ?? this.winnerPrize,
      publicity: publicity ?? this.publicity,
      overallResult: overallResult ?? this.overallResult,
      type: type ?? this.type,
      amountPerVote: amountPerVote ?? this.amountPerVote,
      numberOfWeeks: numberOfWeeks ?? this.numberOfWeeks,
      uploadCoverImages: uploadCoverImages ?? this.uploadCoverImages,
      howItWorks: howItWorks ?? this.howItWorks,
      entryType: entryType ?? this.entryType,
      amount: amount ?? this.amount,
      durationType: durationType ?? this.durationType,
      numberOfDuration: numberOfDuration ?? this.numberOfDuration,
      participationStartDate:
          participationStartDate ?? this.participationStartDate,
      descriptionOfAwards: descriptionOfAwards ?? this.descriptionOfAwards,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      multipleStages: multipleStages ?? this.multipleStages,
      currentStage: currentStage ?? this.currentStage,
      contestStatus: contestStatus ?? this.contestStatus,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      categoryName: categoryName ?? this.categoryName,
      likeCount: likeCount ?? this.likeCount,
      shareCount: shareCount ?? this.shareCount,
      followCount: followCount ?? this.followCount,
      applicantCount: applicantCount ?? this.applicantCount,
      contestSettings: contestSettings ?? this.contestSettings,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      isShared: isShared ?? this.isShared,
    );
  }
/*   Contest copyWith({
    String? id,
    String? title,
    String? state,
    String? description,
    String? startDate,
    String? endDate,
    int? likeCount,
    bool? isLiked,
    bool? isFollowing,
  }) {
    return Contest(
      id: id ?? this.id,
      title: title ?? this.title,
      state: state ?? this.state,
      description: description ?? this.description,
      startDate: startDate ??this. startDate,
      endDate: endDate ?? this.endDate,
      likeCount: likeCount ?? this.likeCount??0,
      isLiked: isLiked ?? this.isLiked ?? false,
      isFollowing: isFollowing ?? this.isFollowing ?? false,
    );
  } */
}

class ContestSettings {
  String? id;
  List<Stages>? stages;
  List<FormRequirements>? formRequirements;
  String? contestId;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;

  ContestSettings(
      {this.id,
      this.stages,
      this.formRequirements,
      this.contestId,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ContestSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['stages'] != null) {
      stages = <Stages>[];
      json['stages'].forEach((v) {
        stages!.add(Stages.fromJson(v));
      });
    }
    if (json['formRequirements'] != null) {
      formRequirements = <FormRequirements>[];
      json['formRequirements'].forEach((v) {
        formRequirements!.add(FormRequirements.fromJson(v));
      });
    }
    contestId = json['contestId'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (stages != null) {
      data['stages'] = stages!.map((v) => v.toJson()).toList();
    }
    if (formRequirements != null) {
      data['formRequirements'] =
          formRequirements!.map((v) => v.toJson()).toList();
    }
    data['contestId'] = contestId;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class Stages {
  String? stageName;
  String? entryType;
  int? entryAmount;
  int? numberOfPostPerWeek;
  int? priceOfTheWinner;
  String? startDate;
  String? endDate;
  bool? approveBeforeLive;

  Stages(
      {this.stageName,
      this.entryType,
      this.entryAmount,
      this.numberOfPostPerWeek,
      this.priceOfTheWinner,
      this.startDate,
      this.endDate,
      this.approveBeforeLive});

  Stages.fromJson(Map<String, dynamic> json) {
    stageName = json['stageName'];
    entryType = json['entryType'];
    entryAmount = json['entryAmount'];
    numberOfPostPerWeek = json['numberOfPostPerWeek'];
    priceOfTheWinner = json['priceOfTheWinner'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    approveBeforeLive = json['approveBeforeLive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stageName'] = stageName;
    data['entryType'] = entryType;
    data['entryAmount'] = entryAmount;
    data['numberOfPostPerWeek'] = numberOfPostPerWeek;
    data['priceOfTheWinner'] = priceOfTheWinner;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['approveBeforeLive'] = approveBeforeLive;
    return data;
  }
}

class FormRequirements {
  String? requirementType;
  String? requirementName;
  String? textDescription;
  bool? required;

  FormRequirements(
      {this.requirementType,
      this.requirementName,
      this.textDescription,
      this.required});

  FormRequirements.fromJson(Map<String, dynamic> json) {
    requirementType = json['requirementType'];
    requirementName = json['requirementName'];
    textDescription = json['textDescription'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requirementType'] = requirementType;
    data['requirementName'] = requirementName;
    data['textDescription'] = textDescription;
    data['required'] = required;
    return data;
  }
}
