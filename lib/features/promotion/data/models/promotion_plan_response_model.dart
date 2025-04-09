class PromotionPlansResponse {
  final String message;
  final bool status;
  final int statusCode;
  final int responseCode;
  final PlansData data;

  PromotionPlansResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.responseCode,
    required this.data,
  });

  factory PromotionPlansResponse.fromJson(Map<String, dynamic> json) {
    return PromotionPlansResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      responseCode: json['responseCode'] ?? 0,
      data: PlansData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'responseCode': responseCode,
      'data': data.toJson(),
    };
  }
}

class PlansData {
  final List<PromotionPlan> plans;

  PlansData({required this.plans});

  factory PlansData.fromJson(Map<String, dynamic> json) {
    return PlansData(
      plans: (json['plans'] as List<dynamic>?)
              ?.map((e) => PromotionPlan.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plans': plans.map((plan) => plan.toJson()).toList(),
    };
  }
}

class PromotionPlan {
  final String id;
  final String name;
  final String description;
  final List<String> features;
  final int price;
  final int duration;

  PromotionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
    required this.price,
    required this.duration,
  });

  factory PromotionPlan.fromJson(Map<String, dynamic> json) {
    return PromotionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: json['price'] ?? 0,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'features': features,
      'price': price,
      'duration': duration,
    };
  }
}
