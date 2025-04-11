class PromotionTarget {
  final List<String> interests;
  final List<String> locations;
  final List<String> ageRanges;
  final String? gender;

  PromotionTarget({
    required this.interests,
    required this.locations,
    required this.ageRanges,
    this.gender,
  });

  factory PromotionTarget.fromJson(Map<String, dynamic> json) {
    return PromotionTarget(
      interests: List<String>.from(json['interests']),
      locations: List<String>.from(json['locations']),
      ageRanges: List<String>.from(json['ageRanges']),
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'interests': interests,
      'locations': locations,
      'ageRanges': ageRanges,
    };

    if (gender != null) json['gender'] = gender;

    return json;
  }
}

class CreatePromotionModel {
  final String name;
  final String userId;
  final String contentId;
  final String contentType;
  final int budget;
  final String planId;
  final String startDate;
  final String endDate;
  final PromotionTarget promotionTarget;

  CreatePromotionModel({
    required this.name,
    required this.userId,
    required this.contentId,
    required this.contentType,
    required this.budget,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.promotionTarget,
  });

  factory CreatePromotionModel.fromJson(Map<String, dynamic> json) {
    return CreatePromotionModel(
      name: json['name'],
      userId: json['userId'],
      contentId: json['contentId'],
      contentType: json['contentType'],
      budget: json['budget'],
      planId: json['planId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      promotionTarget: PromotionTarget.fromJson(json['promotionTarget']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'userId': userId,
        'contentId': contentId,
        'contentType': contentType,
        'budget': budget,
        'planId': planId,
        'startDate': startDate,
        'endDate': endDate,
        'promotionTarget': promotionTarget.toJson(),
      };
}
