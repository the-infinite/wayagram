import 'package:json_annotation/json_annotation.dart';

part 'event_setting_response.g.dart';

@JsonSerializable()
class EventSettingResponse {
  EventSettingResponse({
    required this.letEveryoneJoin,
    required this.approveJoinRequest,
  });

  final bool? letEveryoneJoin;
  final bool? approveJoinRequest;

  factory EventSettingResponse.fromJson(Map<String, dynamic> json) =>
      _$EventSettingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventSettingResponseToJson(this);
}
