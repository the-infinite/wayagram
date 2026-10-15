import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/event/data/model/payout/payout_data.dart';

part 'payout_response_model.g.dart';

@JsonSerializable()
class PayoutResponse {
  final String message;
  final bool status;
  final int statusCode;
  final PayoutData data;

  PayoutResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory PayoutResponse.fromJson(Map<String, dynamic> json) =>
      _$PayoutResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PayoutResponseToJson(this);
}
