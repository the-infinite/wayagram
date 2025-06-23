import 'dart:convert';
PayoutCommissionModel payoutCommissionModelFromJson(String str) => PayoutCommissionModel.fromJson(json.decode(str));
String payoutCommissionModelToJson(PayoutCommissionModel data) => json.encode(data.toJson());
class PayoutCommissionModel {
  PayoutCommissionModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  PayoutCommissionModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  Data? data;
  num? responseCode;
PayoutCommissionModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => PayoutCommissionModel(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
  responseCode: responseCode ?? this.responseCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['responseCode'] = responseCode;
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.docs, 
      this.totalDocs, 
      this.limit, 
      this.page, 
      this.totalPages, 
      this.hasNextPage, 
      this.nextPage, 
      this.hasPrevPage, 
      this.prevPage, 
      this.pagingCounter, 
      this.metadata,});

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(PayoutCommissionDocs.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    prevPage = json['prevPage'];
    pagingCounter = json['pagingCounter'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }
  List<PayoutCommissionDocs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  dynamic nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
  Metadata? metadata;
Data copyWith({  List<PayoutCommissionDocs>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  dynamic nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
  num? pagingCounter,
  Metadata? metadata,
}) => Data(  docs: docs ?? this.docs,
  totalDocs: totalDocs ?? this.totalDocs,
  limit: limit ?? this.limit,
  page: page ?? this.page,
  totalPages: totalPages ?? this.totalPages,
  hasNextPage: hasNextPage ?? this.hasNextPage,
  nextPage: nextPage ?? this.nextPage,
  hasPrevPage: hasPrevPage ?? this.hasPrevPage,
  prevPage: prevPage ?? this.prevPage,
  pagingCounter: pagingCounter ?? this.pagingCounter,
  metadata: metadata ?? this.metadata,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (docs != null) {
      map['docs'] = docs?.map((v) => v.toJson()).toList();
    }
    map['totalDocs'] = totalDocs;
    map['limit'] = limit;
    map['page'] = page;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['nextPage'] = nextPage;
    map['hasPrevPage'] = hasPrevPage;
    map['prevPage'] = prevPage;
    map['pagingCounter'] = pagingCounter;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    return map;
  }

}

Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
      this.offset, 
      this.searchApplied, 
      this.searchFields, 
      this.appliedFilters,});

  Metadata.fromJson(dynamic json) {
    offset = json['offset'];
    searchApplied = json['searchApplied'];
    searchFields = json['searchFields'];
    appliedFilters = json['appliedFilters'];
  }
  num? offset;
  bool? searchApplied;
  List<dynamic>? searchFields;
  dynamic appliedFilters;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<dynamic>? searchFields,
  dynamic appliedFilters,
}) => Metadata(  offset: offset ?? this.offset,
  searchApplied: searchApplied ?? this.searchApplied,
  searchFields: searchFields ?? this.searchFields,
  appliedFilters: appliedFilters ?? this.appliedFilters,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = offset;
    map['searchApplied'] = searchApplied;
    if (searchFields != null) {
      map['searchFields'] = searchFields?.map((v) => v.toJson()).toList();
    }
    map['appliedFilters'] = appliedFilters;
    return map;
  }

}

PayoutCommissionDocs docsFromJson(String str) => PayoutCommissionDocs.fromJson(json.decode(str));
String docsToJson(PayoutCommissionDocs data) => json.encode(data.toJson());
class PayoutCommissionDocs {
 PayoutCommissionDocs({
      this.id, 
      this.isPercentage, 
      this.isTier, 
      this.rate, 
      this.minAmount, 
      this.maxAmount, 
      this.currency, 
      this.service, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

 PayoutCommissionDocs.fromJson(dynamic json) {
    id = json['id'];
    isPercentage = json['isPercentage'];
    isTier = json['isTier'];
    rate = json['rate'];
    minAmount = json['minAmount'];
    maxAmount = json['maxAmount'];
    currency = json['currency'];
    service = json['service'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  bool? isPercentage;
  bool? isTier;
  String? rate;
  dynamic minAmount;
  dynamic maxAmount;
  String? currency;
  String? service;
  String? status;
  String? createdAt;
  String? updatedAt;
 PayoutCommissionDocs copyWith({  String? id,
  bool? isPercentage,
  bool? isTier,
  String? rate,
  dynamic minAmount,
  dynamic maxAmount,
  String? currency,
  String? service,
  String? status,
  String? createdAt,
  String? updatedAt,
}) => PayoutCommissionDocs(  id: id ?? this.id,
  isPercentage: isPercentage ?? this.isPercentage,
  isTier: isTier ?? this.isTier,
  rate: rate ?? this.rate,
  minAmount: minAmount ?? this.minAmount,
  maxAmount: maxAmount ?? this.maxAmount,
  currency: currency ?? this.currency,
  service: service ?? this.service,
  status: status ?? this.status,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['isPercentage'] = isPercentage;
    map['isTier'] = isTier;
    map['rate'] = rate;
    map['minAmount'] = minAmount;
    map['maxAmount'] = maxAmount;
    map['currency'] = currency;
    map['service'] = service;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}