import 'dart:convert';

import 'package:wayagram/shared/model/base_model.dart';
TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));
String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());
class TransactionModel {
  TransactionModel({
      this.message, 
      this.status,
      this.statusCode, 
      this.data, 
      this.responseCode,});

  TransactionModel.fromJson(dynamic json) {
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
TransactionModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => TransactionModel(  message: message ?? this.message,
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
      this.metadata, 
      this.totalCreditTransaction, 
      this.totalDebitTransaction,});

  Data.fromJson(dynamic json) {
    if (json['docs'] != null) {
      docs = [];
      json['docs'].forEach((v) {
        docs?.add(TransactionModelDocs.fromJson(v));
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
    totalCreditTransaction = json['totalCreditTransaction'];
    totalDebitTransaction = json['totalDebitTransaction'];
  }
  List<TransactionModelDocs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  int? nextPage;
  //num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
  Metadata? metadata;
  num? totalCreditTransaction;
  num? totalDebitTransaction;
Data copyWith({  List<TransactionModelDocs>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  //num? nextPage,
  int? nextPage,
  bool? hasPrevPage,
  dynamic prevPage,
  num? pagingCounter,
  Metadata? metadata,
  num? totalCreditTransaction,
  num? totalDebitTransaction,
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
  totalCreditTransaction: totalCreditTransaction ?? this.totalCreditTransaction,
  totalDebitTransaction: totalDebitTransaction ?? this.totalDebitTransaction,
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
    map['totalCreditTransaction'] = totalCreditTransaction;
    map['totalDebitTransaction'] = totalDebitTransaction;
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
    /*if (json['searchFields'] != null) {
      searchFields = [];
      json['searchFields'].forEach((v) {
        searchFields?.add(Dynamic.fromJson(v));
      });
    }*/
    appliedFilters = json['appliedFilters'] != null ? AppliedFilters.fromJson(json['appliedFilters']) : null;
  }
  num? offset;
  bool? searchApplied;
  List<dynamic>? searchFields;
  AppliedFilters? appliedFilters;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<dynamic>? searchFields,
  AppliedFilters? appliedFilters,
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
    if (appliedFilters != null) {
      map['appliedFilters'] = appliedFilters?.toJson();
    }
    return map;
  }

}

AppliedFilters appliedFiltersFromJson(String str) => AppliedFilters.fromJson(json.decode(str));
String appliedFiltersToJson(AppliedFilters data) => json.encode(data.toJson());
class AppliedFilters {
  AppliedFilters({
      this.userId,});

  AppliedFilters.fromJson(dynamic json) {
    userId = json['userId'];
  }
  String? userId;
AppliedFilters copyWith({  String? userId,
}) => AppliedFilters(  userId: userId ?? this.userId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    return map;
  }

}

TransactionModelDocs docsFromJson(String str) => TransactionModelDocs.fromJson(json.decode(str));
String docsToJson(TransactionModelDocs data) => json.encode(data.toJson());
class TransactionModelDocs extends BaseModel<TransactionModelDocs> {
  TransactionModelDocs({
      this.id, 
      this.userId, 
      this.amount, 
      this.fees, 
      this.type, 
      this.purpose, 
      this.senderId, 
      this.recipientId, 
      this.referenceId, 
      this.transactionId, 
      this.netAmount, 
      this.metadata, 
      this.status, 
      this.deletedAt, 
      this.paymentMethod, 
      this.description, 
      this.createdAt, 
      this.updatedAt,});

  TransactionModelDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    amount = json['amount'];
    fees = json['fees'];
    type = json['type'];
    purpose = json['purpose'];
    senderId = json['senderId'];
    recipientId = json['recipientId'];
    referenceId = json['referenceId'];
    transactionId = json['transactionId'];
    netAmount = json['netAmount'];
    metadata = json['metadata'];
    status = json['status'];
    deletedAt = json['deletedAt'];
    paymentMethod = json['paymentMethod'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? amount;
  String? fees;
  String? type;
  String? purpose;
  String? senderId;
  String? recipientId;
  String? referenceId;
  String? transactionId;
  String? netAmount;
  dynamic metadata;
  String? status;
  dynamic deletedAt;
  String? paymentMethod;
  String? description;
  String? createdAt;
  String? updatedAt;
  TransactionModelDocs copyWith({  String? id,
  String? userId,
  String? amount,
  String? fees,
  String? type,
  String? purpose,
  String? senderId,
  String? recipientId,
  String? referenceId,
  String? transactionId,
  String? netAmount,
  dynamic metadata,
  String? status,
  dynamic deletedAt,
  String? paymentMethod,
  String? description,
  String? createdAt,
  String? updatedAt,
}) => TransactionModelDocs(  id: id ?? this.id,
  userId: userId ?? this.userId,
  amount: amount ?? this.amount,
  fees: fees ?? this.fees,
  type: type ?? this.type,
  purpose: purpose ?? this.purpose,
  senderId: senderId ?? this.senderId,
  recipientId: recipientId ?? this.recipientId,
  referenceId: referenceId ?? this.referenceId,
  transactionId: transactionId ?? this.transactionId,
  netAmount: netAmount ?? this.netAmount,
  metadata: metadata ?? this.metadata,
  status: status ?? this.status,
  deletedAt: deletedAt ?? this.deletedAt,
  paymentMethod: paymentMethod ?? this.paymentMethod,
  description: description ?? this.description,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['amount'] = amount;
    map['fees'] = fees;
    map['type'] = type;
    map['purpose'] = purpose;
    map['senderId'] = senderId;
    map['recipientId'] = recipientId;
    map['referenceId'] = referenceId;
    map['transactionId'] = transactionId;
    map['netAmount'] = netAmount;
    map['metadata'] = metadata;
    map['status'] = status;
    map['deletedAt'] = deletedAt;
    map['paymentMethod'] = paymentMethod;
    map['description'] = description;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    "purpose": purpose,
    "description": description
  };

}