import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'create_poll_model.g.dart';

@JsonSerializable()
class CreatePollModel {
  String? description;
  String? type;
  String? voteLimit;
  String? pollCategory;
  String? startDate;
  String? endDate;
  int? startTime;
  int? endTime;
  bool? showResult;
  bool? schedule;
  bool? isPaid;
  String? amount;

  CreatePollModel ({
    required this.description,
    required this.type,
    required  this.voteLimit,
    required  this.pollCategory,
    required  this.startDate,
    required  this.endDate,
    required  this.startTime,
    required  this.endTime,
    required  this.showResult,
    required  this.schedule,
    required  this.isPaid,
    required  this.amount,});

  factory CreatePollModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePollModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$CreatePollModelToJson(this);
  }
}