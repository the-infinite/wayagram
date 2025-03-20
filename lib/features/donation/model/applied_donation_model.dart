import 'dart:convert';
AppliedDonationModel appliedDonationModelFromJson(String str) => AppliedDonationModel.fromJson(json.decode(str));
String appliedDonationModelToJson(AppliedDonationModel data) => json.encode(data.toJson());
class AppliedDonationModel {
  AppliedDonationModel({
      this.message, 
      this.status, 
      this.statusCode,
      this.data, 
      this.responseCode,});

  AppliedDonationModel.fromJson(dynamic json) {
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
AppliedDonationModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => AppliedDonationModel(  message: message ?? this.message,
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
        docs?.add(AppliedDonationDocs.fromJson(v));
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
  List<AppliedDonationDocs>? docs;
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
Data copyWith({  List<AppliedDonationDocs>? docs,
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
    searchFields = json['searchFields'] != null ? json['searchFields'].cast<String>() : [];
    appliedFilters = json['appliedFilters'];
  }
  num? offset;
  bool? searchApplied;
  List<String>? searchFields;
  dynamic appliedFilters;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<String>? searchFields,
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
    map['searchFields'] = searchFields;
    map['appliedFilters'] = appliedFilters;
    return map;
  }

}

AppliedDonationDocs docsFromJson(String str) => AppliedDonationDocs.fromJson(json.decode(str));
String docsToJson(AppliedDonationDocs data) => json.encode(data.toJson());
class AppliedDonationDocs {
  AppliedDonationDocs({
      this.id, 
      this.title, 
      this.isSettled, 
      this.donationCount, 
      this.description, 
      this.solution, 
      this.impact, 
      this.organizerId, 
      this.category, 
      this.targetAmount, 
      this.showRaised, 
      this.minimumDonationAmount, 
      this.amountRaised, 
      this.expirationDate, 
      this.startDate, 
      this.status, 
      this.privacy, 
      this.imageURL, 
      this.contributorsVisible, 
      this.url, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.donations, 
      this.organizer,});

  AppliedDonationDocs.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isSettled = json['isSettled'];
    donationCount = json['donationCount'];
    description = json['description'];
    solution = json['solution'];
    impact = json['impact'];
    organizerId = json['organizerId'];
    category = json['category'];
    targetAmount = json['targetAmount'];
    showRaised = json['showRaised'];
    minimumDonationAmount = json['minimumDonationAmount'];
    amountRaised = json['amountRaised'];
    expirationDate = json['expirationDate'];
    startDate = json['startDate'];
    status = json['status'];
    privacy = json['privacy'];
    imageURL = json['imageURL'];
    contributorsVisible = json['contributorsVisible'];
    url = json['url'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['donations'] != null) {
      donations = [];
      json['donations'].forEach((v) {
        donations?.add(Donations.fromJson(v));
      });
    }
    organizer = json['organizer'];
  }
  String? id;
  String? title;
  bool? isSettled;
  int? donationCount;
  String? description;
  String? solution;
  String? impact;
  String? organizerId;
  String? category;
  String? targetAmount;
  bool? showRaised;
  String? minimumDonationAmount;
  String? amountRaised;
  String? expirationDate;
  String? startDate;
  String? status;
  String? privacy;
  String? imageURL;
  bool? contributorsVisible;
  String? url;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  List<Donations>? donations;
  dynamic organizer;
  AppliedDonationDocs copyWith({  String? id,
  String? title,
  bool? isSettled,
  int? donationCount,
  String? description,
  String? solution,
  String? impact,
  String? organizerId,
  String? category,
  String? targetAmount,
  bool? showRaised,
  String? minimumDonationAmount,
  String? amountRaised,
  String? expirationDate,
  String? startDate,
  String? status,
  String? privacy,
  String? imageURL,
  bool? contributorsVisible,
  String? url,
  bool? isDeleted,
  String? createdAt,
  String? updatedAt,
  List<Donations>? donations,
  dynamic organizer,
}) => AppliedDonationDocs(  id: id ?? this.id,
  title: title ?? this.title,
  isSettled: isSettled ?? this.isSettled,
  donationCount: donationCount ?? this.donationCount,
  description: description ?? this.description,
  solution: solution ?? this.solution,
  impact: impact ?? this.impact,
  organizerId: organizerId ?? this.organizerId,
  category: category ?? this.category,
  targetAmount: targetAmount ?? this.targetAmount,
  showRaised: showRaised ?? this.showRaised,
  minimumDonationAmount: minimumDonationAmount ?? this.minimumDonationAmount,
  amountRaised: amountRaised ?? this.amountRaised,
  expirationDate: expirationDate ?? this.expirationDate,
  startDate: startDate ?? this.startDate,
  status: status ?? this.status,
  privacy: privacy ?? this.privacy,
  imageURL: imageURL ?? this.imageURL,
  contributorsVisible: contributorsVisible ?? this.contributorsVisible,
  url: url ?? this.url,
  isDeleted: isDeleted ?? this.isDeleted,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  donations: donations ?? this.donations,
  organizer: organizer ?? this.organizer,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['isSettled'] = isSettled;
    map['donationCount'] = donationCount;
    map['description'] = description;
    map['solution'] = solution;
    map['impact'] = impact;
    map['organizerId'] = organizerId;
    map['category'] = category;
    map['targetAmount'] = targetAmount;
    map['showRaised'] = showRaised;
    map['minimumDonationAmount'] = minimumDonationAmount;
    map['amountRaised'] = amountRaised;
    map['expirationDate'] = expirationDate;
    map['startDate'] = startDate;
    map['status'] = status;
    map['privacy'] = privacy;
    map['imageURL'] = imageURL;
    map['contributorsVisible'] = contributorsVisible;
    map['url'] = url;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (donations != null) {
      map['donations'] = donations?.map((v) => v.toJson()).toList();
    }
    map['organizer'] = organizer;
    return map;
  }

}

Donations donationsFromJson(String str) => Donations.fromJson(json.decode(str));
String donationsToJson(Donations data) => json.encode(data.toJson());
class Donations {
  Donations({
      this.id, 
      this.campaignId, 
      this.donorId, 
      this.amount, 
      this.status, 
      this.message, 
      this.isAnonymous, 
      this.transactionReference, 
      this.paymentMethod, 
      this.createdAt, 
      this.updatedAt,});

