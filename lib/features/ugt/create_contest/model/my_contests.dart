import 'package:json_annotation/json_annotation.dart';

part 'my_contests.g.dart';

@JsonSerializable()
class MyContest {
  final bool status;
  final String message;
  final List<Data> data;
  final Metadata metadata;
  final String timestamp;
  final int statusCode;

  MyContest(
      {required this.status,
      required this.message,
      required this.data,
      required this.metadata,
      required this.timestamp,
      required this.statusCode});

  factory MyContest.fromJson(Map<String, dynamic> json) =>
      _$MyContestFromJson(json);
  Map<String, dynamic> toJson() => _$MyContestToJson(this);
}

@JsonSerializable()
class Data {
  final String id;
  final String profileId;
  final String title;
  final String category;
  final String state;
  final String winnerPrize;
  final Organiser organiser;
  final Miscellaneous miscellaneous;
  final String rankings;
  final String description;
  final String startDate;
  final String endDate;
  final String stageOneStartDate;
  final String stageOneEndDate;
  final String stageTwoStartDate;
  final String stageTwoEndDate;
  final String stageThreeStartDate;
  final String stageThreeEndDate;
  final String stageOneVoteCount;
  final String stageTwoVoteCount;
  final String stageThreeVoteCount;
  final bool stageOneEnabled;
  final bool stageTwoEnabled;
  final bool stageThreeEnabled;
  final String registrationStartDate;
  final String registrationEndDate;
  final int numberOfWeeks;
  final String voteBenchmark;
  final int maxContestants;
  final int repostCounts;
  final int likeCounts;
  final int commentCounts;
  final int followCounts;
  final int shareCounts;
  final int stages;
  final int amountPerVote;
  final String currentStage;
  final String type;
  final String overallResult;
  final String publicity;
  final String status;
  final String university;
  final String howItHow;
  final int numberOfPostsPerWeek;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  Data(
      {required this.id,
      required this.profileId,
      required this.title,
      required this.category,
      required this.state,
      required this.winnerPrize,
      required this.organiser,
      required this.miscellaneous,
      required this.rankings,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.stageOneStartDate,
      required this.stageOneEndDate,
      required this.stageTwoStartDate,
      required this.stageTwoEndDate,
      required this.stageThreeStartDate,
      required this.stageThreeEndDate,
      required this.stageOneVoteCount,
      required this.stageTwoVoteCount,
      required this.stageThreeVoteCount,
      required this.stageOneEnabled,
      required this.stageTwoEnabled,
      required this.stageThreeEnabled,
      required this.registrationStartDate,
      required this.registrationEndDate,
      required this.numberOfWeeks,
      required this.voteBenchmark,
      required this.maxContestants,
      required this.repostCounts,
      required this.likeCounts,
      required this.commentCounts,
      required this.followCounts,
      required this.shareCounts,
      required this.stages,
      required this.amountPerVote,
      required this.currentStage,
      required this.type,
      required this.overallResult,
      required this.publicity,
      required this.status,
      required this.university,
      required this.howItHow,
      required this.numberOfPostsPerWeek,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Organiser {
  final String profileId;

  Organiser({required this.profileId});

  factory Organiser.fromJson(Map<String, dynamic> json) =>
      _$OrganiserFromJson(json);
  Map<String, dynamic> toJson() => _$OrganiserToJson(this);
}

@JsonSerializable()
class Miscellaneous {
  final List<String> coverPhoto;
  final List<String> coverVideo;

  Miscellaneous({required this.coverPhoto, required this.coverVideo});

  factory Miscellaneous.fromJson(Map<String, dynamic> json) =>
      _$MiscellaneousFromJson(json);
  Map<String, dynamic> toJson() => _$MiscellaneousToJson(this);
}

@JsonSerializable()
class Metadata {
  final int total;
  final int page;
  final int limit;

  Metadata({required this.total, required this.page, required this.limit});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
