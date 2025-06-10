import 'package:json_annotation/json_annotation.dart';

part 'referral_count_model.g.dart';

@JsonSerializable()
class ReferralCountModel {
    ReferralCountModel({
        required this.message,
        required this.status,
        required this.statusCode,
        required this.data,
        required this.responseCode,
    });

    final String? message;
    final bool? status;
    final int? statusCode;
    final Data? data;
    final int? responseCode;

    factory ReferralCountModel.fromJson(Map<String, dynamic> json) => _$ReferralCountModelFromJson(json);

    Map<String, dynamic> toJson() => _$ReferralCountModelToJson(this);

}

@JsonSerializable()
class Data {
    Data({
        required this.totalReferrals,
    });

    final int? totalReferrals;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    Map<String, dynamic> toJson() => _$DataToJson(this);

}
