import 'dart:convert';
CreatePollResponse createPollResponseFromJson(String str) => CreatePollResponse.fromJson(json.decode(str));
String createPollResponseToJson(CreatePollResponse data) => json.encode(data.toJson());
class CreatePollResponse {
  CreatePollResponse({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  CreatePollResponse.fromJson(dynamic json) {
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
CreatePollResponse copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => CreatePollResponse(  message: message ?? this.message,
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
      this.voteCount, 
      this.numberOfVoters, 
      this.amountGenerated, 
      this.question, 
      this.isSettled, 
      this.creatorId, 
      this.startDate, 
      this.endDate, 
      this.url, 
      this.maxVotesPerUser, 
      this.pollType, 
      this.feePerVote, 
      this.id, 
      this.categories, 
      this.updatedAt, 
      this.createdAt, 
      this.deletedAt,});

  Data.fromJson(dynamic json) {
    voteCount = json['voteCount'];
    numberOfVoters = json['numberOfVoters'];
    amountGenerated = json['amountGenerated'];
    question = json['question'];
    isSettled = json['isSettled'];
    creatorId = json['creatorId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    url = json['url'];
    maxVotesPerUser = json['maxVotesPerUser'];
    pollType = json['pollType'];
    feePerVote = json['feePerVote'];
    id = json['id'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
  }
  num? voteCount;
  num? numberOfVoters;
  String? amountGenerated;
  String? question;
  bool? isSettled;
  String? creatorId;
  String? startDate;
  String? endDate;
  String? url;
  num? maxVotesPerUser;
  String? pollType;
  String? feePerVote;
  String? id;
  List<String>? categories;
  String? updatedAt;
  String? createdAt;
  dynamic deletedAt;
Data copyWith({  num? voteCount,
  num? numberOfVoters,
  String? amountGenerated,
  String? question,
  bool? isSettled,
  String? creatorId,
  String? startDate,
  String? endDate,
  String? url,
  num? maxVotesPerUser,
  String? pollType,
  String? feePerVote,
  String? id,
  List<String>? categories,
  String? updatedAt,
  String? createdAt,
  dynamic deletedAt,
}) => Data(  voteCount: voteCount ?? this.voteCount,
  numberOfVoters: numberOfVoters ?? this.numberOfVoters,
  amountGenerated: amountGenerated ?? this.amountGenerated,
  question: question ?? this.question,
  isSettled: isSettled ?? this.isSettled,
  creatorId: creatorId ?? this.creatorId,
  startDate: startDate ?? this.startDate,
  endDate: endDate ?? this.endDate,
  url: url ?? this.url,
  maxVotesPerUser: maxVotesPerUser ?? this.maxVotesPerUser,
  pollType: pollType ?? this.pollType,
  feePerVote: feePerVote ?? this.feePerVote,
  id: id ?? this.id,
  categories: categories ?? this.categories,
  updatedAt: updatedAt ?? this.updatedAt,
  createdAt: createdAt ?? this.createdAt,
  deletedAt: deletedAt ?? this.deletedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['voteCount'] = voteCount;
    map['numberOfVoters'] = numberOfVoters;
    map['amountGenerated'] = amountGenerated;
    map['question'] = question;
    map['isSettled'] = isSettled;
    map['creatorId'] = creatorId;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['url'] = url;
    map['maxVotesPerUser'] = maxVotesPerUser;
    map['pollType'] = pollType;
    map['feePerVote'] = feePerVote;
    map['id'] = id;
    map['categories'] = categories;
    map['updatedAt'] = updatedAt;
    map['createdAt'] = createdAt;
    map['deletedAt'] = deletedAt;
    return map;
  }

}