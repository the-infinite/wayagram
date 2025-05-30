import 'package:json_annotation/json_annotation.dart';

part 'referral_amount_model.g.dart';

@JsonSerializable()
class ReferralAmountModel {
    ReferralAmountModel({
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

    factory ReferralAmountModel.fromJson(Map<String, dynamic> json) => _$ReferralAmountModelFromJson(json);

    Map<String, dynamic> toJson() => _$ReferralAmountModelToJson(this);

}

@JsonSerializable()
class Data {
    Data({
        required this.totalAmountEarned,
    });

    final int? totalAmountEarned;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    Map<String, dynamic> toJson() => _$DataToJson(this);

}
