class InterestsResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Map<String, Map<String, int>> data;

  InterestsResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory InterestsResponseModel.fromJson(Map<String, dynamic> json) {
    return InterestsResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map(
          (key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v)))),
    };
  }
}
