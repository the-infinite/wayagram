import 'dart:convert';
PollDashboardModel pollDashboardFromJson(String str) => PollDashboardModel.fromJson(json.decode(str));
String pollDashboardToJson(PollDashboardModel data) => json.encode(data.toJson());
class PollDashboardModel {
  PollDashboardModel({
      this.message,
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  PollDashboardModel.fromJson(dynamic json) {
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
PollDashboardModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => PollDashboardModel(  message: message ?? this.message,
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
        docs?.add(PollDashboardModelDocs.fromJson(v));
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
  List<PollDashboardModelDocs>? docs;
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
Data copyWith({  List<PollDashboardModelDocs>? docs,
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
      this.id,});

  AppliedFilters.fromJson(dynamic json) {
    id = json['id'];
  }
  String? id;
AppliedFilters copyWith({  String? id,
}) => AppliedFilters(  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

}

PollDashboardModelDocs docsFromJson(String str) => PollDashboardModelDocs.fromJson(json.decode(str));
String docsToJson(PollDashboardModelDocs data) => json.encode(data.toJson());
class PollDashboardModelDocs {
  PollDashboardModelDocs({
      this.id, 
      this.categories, 
      this.creatorId, 
      this.isSettled, 
      this.question, 
      this.url, 
      this.startDate, 
      this.endDate, 
      this.maxVotesPerUser, 
      this.pollType, 
      this.feePerVote, 
      this.voteCount, 
      this.numberOfVoters, 
      this.amountGenerated, 
      this.createdAt, 
      this.updatedAt,
      this.deletedAt, 
      this.choices, 
      this.userData,});

  PollDashboardModelDocs.fromJson(dynamic json) {
    id = json['id'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    creatorId = json['creatorId'];
    isSettled = json['isSettled'];
    question = json['question'];
    url = json['url'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    maxVotesPerUser = json['maxVotesPerUser'];
    pollType = json['pollType'];
    feePerVote = json['feePerVote'];
    voteCount = json['voteCount'];
    numberOfVoters = json['numberOfVoters'];
    amountGenerated = json['amountGenerated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deletedAt'];
    if (json['choices'] != null) {
      choices = [];
      json['choices'].forEach((v) {
        choices?.add(PollDashboardChoices.fromJson(v));
      });
      choices?.sort((first, second)=> (second.voteCount ?? 0) - (first.voteCount ?? 0) );
    }
    userData = json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
  }
  String? id;
  List<String>? categories;
  String? creatorId;
  bool? isSettled;
  String? question;
  String? url;
  String? startDate;
  String? endDate;
  num? maxVotesPerUser;
  String? pollType;
  String? feePerVote;
  int? voteCount;
  num? numberOfVoters;
  String? amountGenerated;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  List<PollDashboardChoices>? choices;
  UserData? userData;
  PollDashboardModelDocs copyWith({  String? id,
  List<String>? categories,
  String? creatorId,
  bool? isSettled,
  String? question,
  String? url,
  String? startDate,
  String? endDate,
  num? maxVotesPerUser,
  String? pollType,
  String? feePerVote,
  int? voteCount,
  num? numberOfVoters,
  String? amountGenerated,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
  List<PollDashboardChoices>? choices,
  UserData? userData,
}) => PollDashboardModelDocs(  id: id ?? this.id,
  categories: categories ?? this.categories,
  creatorId: creatorId ?? this.creatorId,
  isSettled: isSettled ?? this.isSettled,
  question: question ?? this.question,
  url: url ?? this.url,
  startDate: startDate ?? this.startDate,
  endDate: endDate ?? this.endDate,
  maxVotesPerUser: maxVotesPerUser ?? this.maxVotesPerUser,
  pollType: pollType ?? this.pollType,
  feePerVote: feePerVote ?? this.feePerVote,
  voteCount: voteCount ?? this.voteCount,
  numberOfVoters: numberOfVoters ?? this.numberOfVoters,
  amountGenerated: amountGenerated ?? this.amountGenerated,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  deletedAt: deletedAt ?? this.deletedAt,
  choices: choices ?? this.choices,
  userData: userData ?? this.userData,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categories'] = categories;
    map['creatorId'] = creatorId;
    map['isSettled'] = isSettled;
    map['question'] = question;
    map['url'] = url;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['maxVotesPerUser'] = maxVotesPerUser;
    map['pollType'] = pollType;
    map['feePerVote'] = feePerVote;
    map['voteCount'] = voteCount;
    map['numberOfVoters'] = numberOfVoters;
    map['amountGenerated'] = amountGenerated;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deletedAt'] = deletedAt;
    if (choices != null) {
      map['choices'] = choices?.map((v) => v.toJson()).toList();
    }
    if (userData != null) {
      map['user_data'] = userData?.toJson();
    }
    return map;
  }

}

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));
String userDataToJson(UserData data) => json.encode(data.toJson());
class UserData {
  UserData({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.profilePicture, 
      this.createdAt, 
      this.updatedAt,});

  UserData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;
  String? createdAt;
  String? updatedAt;
UserData copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? email,
  String? profilePicture,
  String? createdAt,
  String? updatedAt,
}) => UserData(  id: id ?? this.id,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
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
    map['email'] = email;
    map['profilePicture'] = profilePicture;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

PollDashboardChoices choicesFromJson(String str) => PollDashboardChoices.fromJson(json.decode(str));
String choicesToJson(PollDashboardChoices data) => json.encode(data.toJson());
class PollDashboardChoices {
  PollDashboardChoices({
      this.id, 
      this.pollId, 
      this.text, 
      this.description, 
      this.imageUrl, 
      this.order, 
      this.voteCount, 
      this.uniqueVotes, 
      this.createdAt, 
      this.updatedAt,});

  PollDashboardChoices.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    text = json['text'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    order = json['order'];
    voteCount = json['voteCount'];
    uniqueVotes = json['uniqueVotes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? pollId;
  String? text;
  String? description;
  String? imageUrl;
  num? order;
  int? voteCount;
  num? uniqueVotes;
  String? createdAt;
  String? updatedAt;
  PollDashboardChoices copyWith({  String? id,
  String? pollId,
  String? text,
  String? description,
  String? imageUrl,
  num? order,
  int? voteCount,
  num? uniqueVotes,
  String? createdAt,
  String? updatedAt,
}) => PollDashboardChoices(  id: id ?? this.id,
  pollId: pollId ?? this.pollId,
  text: text ?? this.text,
  description: description ?? this.description,
  imageUrl: imageUrl ?? this.imageUrl,
  order: order ?? this.order,
  voteCount: voteCount ?? this.voteCount,
  uniqueVotes: uniqueVotes ?? this.uniqueVotes,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pollId'] = pollId;
    map['text'] = text;
    map['description'] = description;
    map['imageUrl'] = imageUrl;
    map['order'] = order;
    map['voteCount'] = voteCount;
    map['uniqueVotes'] = uniqueVotes;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}