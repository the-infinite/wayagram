import 'dart:convert';
VoteUrlModel voteUrlModelFromJson(String str) => VoteUrlModel.fromJson(json.decode(str));
String voteUrlModelToJson(VoteUrlModel data) => json.encode(data.toJson());
class VoteUrlModel {
  VoteUrlModel({
      this.message, 
      this.status, 
      this.statusCode,
      this.data, 
      this.responseCode,});

  VoteUrlModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? VoteUrlData.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  VoteUrlData? data;
  num? responseCode;
VoteUrlModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  VoteUrlData? data,
  num? responseCode,
}) => VoteUrlModel(  message: message ?? this.message,
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

VoteUrlData dataFromJson(String str) => VoteUrlData.fromJson(json.decode(str));
String dataToJson(VoteUrlData data) => json.encode(data.toJson());
class VoteUrlData {
  VoteUrlData({
      this.id, 
      this.creatorId, 
      this.isPaid, 
      this.isSettled, 
      this.question, 
      this.url, 
      this.startDate, 
      this.endDate, 
      this.maxVotesPerUser, 
      this.pollType, 
      this.feePerVote, 
      this.createdAt, 
      this.updatedAt,
      this.choices,});

  VoteUrlData.fromJson(dynamic json) {
    id = json['id'];
    creatorId = json['creatorId'];
    isPaid = json['isPaid'];
    isSettled = json['isSettled'];
    question = json['question'];
    url = json['url'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    maxVotesPerUser = json['maxVotesPerUser'];
    pollType = json['pollType'];
    feePerVote = json['feePerVote'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['choices'] != null) {
      choices = [];
      json['choices'].forEach((v) {
        choices?.add(VoteUrlChoices.fromJson(v));
      });
    }
  }
  String? id;
  String? creatorId;
  bool? isPaid;
  bool? isSettled;
  String? question;
  String? url;
  String? startDate;
  String? endDate;
  num? maxVotesPerUser;
  String? pollType;
  String? feePerVote;
  String? createdAt;
  String? updatedAt;
  List<VoteUrlChoices>? choices;
  VoteUrlData copyWith({  String? id,
  String? creatorId,
  bool? isPaid,
  bool? isSettled,
  String? question,
  String? url,
  String? startDate,
  String? endDate,
  num? maxVotesPerUser,
  String? pollType,
  String? feePerVote,
  String? createdAt,
  String? updatedAt,
  List<VoteUrlChoices>? choices,
}) => VoteUrlData(  id: id ?? this.id,
  creatorId: creatorId ?? this.creatorId,
  isPaid: isPaid ?? this.isPaid,
  isSettled: isSettled ?? this.isSettled,
  question: question ?? this.question,
  url: url ?? this.url,
  startDate: startDate ?? this.startDate,
  endDate: endDate ?? this.endDate,
  maxVotesPerUser: maxVotesPerUser ?? this.maxVotesPerUser,
  pollType: pollType ?? this.pollType,
  feePerVote: feePerVote ?? this.feePerVote,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  choices: choices ?? this.choices,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creatorId'] = creatorId;
    map['isPaid'] = isPaid;
    map['isSettled'] = isSettled;
    map['question'] = question;
    map['url'] = url;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['maxVotesPerUser'] = maxVotesPerUser;
    map['pollType'] = pollType;
    map['feePerVote'] = feePerVote;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (choices != null) {
      map['choices'] = choices?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

VoteUrlChoices choicesFromJson(String str) => VoteUrlChoices.fromJson(json.decode(str));
String choicesToJson(VoteUrlChoices data) => json.encode(data.toJson());
class VoteUrlChoices {
  VoteUrlChoices({
      this.id, 
      this.pollId, 
      this.text, 
      this.description, 
      this.imageUrl, 
      this.order, 
      this.createdAt, 
      this.updatedAt, 
      });

  VoteUrlChoices.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    text = json['text'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    order = json['order'];
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
  String? createdAt;
  String? updatedAt;
  VoteUrlChoices copyWith({  String? id,
  String? pollId,
  String? text,
  String? description,
  String? imageUrl,
  num? order,
  String? createdAt,
  String? updatedAt,
}) => VoteUrlChoices(  id: id ?? this.id,
  pollId: pollId ?? this.pollId,
  text: text ?? this.text,
  description: description ?? this.description,
  imageUrl: imageUrl ?? this.imageUrl,
  order: order ?? this.order,
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
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}