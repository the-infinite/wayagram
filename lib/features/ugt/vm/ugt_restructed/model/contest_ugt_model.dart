class ContestUgtModel {
  String title;
  String profileId;
  String category;
  String state;
  String winnerPrize;
  String description;
  String voteCountToQualify;
  String amount;
  String durationType;
  String numberOfDuration;
  String descriptionOfAwards;
  String amountPerVote;
  String type;
  String overallResult;
  String multipleStages;
  String publicity;
  String status;
  String howItWorks;
  String numberOfWeeks;
  String currentStage;
  String participationStartDate;
  String startDate;
  String endDate;
  String entryType;
  ContestSettings? contestSettings;

  ContestUgtModel({
    required this.title,
    required this.profileId,
    required this.category,
    required this.state,
    required this.winnerPrize,
    required this.description,
    required this.voteCountToQualify,
    required this.amount,
    required this.durationType,
    required this.numberOfDuration,
    required this.descriptionOfAwards,
    required this.amountPerVote,
    required this.type,
    required this.overallResult,
    required this.multipleStages,
    required this.publicity,
    required this.status,
    required this.howItWorks,
    required this.numberOfWeeks,
    required this.currentStage,
    required this.participationStartDate,
    required this.startDate,
    required this.endDate,
    required this.entryType,
    this.contestSettings,
  });

  factory ContestUgtModel.fromJson(Map<String, dynamic> json) {
    return ContestUgtModel(
      title: json['title'] ?? '',
      profileId: json['profileId'] ?? '',
      category: json['category'] ?? '',
      state: json['state'] ?? '',
      winnerPrize: json['winnerPrize'] ?? '',
      description: json['description'] ?? '',
      voteCountToQualify: json['voteCountToQualify'] ?? '',
      amount: json['amount'] ?? '',
      durationType: json['durationType'] ?? '',
      numberOfDuration: json['numberOfDuration'] ?? '',
      descriptionOfAwards: json['descriptionOfAwards'] ?? '',
      amountPerVote: json['amountPerVote'] ?? '',
      type: json['type'] ?? '',
      overallResult: json['overallResult'] ?? '',
      multipleStages: json['multipleStages'] ?? '',
      publicity: json['publicity'] ?? '',
      status: json['status'] ?? '',
      howItWorks: json['howItWorks'] ?? '',
      numberOfWeeks: json['numberOfWeeks'] ?? '',
      currentStage: json['currentStage'] ?? '',
      participationStartDate: json['participationStartDate'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      entryType: json['entryType'] ?? '',
      contestSettings: json['contestSettings'] != null
          ? ContestSettings.fromJson(json['contestSettings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'profileId': profileId,
      'category': category,
      'state': state,
      'winnerPrize': winnerPrize,
      'description': description,
      'voteCountToQualify': voteCountToQualify,
      'amount': amount,
      'durationType': durationType,
      'numberOfDuration': numberOfDuration,
      'descriptionOfAwards': descriptionOfAwards,
      'amountPerVote': amountPerVote,
      'type': type,
      'overallResult': overallResult,
      'multipleStages': multipleStages,
      'publicity': publicity,
      'status': status,
      'howItWorks': howItWorks,
      'numberOfWeeks': numberOfWeeks,
      'currentStage': currentStage,
      'participationStartDate': participationStartDate,
      'startDate': startDate,
      'endDate': endDate,
      'entryType': entryType,
      'contestSettings': contestSettings?.toJson(),
    };
  }
}

class ContestSettings {
  List<Stage> stages;
  List<FormRequirement> formRequirements;

  ContestSettings({
    required this.stages,
    required this.formRequirements,
  });

  factory ContestSettings.fromJson(Map<String, dynamic> json) {
    return ContestSettings(
      stages: (json['stages'] as List<dynamic>?)
          ?.map((e) => Stage.fromJson(e))
          .toList() ??
          [],
      formRequirements: (json['formRequirements'] as List<dynamic>?)
          ?.map((e) => FormRequirement.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stages': stages.map((e) => e.toJson()).toList(),
      'formRequirements': formRequirements.map((e) => e.toJson()).toList(),
    };
  }
}

class Stage {
  String stageName;
  String entryType;
  int entryAmount;
  int numberOfPostPerWeek;
  int priceOfTheWinner;
  DateTime startDate;
  DateTime endDate;
  bool approveBeforeLive;

  Stage({
    required this.stageName,
    required this.entryType,
    required this.entryAmount,
    required this.numberOfPostPerWeek,
    required this.priceOfTheWinner,
    required this.startDate,
    required this.endDate,
    required this.approveBeforeLive,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageName: json['stageName'] ?? '',
      entryType: json['entryType'] ?? '',
      entryAmount: json['entryAmount'] ?? 0,
      numberOfPostPerWeek: json['numberOfPostPerWeek'] ?? 0,
      priceOfTheWinner: json['priceOfTheWinner'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      approveBeforeLive: json['approveBeforeLive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stageName': stageName,
      'entryType': entryType,
      'entryAmount': entryAmount,
      'numberOfPostPerWeek': numberOfPostPerWeek,
      'priceOfTheWinner': priceOfTheWinner,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'approveBeforeLive': approveBeforeLive,
    };
  }
}

class FormRequirement {
  String requirementType;
  String requirementName;
  String textDescription;
  bool required;

  FormRequirement({
    required this.requirementType,
    required this.requirementName,
    required this.textDescription,
    required this.required,
  });

  factory FormRequirement.fromJson(Map<String, dynamic> json) {
    return FormRequirement(
      requirementType: json['requirementType'] ?? '',
      requirementName: json['requirementName'] ?? '',
      textDescription: json['textDescription'] ?? '',
      required: json['required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requirementType': requirementType,
      'requirementName': requirementName,
      'textDescription': textDescription,
      'required': required,
    };
  }
}
