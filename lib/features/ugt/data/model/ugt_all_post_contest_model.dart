import 'package:json_annotation/json_annotation.dart';

part 'ugt_all_post_contest_model.g.dart';

@JsonSerializable(createToJson: false)
class UgtAllPostContestModelBase {
  UgtAllPostContestModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory UgtAllPostContestModelBase.fromJson(Map<String, dynamic> json) =>
      _$UgtAllPostContestModelBaseFromJson(json);
}

@JsonSerializable(createToJson: false)
class Data {
  Data({
    required this.docs,
    required this.totalDocs,
    required this.totalPages,
    required this.currentPage,
  });

  final List<UgtAllPostContestModel>? docs;
  final int? totalDocs;
  final int? totalPages;
  final int? currentPage;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@JsonSerializable(createToJson: false)
class UgtAllPostContestModel {
  UgtAllPostContestModel({
    required this.id,
    required this.contestantProfileId,
    required this.fullName,
    required this.contestId,
    required this.mediaContent,
    required this.description,
    required this.likes,
    required this.hasLiked,
    required this.shares,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.contestantProfile,
    required this.contestApplication,
  });

  final String? id;
  final String? contestantProfileId;
  String? fullName;
  final String? contestId;
  final List<MediaContent>? mediaContent;
  final String? description;
  final int? likes;
  final int? shares;
  final bool? isDeleted;
  final bool? hasLiked;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ContestantProfile? contestantProfile;
  final ContestApplication? contestApplication;

  factory UgtAllPostContestModel.fromJson(Map<String, dynamic> json) =>
      _$UgtAllPostContestModelFromJson(json);

  UgtAllPostContestModel copyWith({
    String? id,
    String? fullName,
    String? contestantProfileId,
    String? contestId,
    List<MediaContent>? mediaContent,
    String? description,
    int? likes,
    int? shares,
    bool? isDeleted,
    bool? hasLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    ContestantProfile? contestantProfile,
    ContestApplication? contestApplication,
  }) {
    return UgtAllPostContestModel(
      id: id ?? this.id,
      contestantProfileId: contestantProfileId ?? this.contestantProfileId,
      fullName: fullName ?? this.fullName,
      contestId: contestId ?? this.contestId,
      mediaContent: mediaContent ?? this.mediaContent,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      isDeleted: isDeleted ?? this.isDeleted,
      hasLiked: hasLiked ?? this.hasLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contestantProfile: contestantProfile ?? this.contestantProfile,
      contestApplication: contestApplication ?? this.contestApplication,
    );
  }
}

@JsonSerializable(createToJson: false)
class ContestApplication {
  ContestApplication({
    required this.id,
    required this.contestId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.state,
    required this.address,
    required this.applicationData,
    required this.status,
    required this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? contestId;
  final String? userId;
  String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? state;
  final String? address;
  final ApplicationData? applicationData;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;

  factory ContestApplication.fromJson(Map<String, dynamic> json) =>
      _$ContestApplicationFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplicationData {
  ApplicationData({
    required this.phoneSpec,
  });

  @JsonKey(name: 'Phone spec')
  final String? phoneSpec;

  factory ApplicationData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class ContestantProfile {
  ContestantProfile({
    required this.id,
    required this.profilePhoto,
    required this.profileId,
    required this.contestApplicationId,
  });

  final String? id;
  final String? profilePhoto;
  final String? profileId;
  final String? contestApplicationId;

  factory ContestantProfile.fromJson(Map<String, dynamic> json) =>
      _$ContestantProfileFromJson(json);
}

@JsonSerializable(createToJson: false)
class MediaContent {
  MediaContent({
    required this.type,
    required this.url,
  });

  final String? type;
  final String? url;

  factory MediaContent.fromJson(Map<String, dynamic> json) =>
      _$MediaContentFromJson(json);
}
