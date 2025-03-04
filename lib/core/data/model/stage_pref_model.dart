import 'package:json_annotation/json_annotation.dart';
part 'stage_pref_model.g.dart';

@JsonSerializable()
class StagePrefModel {
  final int? id;
  final String? stageName;
  final String? entryType;
  final String? entryAmount;
  final String? startDate;
  final String? endDate;
  final String? numPostPerWeek;
  final String? priceWinner;
  final String? voteCountToQualify;
  final bool? reviewApprovePost;

  StagePrefModel({
    this.id = 0,
    this.stageName = "",
    this.entryType = "",
    this.entryAmount = "",
    this.startDate = "",
    this.endDate = "",
    this.numPostPerWeek = "",
    this.priceWinner = "",
    this.voteCountToQualify = "",
    this.reviewApprovePost = false,
  });

  factory StagePrefModel.fromJson(Map<String, dynamic> json) =>
      _$StagePrefModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$StagePrefModelToJson(this);
  }
}
