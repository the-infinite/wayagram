import 'dart:convert';
WalletActivityModel walletActivityModelFromJson(String str) => WalletActivityModel.fromJson(json.decode(str));
String walletActivityModelToJson(WalletActivityModel data) => json.encode(data.toJson());
class WalletActivityModel {
  WalletActivityModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  WalletActivityModel.fromJson(dynamic json) {
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
WalletActivityModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => WalletActivityModel(  message: message ?? this.message,
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
        docs?.add(WalletActivityDocs.fromJson(v));
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
  List<WalletActivityDocs>? docs;
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
Data copyWith({  List<WalletActivityDocs>? docs,
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

/*
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
    if (json['searchFields'] != null) {
      searchFields = [];
      json['searchFields'].forEach((v) {
        searchFields?.add(Dynamic.fromJson(v));
      });
    }
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
*/

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

WalletActivityDocs docsFromJson(String str) => WalletActivityDocs.fromJson(json.decode(str));
String docsToJson(WalletActivityDocs data) => json.encode(data.toJson());
class WalletActivityDocs {
  WalletActivityDocs({
      this.id, 
      this.userId, 
      this.logType, 
      this.description, 
      this.actionType, 
      this.metadata, 
      this.createdAt, 
      this.updatedAt,});

  DateTime get createdTime => DateTime.parse(createdAt!);
  DateTime get updatedTime => DateTime.parse(updatedAt!);

  WalletActivityDocs.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    logType = json['logType'];
    description = json['description'];
    actionType = json['actionType'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? logType;
  String? description;
  String? actionType;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;
  WalletActivityDocs copyWith({  String? id,
  String? userId,
  String? logType,
  String? description,
  String? actionType,
  Metadata? metadata,
  String? createdAt,
  String? updatedAt,
}) => WalletActivityDocs(  id: id ?? this.id,
  userId: userId ?? this.userId,
  logType: logType ?? this.logType,
  description: description ?? this.description,
  actionType: actionType ?? this.actionType,
  metadata: metadata ?? this.metadata,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['logType'] = logType;
    map['description'] = description;
    map['actionType'] = actionType;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
      this.id, 
      this.fees, 
      this.type, 
      this.amount, 
      this.paidAt, 
      this.status, 
      this.userId, 
      this.purpose, 
      this.metadata, 
      this.senderId, 
      this.createdAt, 
      this.deletedAt, 
      this.netAmount, 
      this.updatedAt, 
      this.description, 
      this.recipientId, 
      this.referenceId, 
      this.paymentMethod, 
      this.transactionId,});

  Metadata.fromJson(dynamic json) {
    id = json['id'];
    fees = json['fees'];
    type = json['type'];
    amount = json['amount'];
    paidAt = json['paidAt'];
    status = json['status'];
    userId = json['userId'];
    purpose = json['purpose'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    senderId = json['senderId'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
    netAmount = json['netAmount'];
    updatedAt = json['updatedAt'];
    description = json['description'];
    recipientId = json['recipientId'];
    referenceId = json['referenceId'];
    paymentMethod = json['paymentMethod'];
    transactionId = json['transactionId'];
  }
  String? id;
  String? fees;
  String? type;
  String? amount;
  String? paidAt;
  String? status;
  String? userId;
  String? purpose;
  Metadata? metadata;
  String? senderId;
  String? createdAt;
  dynamic deletedAt;
  String? netAmount;
  String? updatedAt;
  String? description;
  String? recipientId;
  String? referenceId;
  String? paymentMethod;
  String? transactionId;
Metadata copyWith({  String? id,
  String? fees,
  String? type,
  String? amount,
  String? paidAt,
  String? status,
  String? userId,
  String? purpose,
  Metadata? metadata,
  String? senderId,
  String? createdAt,
  dynamic deletedAt,
  String? netAmount,
  String? updatedAt,
  String? description,
  String? recipientId,
  String? referenceId,
  String? paymentMethod,
  String? transactionId,
}) => Metadata(  id: id ?? this.id,
  fees: fees ?? this.fees,
  type: type ?? this.type,
  amount: amount ?? this.amount,
  paidAt: paidAt ?? this.paidAt,
  status: status ?? this.status,
  userId: userId ?? this.userId,
  purpose: purpose ?? this.purpose,
  metadata: metadata ?? this.metadata,
  senderId: senderId ?? this.senderId,
  createdAt: createdAt ?? this.createdAt,
  deletedAt: deletedAt ?? this.deletedAt,
  netAmount: netAmount ?? this.netAmount,
  updatedAt: updatedAt ?? this.updatedAt,
  description: description ?? this.description,
  recipientId: recipientId ?? this.recipientId,
  referenceId: referenceId ?? this.referenceId,
  paymentMethod: paymentMethod ?? this.paymentMethod,
  transactionId: transactionId ?? this.transactionId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['fees'] = fees;
    map['type'] = type;
    map['amount'] = amount;
    map['paidAt'] = paidAt;
    map['status'] = status;
    map['userId'] = userId;
    map['purpose'] = purpose;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    map['senderId'] = senderId;
    map['createdAt'] = createdAt;
    map['deletedAt'] = deletedAt;
    map['netAmount'] = netAmount;
    map['updatedAt'] = updatedAt;
    map['description'] = description;
    map['recipientId'] = recipientId;
    map['referenceId'] = referenceId;
    map['paymentMethod'] = paymentMethod;
    map['transactionId'] = transactionId;
    return map;
  }

}

/*
Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
      this.shopId,});

  Metadata.fromJson(dynamic json) {
    shopId = json['shopId'];
  }
  String? shopId;
Metadata copyWith({  String? shopId,
}) => Metadata(  shopId: shopId ?? this.shopId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['shopId'] = shopId;
    return map;
  }

}*/
