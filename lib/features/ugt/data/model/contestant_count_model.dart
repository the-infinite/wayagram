import 'package:json_annotation/json_annotation.dart';

part 'contestant_count_model.g.dart';

@JsonSerializable()
class ContestantCountModel {
    ContestantCountModel({
        required this.message,
        required this.status,
        required this.statusCode,
        required this.data,
    });

    final String? message;
    final bool? status;
    final int? statusCode;
    final Data? data;

    factory ContestantCountModel.fromJson(Map<String, dynamic> json) => _$ContestantCountModelFromJson(json);

    Map<String, dynamic> toJson() => _$ContestantCountModelToJson(this);

}

@JsonSerializable()
class Data {
    Data({
        required this.totalContestants,
    });

    final int? totalContestants;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    Map<String, dynamic> toJson() => _$DataToJson(this);

}
