import 'dart:convert';
PollDashboardModel pollDashboardModelFromJson(String str) => PollDashboardModel.fromJson(json.decode(str));
String pollDashboardModelToJson(PollDashboardModel data) => json.encode(data.toJson());
class PollDashboardModel {
  PollDashboardModel({
      this.votes, 
      this.voteCount,
      this.moneyGenerated, 
      this.numberOfPeopleVoted,});

  PollDashboardModel.fromJson(dynamic json) {
    if (json['votes'] != null) {
      votes = [];
      json['votes'].forEach((v) {
        votes?.add(Votes.fromJson(v));
      });
    }
    voteCount = json['voteCount']??0;
    moneyGenerated = json['moneyGenerated']?? 0;
    numberOfPeopleVoted = json['numberOfPeopleVoted']??0;
  }
  List<Votes>? votes;
  int? voteCount;
  int? moneyGenerated;
  int? numberOfPeopleVoted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (votes != null) {
      map['votes'] = votes?.map((v) => v.toJson()).toList();
    }
    map['voteCount'] = voteCount;
    map['moneyGenerated'] = moneyGenerated;
    map['numberOfPeopleVoted'] = numberOfPeopleVoted;
    return map;
  }

}

Votes votesFromJson(String str) => Votes.fromJson(json.decode(str));
String votesToJson(Votes data) => json.encode(data.toJson());
class Votes {
  Votes({
      this.id, 
      this.pollId, 
      this.userId, 
      this.choiceId, 
      this.quantity, 
      this.paymentStatus, 
      this.amountPaid, 
      this.transactionFee, 
      this.transactionRef, 
      this.createdAt, 
      this.updatedAt,
      this.choice,});

  Votes.fromJson(dynamic json) {
    id = json['id'];
    pollId = json['pollId'];
    userId = json['userId'];
    choiceId = json['choiceId'];
    quantity = json['quantity'];
    paymentStatus = json['paymentStatus'];
    amountPaid = json['amountPaid'];
    transactionFee = json['transactionFee'];
    transactionRef = json['transactionRef'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    choice = json['choice'] != null ? Choice.fromJson(json['choice']) : null;
  }
  String? id;
  String? pollId;
  String? userId;
  String? choiceId;
  int? quantity;
  String? paymentStatus;
  String? amountPaid;
  String? transactionFee;
  String? transactionRef;
  String? createdAt;
  String? updatedAt;
  Choice? choice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pollId'] = pollId;
    map['userId'] = userId;
    map['choiceId'] = choiceId;
    map['quantity'] = quantity;
    map['paymentStatus'] = paymentStatus;
    map['amountPaid'] = amountPaid;
    map['transactionFee'] = transactionFee;
    map['transactionRef'] = transactionRef;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (choice != null) {
      map['choice'] = choice?.toJson();
    }
    return map;
  }

}

Choice choiceFromJson(String str) => Choice.fromJson(json.decode(str));
String choiceToJson(Choice data) => json.encode(data.toJson());
class Choice {
  Choice({
      this.id, 
      this.text,});

  Choice.fromJson(dynamic json) {
    id = json['id'];
    text = json['text'];
  }
  String? id;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    return map;
  }

}