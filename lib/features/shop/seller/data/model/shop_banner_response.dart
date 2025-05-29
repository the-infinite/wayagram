class BannerResponse {
  final String message;
  final bool status;
  final int statusCode;
  final BannerData data;

  BannerResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: BannerData.fromJson(json['data']),
    );
  }
}

class BannerData {
  final List<BannerDoc> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;
  final BannerMetadata metadata;

  BannerData({
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

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      docs: List<BannerDoc>.from(json['docs'].map((x) => BannerDoc.fromJson(x))),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      page: json['page'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'],
      prevPage: json['prevPage'],
      pagingCounter: json['pagingCounter'],
      metadata: BannerMetadata.fromJson(json['metadata']),
    );
  }
}

class BannerDoc {
  final String id;
  final String name;
  final String image;
  final String description;
  final String? startDate;
  final String? endDate;
  final bool isDeleted;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerDoc({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.startDate,
    this.endDate,
    required this.isDeleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerDoc.fromJson(Map<String, dynamic> json) {
    return BannerDoc(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      isDeleted: json['isDeleted'],
      version: json['_v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class BannerMetadata {
  final int offset;
  final bool searchApplied;
  final List<dynamic> searchFields;
  final Map<String, dynamic> appliedFilters;

  BannerMetadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  factory BannerMetadata.fromJson(Map<String, dynamic> json) {
    return BannerMetadata(
      offset: json['offset'],
      searchApplied: json['searchApplied'],
      searchFields: json['searchFields'],
      appliedFilters: json['appliedFilters'],
    );
  }
}
