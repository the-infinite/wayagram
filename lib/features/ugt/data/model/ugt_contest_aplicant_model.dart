import 'package:json_annotation/json_annotation.dart';

part 'ugt_contest_aplicant_model.g.dart';

@JsonSerializable(createToJson: false)
class ApplicantContestModelBase {
  ApplicantContestModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final List<ApplicantContestModel>? data;

  factory ApplicantContestModelBase.fromJson(Map<String, dynamic> json) =>
      _$ApplicantContestModelBaseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplicantContestModel {
  ApplicantContestModel({
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
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? state;
  final String? address;
  final Map<String, dynamic>? applicationData;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;

  factory ApplicantContestModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicantContestModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplicationData {
  ApplicationData({
    required this.ggggggg,
  });

  final String? ggggggg;

  factory ApplicationData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataFromJson(json);
}
