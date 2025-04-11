class PromotionPlanResponse {
  final String message;
  final bool status;
  final int statusCode;
  final int responseCode;
  final PromotionPlanData data;

  PromotionPlanResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.responseCode,
    required this.data,
  });

  factory PromotionPlanResponse.fromJson(Map<String, dynamic> json) {
    return PromotionPlanResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      responseCode: json['responseCode'],
      data: PromotionPlanData.fromJson(json['data']),
    );
  }
}

class PromotionPlanData {
  final List<PromotionPlanDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;
  final PromotionMetadata metadata;

  PromotionPlanData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    this.nextPage,
    required this.hasPrevPage,
    this.prevPage,
    required this.pagingCounter,
    required this.metadata,
  });

  factory PromotionPlanData.fromJson(Map<String, dynamic> json) {
    return PromotionPlanData(
      docs: List<PromotionPlanDoc>.from(
          json['docs'].map((doc) => PromotionPlanDoc.fromJson(doc))),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      page: json['page'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'],
      prevPage: json['prevPage'],
      pagingCounter: json['pagingCounter'],
      metadata: PromotionMetadata.fromJson(json['metadata']),
    );
  }
}

class PromotionPlanDoc {
  final String id;
  final String basePrice;
  final String description;
  final int? durationDays;
  final String name;
  final String serviceType;
  final bool isActive;
  final dynamic features;
  final dynamic targetingOptions;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromotionPlanDoc({
    required this.id,
    required this.basePrice,
    required this.description,
    this.durationDays,
    required this.name,
    required this.serviceType,
    required this.isActive,
    this.features,
    this.targetingOptions,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromotionPlanDoc.fromJson(Map<String, dynamic> json) {
    return PromotionPlanDoc(
      id: json['id'],
      basePrice: json['basePrice'],
      description: json['description'],
      durationDays: json['durationDays'],
      name: json['name'],
      serviceType: json['serviceType'],
      isActive: json['isActive'],
      features: json['features'],
      targetingOptions: json['targetingOptions'],
      deletedAt: json['deletedAt'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PromotionMetadata {
  final int offset;
  final bool searchApplied;
  final List<dynamic> searchFields;
  final Map<String, dynamic> appliedFilters;

  PromotionMetadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  factory PromotionMetadata.fromJson(Map<String, dynamic> json) {
    return PromotionMetadata(
      offset: json['offset'],
      searchApplied: json['searchApplied'],
      searchFields: json['searchFields'],
      appliedFilters: json['appliedFilters'],
    );
  }
}
