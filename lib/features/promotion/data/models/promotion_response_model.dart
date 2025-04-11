class PromotionResponse {
  final String message;
  final bool status;
  final int statusCode;
  final PromotionData? data;
  final int responseCode;

  PromotionResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
    required this.responseCode,
  });

  factory PromotionResponse.fromJson(Map<String, dynamic> json) {
    return PromotionResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null ? PromotionData.fromJson(json['data']) : null,
      responseCode: json['responseCode'] ?? 0,
    );
  }
}

class PromotionData {
  final List<Promotion> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;
  final Metadata metadata;

  PromotionData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.nextPage,
    required this.hasPrevPage,
    required this.prevPage,
    required this.pagingCounter,
    required this.metadata,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      docs: List<Promotion>.from((json['docs'] ?? []).map((e) => Promotion.fromJson(e))),
      totalDocs: json['totalDocs'] ?? 0,
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'] ?? false,
      prevPage: json['prevPage'],
      pagingCounter: json['pagingCounter'] ?? 0,
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
    );
  }
}

class Promotion {
  final String id;
  final String userId;
  final String planId;
  final String contentId;
  final String contentType;
  final double budget;
  final double? dailyBudget;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final dynamic metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  Promotion({
    required this.id,
    required this.userId,
    required this.planId,
    required this.contentId,
    required this.contentType,
    required this.budget,
    this.dailyBudget,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      planId: json['planId'] ?? '',
      contentId: json['contentId'] ?? '',
      contentType: json['contentType'] ?? '',
      budget: double.tryParse(json['budget'].toString()) ?? 0.0,
      dailyBudget: json['dailyBudget'] != null
          ? double.tryParse(json['dailyBudget'].toString())
          : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'] ?? '',
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Promotion copyWith({
    String? id,
    String? userId,
    String? planId,
    String? contentId,
    String? contentType,
    double? budget,
    double? dailyBudget,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    dynamic metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      budget: budget ?? this.budget,
      dailyBudget: dailyBudget ?? this.dailyBudget,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


class Metadata {
  final int offset;
  final bool searchApplied;
  final List<dynamic> searchFields;
  final Map<String, dynamic> appliedFilters;

  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      offset: json['offset'] ?? 0,
      searchApplied: json['searchApplied'] ?? false,
      searchFields: json['searchFields'] ?? [],
      appliedFilters: Map<String, dynamic>.from(json['appliedFilters'] ?? {}),
    );
  }
}
