import 'dart:convert';
RejectedDonationModel rejectedDonationModelFromJson(String str) => RejectedDonationModel.fromJson(json.decode(str));
String rejectedDonationModelToJson(RejectedDonationModel data) => json.encode(data.toJson());
class RejectedDonationModel {
  RejectedDonationModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  RejectedDonationModel.fromJson(dynamic json) {
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
RejectedDonationModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => RejectedDonationModel(  message: message ?? this.message,
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
        docs?.add(RejectedDonationDocs.fromJson(v));
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
  List<RejectedDonationDocs>? docs;
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
Data copyWith({  List<RejectedDonationDocs>? docs,
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
    appliedFilters = json['appliedFilters'] != null ? AppliedFilters.fromJson(json['appliedFilters']) : null;
  }
  num? offset;
  bool? searchApplied;
  List<String>? searchFields;
  AppliedFilters? appliedFilters;
Metadata copyWith({  num? offset,
  bool? searchApplied,
  List<String>? searchFields,
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
    map['searchFields'] = searchFields;
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
      this.status,});

  AppliedFilters.fromJson(dynamic json) {
    status = json['status'];
  }
  String? status;
AppliedFilters copyWith({  String? status,
}) => AppliedFilters(  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    return map;
  }

}

RejectedDonationDocs docsFromJson(String str) => RejectedDonationDocs.fromJson(json.decode(str));
String docsToJson(RejectedDonationDocs data) => json.encode(data.toJson());
class RejectedDonationDocs {
  RejectedDonationDocs({
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
      this.organizer,});

  RejectedDonationDocs.fromJson(dynamic json) {
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
    organizer = json['organizer'] != null ? Organizer.fromJson(json['organizer']) : null;
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
  Organizer? organizer;
  RejectedDonationDocs copyWith({  String? id,
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
  Organizer? organizer,
}) => RejectedDonationDocs(  id: id ?? this.id,
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
    if (organizer != null) {
      map['organizer'] = organizer?.toJson();
    }
    return map;
  }

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
  dynamic profilePicture;
  String? createdAt;
  String? updatedAt;
Organizer copyWith({  String? id,
  String? firstName,
  String? lastName,
  dynamic username,
  String? email,
  dynamic profilePicture,
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