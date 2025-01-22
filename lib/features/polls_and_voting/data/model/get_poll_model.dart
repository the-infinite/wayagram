import 'dart:convert';
GetPollModel getPollModelFromJson(String str) => GetPollModel.fromJson(json.decode(str));
String getPollModelToJson(GetPollModel data) => json.encode(data.toJson());
class GetPollModel {
  GetPollModel({
      this.success, 
      this.data, 
      this.meta,});

  GetPollModel.fromJson(dynamic json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetPollData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  bool? success;
  List<GetPollData>? data;
  Meta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    return map;
  }

}

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
String metaToJson(Meta data) => json.encode(data.toJson());
class Meta {
  Meta({
      this.timestamp,});

  Meta.fromJson(dynamic json) {
    timestamp = json['timestamp'];
  }
  String? timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    return map;
  }

}

GetPollData dataFromJson(String str) => GetPollData.fromJson(json.decode(str));
String dataToJson(GetPollData data) => json.encode(data.toJson());
class GetPollData {
  GetPollData({
      this.id, 
      this.creatorId, 
      this.isPaid, 
      this.isSettled, 
      this.question, 
      this.startDate, 
      this.endDate, 
      this.maxVotesPerUser, 
      this.pollType, 
      this.feePerVote, 
      this.createdAt, 
      this.updatedAt,
      this.choices,});

  GetPollData.fromJson(dynamic json) {
    id = json['id'];
    creatorId = json['creatorId'];
    isPaid = json['isPaid'];
    isSettled = json['isSettled'];
    question = json['question'];
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
        choices?.add(Choices.fromJson(v));
      });
    }
  }
  String? id;
  String? creatorId;
  bool? isPaid;
  bool? isSettled;
  String? question;
  String? startDate;
  String? endDate;
  int? maxVotesPerUser;
  String? pollType;
  String? feePerVote;
  String? createdAt;
  String? updatedAt;
  List<Choices>? choices;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creatorId'] = creatorId;
    map['isPaid'] = isPaid;
    map['isSettled'] = isSettled;
    map['question'] = question;
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

Choices choicesFromJson(String str) => Choices.fromJson(json.decode(str));
String choicesToJson(Choices data) => json.encode(data.toJson());
class Choices {
  Choices({
      this.id, 
      this.pollId, 
      this.text, 
      this.description, 
      this.imageUrl, 
      this.order, 
      this.createdAt, 
      this.updatedAt,
  });

  Choices.fromJson(dynamic json) {
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
  int? order;
  String? createdAt;
  String? updatedAt;

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