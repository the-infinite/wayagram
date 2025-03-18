class SelectedInterestsResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<InterestData> data;

  SelectedInterestsResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory SelectedInterestsResponseModel.fromJson(Map<String, dynamic> json) {
    return SelectedInterestsResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List)
          .map((item) => InterestData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class InterestData {
  final String id;
  final String userId;
  final String category;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;

  InterestData({
    required this.id,
    required this.userId,
    required this.category,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InterestData.fromJson(Map<String, dynamic> json) {
    return InterestData(
      id: json['id'],
      userId: json['userId'],
      category: json['category'],
      score: json['score'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
