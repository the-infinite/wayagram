import 'dart:convert';
CastVoteModel castVoteModelFromJson(String str) => CastVoteModel.fromJson(json.decode(str));
String castVoteModelToJson(CastVoteModel data) => json.encode(data.toJson());
class CastVoteModel {
  CastVoteModel({
      this.success,
      this.data, 
      this.meta,});

  CastVoteModel.fromJson(dynamic json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CastVoteData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  bool? success;
  List<CastVoteData>? data;
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

CastVoteData dataFromJson(String str) => CastVoteData.fromJson(json.decode(str));
String dataToJson(CastVoteData data) => json.encode(data.toJson());
class CastVoteData {
  CastVoteData({
      this.id, 
     required  this.pollId,
      this.userId, 
      this.choiceId, 
      this.quantity, 
      this.paymentStatus, 
      this.amountPaid, 
      this.transactionRef, 
      this.transactionFee, 
      this.updatedAt, 
      this.createdAt, 
      });

  CastVoteData.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    userId = json['userId'];
    choiceId = json['choiceId'];
    quantity = json['quantity'];
    paymentStatus = json['paymentStatus'];
    amountPaid = json['amountPaid'];
    transactionRef = json['transactionRef'];
    transactionFee = json['transactionFee'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? pollId;
  String? userId;
  String? choiceId;
  int? quantity;
  String? paymentStatus;
  String? amountPaid;
  String? transactionRef;
  String? transactionFee;
  String? updatedAt;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pollId'] = pollId;
    map['userId'] = userId;
    map['choiceId'] = choiceId;
    map['quantity'] = quantity;
    map['paymentStatus'] = paymentStatus;
    map['amountPaid'] = amountPaid;
    map['transactionRef'] = transactionRef;
    map['transactionFee'] = transactionFee;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}