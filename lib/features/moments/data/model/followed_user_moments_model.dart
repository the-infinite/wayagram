import 'package:wayagram/features/moments/data/model/moment_response_model.dart';

class FollowedUserMomentsModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<UserMoments> data;
  final int responseCode;

  FollowedUserMomentsModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
    required this.responseCode,
  });

  factory FollowedUserMomentsModel.fromJson(Map<String, dynamic> json) {
    return FollowedUserMomentsModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List).map((e) => UserMoments.fromJson(e)).toList(),
      responseCode: json['responseCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
      'responseCode': responseCode,
    };
  }
}

class UserMoments {
  final String userId;
  final List<MomentData> moments;

  UserMoments({
    required this.userId,
    required this.moments,
  });

  factory UserMoments.fromJson(Map<String, dynamic> json) {
    return UserMoments(
      userId: json['userId'],
      moments: (json['moments'] as List).reversed.map((e) => MomentData.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'moments': moments.map((e) => e.toJson()).toList(),
    };
  }
}
