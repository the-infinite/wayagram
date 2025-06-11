import 'dart:convert';
GetAllPayoutModel getAllPayoutModelFromJson(String str) => GetAllPayoutModel.fromJson(json.decode(str));
String getAllPayoutModelToJson(GetAllPayoutModel data) => json.encode(data.toJson());
class GetAllPayoutModel {
  GetAllPayoutModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  GetAllPayoutModel.fromJson(dynamic json) {
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
GetAllPayoutModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => GetAllPayoutModel(  message: message ?? this.message,
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
        docs?.add(PollPayoutDocs.fromJson(v));
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
  List<PollPayoutDocs>? docs;
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
Data copyWith({  List<PollPayoutDocs>? docs,
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
    // if (json['searchFields'] != null) {
    //   searchFields = [];
    //   json['searchFields'].forEach((v) {
    //     searchFields?.add(Dynamic.fromJson(v));
    //   });
    // }
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

PollPayoutDocs docsFromJson(String str) => PollPayoutDocs.fromJson(json.decode(str));
String docsToJson(PollPayoutDocs data) => json.encode(data.toJson());
class PollPayoutDocs {
  PollPayoutDocs({
      this.id, 
      this.pollId, 
      this.status, 
      this.settledAt, 
      this.userId, 
      this.createdAt, 
      this.updatedAt, 
      this.poll,});

  PollPayoutDocs.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    status = json['status'];
    settledAt = json['settledAt'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    poll = json['poll'] != null ? Poll.fromJson(json['poll']) : null;
  }
  String? id;
  String? pollId;
  String? status;
  dynamic settledAt;
  String? userId;
  String? createdAt;
  String? updatedAt;
  Poll? poll;
  PollPayoutDocs copyWith({  String? id,
  String? pollId,
  String? status,
  dynamic settledAt,
  String? userId,
  String? createdAt,
  String? updatedAt,
  Poll? poll,
}) => PollPayoutDocs(  id: id ?? this.id,
  pollId: pollId ?? this.pollId,
  status: status ?? this.status,
  settledAt: settledAt ?? this.settledAt,
  userId: userId ?? this.userId,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  poll: poll ?? this.poll,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pollId'] = pollId;
    map['status'] = status;
    map['settledAt'] = settledAt;
    map['userId'] = userId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (poll != null) {
      map['poll'] = poll?.toJson();
    }
    return map;
  }

}

Poll pollFromJson(String str) => Poll.fromJson(json.decode(str));
String pollToJson(Poll data) => json.encode(data.toJson());
class Poll {
  Poll({
      this.id, 
      this.categories, 
      this.creatorId, 
      this.isSettled, 
      this.question, 
      this.description, 
      this.url, 
      this.startDate, 
      this.endDate, 
      this.maxVotesPerUser, 
      this.pollType, 
      this.status, 
      this.pollStatus, 
      this.feePerVote, 
      this.voteCount, 
      this.numberOfVoters, 
      this.amountGenerated, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt,});

  Poll.fromJson(dynamic json) {
    id = json['id'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    creatorId = json['creatorId'];
    isSettled = json['isSettled'];
    question = json['question'];
    description = json['description'];
    url = json['url'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    maxVotesPerUser = json['maxVotesPerUser'];
    pollType = json['pollType'];
    status = json['status'];
    pollStatus = json['pollStatus'];
    feePerVote = json['feePerVote'];
    voteCount = json['voteCount'];
    numberOfVoters = json['numberOfVoters'];
    amountGenerated = json['amountGenerated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }
  String? id;
  List<String>? categories;
  String? creatorId;
  bool? isSettled;
  String? question;
  String? description;
  String? url;
  String? startDate;
  String? endDate;
  num? maxVotesPerUser;
  String? pollType;
  String? status;
  String? pollStatus;
  String? feePerVote;
  num? voteCount;
  num? numberOfVoters;
  String? amountGenerated;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
Poll copyWith({  String? id,
  List<String>? categories,
  String? creatorId,
  bool? isSettled,
  String? question,
  String? description,
  String? url,
  String? startDate,
  String? endDate,
  num? maxVotesPerUser,
  String? pollType,
  String? status,
  String? pollStatus,
  String? feePerVote,
  num? voteCount,
  num? numberOfVoters,
  String? amountGenerated,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
}) => Poll(  id: id ?? this.id,
  categories: categories ?? this.categories,
  creatorId: creatorId ?? this.creatorId,
  isSettled: isSettled ?? this.isSettled,
  question: question ?? this.question,
  description: description ?? this.description,
  url: url ?? this.url,
  startDate: startDate ?? this.startDate,
  endDate: endDate ?? this.endDate,
  maxVotesPerUser: maxVotesPerUser ?? this.maxVotesPerUser,
  pollType: pollType ?? this.pollType,
  status: status ?? this.status,
  pollStatus: pollStatus ?? this.pollStatus,
  feePerVote: feePerVote ?? this.feePerVote,
  voteCount: voteCount ?? this.voteCount,
  numberOfVoters: numberOfVoters ?? this.numberOfVoters,
  amountGenerated: amountGenerated ?? this.amountGenerated,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  deletedAt: deletedAt ?? this.deletedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categories'] = categories;
    map['creatorId'] = creatorId;
    map['isSettled'] = isSettled;
    map['question'] = question;
    map['description'] = description;
    map['url'] = url;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['maxVotesPerUser'] = maxVotesPerUser;
    map['pollType'] = pollType;
    map['status'] = status;
    map['pollStatus'] = pollStatus;
    map['feePerVote'] = feePerVote;
    map['voteCount'] = voteCount;
    map['numberOfVoters'] = numberOfVoters;
    map['amountGenerated'] = amountGenerated;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['deletedAt'] = deletedAt;
    return map;
  }

}