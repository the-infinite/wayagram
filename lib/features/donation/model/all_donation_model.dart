import 'dart:convert';

import '../../../shared/model/base_model.dart';
AllDonationModel allDonationModelFromJson(String str) => AllDonationModel.fromJson(json.decode(str));
String allDonationModelToJson(AllDonationModel data) => json.encode(data.toJson());
class AllDonationModel {
  AllDonationModel({
      this.message, 
      this.status, 
      this.statusCode,
      this.data, 
      this.responseCode,});

  AllDonationModel.fromJson(dynamic json) {
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
AllDonationModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => AllDonationModel(  message: message ?? this.message,
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
        docs?.add(AllDonationDocs.fromJson(v));
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
  List<AllDonationDocs>? docs;
  num? totalDocs;
  num? limit;
  num? page;
  num? totalPages;
  bool? hasNextPage;
  num? nextPage;
  bool? hasPrevPage;
  dynamic prevPage;
  num? pagingCounter;
  Metadata? metadata;
Data copyWith({  List<AllDonationDocs>? docs,
  num? totalDocs,
  num? limit,
  num? page,
  num? totalPages,
  bool? hasNextPage,
  num? nextPage,
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

AllDonationDocs docsFromJson(String str) => AllDonationDocs.fromJson(json.decode(str));
String docsToJson(AllDonationDocs data) => json.encode(data.toJson());
class AllDonationDocs extends BaseModel<AllDonationDocs> {
  AllDonationDocs({
      this.id, 
      this.title, 
      this.description, 
      this.solution, 
      this.impact, 
      this.organizerId, 
      this.categories,
      this.donationCount,
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
      this.createdAt, 
      this.updatedAt, 
      this.organizer,});

  AllDonationDocs.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    solution = json['solution'];
    impact = json['impact'];
    organizerId = json['organizerId'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    donationCount = json['donationCount'];
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    organizer = json['organizer'] != null ? Organizer.fromJson(json['organizer']) : null;
  }
  String? id;
  String? title;
  String? description;
  String? solution;
  String? impact;
  String? organizerId;
  List<String>? categories;
  int? donationCount;
  String? targetAmount;
  bool? showRaised;
  String? minimumDonationAmount;
  String? amountRaised;
  String? expirationDate;
  dynamic startDate;
  String? status;
  String? privacy;
  String? imageURL;
  bool? contributorsVisible;
  String? url;
  String? createdAt;
  String? updatedAt;
  Organizer? organizer;
  AllDonationDocs copyWith({  String? id,
  String? title,
  String? description,
  String? solution,
  String? impact,
  String? organizerId,
  List<String>? categories,
  int? donationCount,
  String? targetAmount,
  bool? showRaised,
  String? minimumDonationAmount,
  String? amountRaised,
  String? expirationDate,
  dynamic startDate,
  String? status,
  String? privacy,
  String? imageURL,
  bool? contributorsVisible,
  String? url,
  String? createdAt,
  String? updatedAt,
  Organizer? organizer,
}) => AllDonationDocs(  id: id ?? this.id,
  title: title ?? this.title,
  description: description ?? this.description,
  solution: solution ?? this.solution,
  impact: impact ?? this.impact,
  organizerId: organizerId ?? this.organizerId,
  categories: categories ?? this.categories,
    donationCount: donationCount ?? this.donationCount,
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
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  organizer: organizer ?? this.organizer,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['solution'] = solution;
    map['impact'] = impact;
    map['organizerId'] = organizerId;
    map['categories'] = categories;
    map['donationCount'] = donationCount;
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
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (organizer != null) {
      map['organizer'] = organizer?.toJson();
    }
    return map;
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    "title": title,
    // "organizerName": organizerName,

  };

}

Organizer organizerFromJson(String str) => Organizer.fromJson(json.decode(str));
String organizerToJson(Organizer data) => json.encode(data.toJson());
class Organizer {
  Organizer({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.username, 
      this.email, 
      this.profilePicture, 
      this.createdAt, 
      this.updatedAt,});

  Organizer.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? firstName;
  String? lastName;
  dynamic username;
  String? email;
  String? profilePicture;
  String? createdAt;
  String? updatedAt;
Organizer copyWith({  String? id,
  String? firstName,
  String? lastName,
  dynamic username,
  String? email,
  String? profilePicture,
  String? createdAt,
  String? updatedAt,
}) => Organizer(  id: id ?? this.id,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  username: username ?? this.username,
  email: email ?? this.email,
  profilePicture: profilePicture ?? this.profilePicture,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['email'] = email;
    map['profilePicture'] = profilePicture;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}