  Donations.fromJson(dynamic json) {
    id = json['id'];
    campaignId = json['campaignId'];
    donorId = json['donorId'];
    amount = json['amount'];
    status = json['status'];
    message = json['message'];
    isAnonymous = json['isAnonymous'];
    transactionReference = json['transactionReference'];
    paymentMethod = json['paymentMethod'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? campaignId;
  String? donorId;
  String? amount;
  String? status;
  String? message;
  bool? isAnonymous;
  String? transactionReference;
  dynamic paymentMethod;
  String? createdAt;
  String? updatedAt;
Donations copyWith({  String? id,
  String? campaignId,
  String? donorId,
  String? amount,
  String? status,
  String? message,
  bool? isAnonymous,
  String? transactionReference,
  dynamic paymentMethod,
  String? createdAt,
  String? updatedAt,
}) => Donations(  id: id ?? this.id,
  campaignId: campaignId ?? this.campaignId,
  donorId: donorId ?? this.donorId,
  amount: amount ?? this.amount,
  status: status ?? this.status,
  message: message ?? this.message,
  isAnonymous: isAnonymous ?? this.isAnonymous,
  transactionReference: transactionReference ?? this.transactionReference,
  paymentMethod: paymentMethod ?? this.paymentMethod,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['campaignId'] = campaignId;
    map['donorId'] = donorId;
    map['amount'] = amount;
    map['status'] = status;
    map['message'] = message;
    map['isAnonymous'] = isAnonymous;
    map['transactionReference'] = transactionReference;
    map['paymentMethod'] = paymentMethod;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}