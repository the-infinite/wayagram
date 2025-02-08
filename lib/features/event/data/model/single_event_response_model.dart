import 'package:wayagram/features/event/data/model/event_response_model.dart';

class SingleEventResponse {
  final String message;
  final bool status;
  final int statusCode;
  final EventDoc data;

  SingleEventResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory SingleEventResponse.fromJson(Map<String, dynamic> json) {
    return SingleEventResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: EventDoc.fromJson(json['data']),
    );
  }
}
