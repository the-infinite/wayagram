// Manually Serialized Response Model for Flutter

import 'package:wayagram/features/auth/interests/data/model/interests_response_model.dart';

class SelectedInterestsResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<UserInterest> data;

  SelectedInterestsResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory SelectedInterestsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SelectedInterestsResponseModel(
        message: json['message'],
        status: json['status'],
        statusCode: json['statusCode'],
        data: (json['data'] as List)
            .map((item) => UserInterest.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'statusCode': statusCode,
        'data': data.map((item) => item.toJson()).toList(),
      };
}



// Model for the User Interest Data Item
class UserInterest {
  final String id;
  final String userId;
  final String interestId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final InterestCategory interest;

  UserInterest({
    required this.id,
    required this.userId,
    required this.interestId,
    required this.createdAt,
    required this.updatedAt,
    required this.interest,
  });

  factory UserInterest.fromJson(Map<String, dynamic> json) => UserInterest(
        id: json['id'],
        userId: json['userId'],
        interestId: json['interestId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        interest: InterestCategory.fromJson(json['interest']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'interestId': interestId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'interest': interest.toJson(),
      };
}
