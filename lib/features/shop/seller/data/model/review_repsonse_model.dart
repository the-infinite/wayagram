class ReviewRepsonseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<ReviewData> data;

  ReviewRepsonseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ReviewRepsonseModel.fromJson(Map<String, dynamic> json) {
    return ReviewRepsonseModel(
      message: json['message'] as String,
      status: json['status'] as bool,
      statusCode: json['statusCode'] as int,
      data: (json['data'] as List)
          .map((item) => ReviewData.fromJson(item))
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

class ReviewData {
  final String id;
  final String raterId;
  final String? productId;
  final String? shopId;
  final int score;
  final String review;
  final String type;
  final int likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String raterFirstName;
  final String raterLastName;
  final String? raterProfilePhoto;

  ReviewData({
    required this.id,
    required this.raterId,
    this.productId,
    this.shopId,
    required this.score,
    required this.review,
    required this.type,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.raterFirstName,
    required this.raterLastName,
    this.raterProfilePhoto
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'] as String,
      raterId: json['raterId'] as String,
      productId: json['productId'] as String?,
      shopId: json['shopId'] as String?,
      score: json['score'] as int,
      review: json['review'] as String,
      type: json['type'] as String,
      likes: json['likes'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      raterFirstName: json['raterFirstName'] as String,
      raterLastName: json['raterLastName'] as String,
      raterProfilePhoto: json['raterProfilePhoto']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'raterId': raterId,
      'productId': productId,
      'shopId': shopId,
      'score': score,
      'review': review,
      'type': type,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'raterFirstName': raterFirstName,
      'raterLastName': raterLastName,
      'raterProfilePhoto': raterProfilePhoto
    };
  }
}
