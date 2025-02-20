import 'dart:convert';
SingleDashboardModel singleDashboardModelFromJson(String str) => SingleDashboardModel.fromJson(json.decode(str));
String singleDashboardModelToJson(SingleDashboardModel data) => json.encode(data.toJson());
class SingleDashboardModel {
  SingleDashboardModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  SingleDashboardModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? SingleDashboardData.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  SingleDashboardData? data;
  num? responseCode;
SingleDashboardModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  SingleDashboardData? data,
  num? responseCode,
}) => SingleDashboardModel(  message: message ?? this.message,
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

SingleDashboardData dataFromJson(String str) => SingleDashboardData.fromJson(json.decode(str));
String dataToJson(SingleDashboardData data) => json.encode(data.toJson());
class SingleDashboardData {
  SingleDashboardData({
      this.votes, 
      this.voteCount, 
      this.moneyGenerated, 
      this.numberOfPeopleVoted,});

  SingleDashboardData.fromJson(dynamic json) {
    if (json['votes'] != null) {
      votes = [];
      json['votes'].forEach((v) {
        votes?.add(SingleDashboardVotes.fromJson(v));
      });
    }
    voteCount = json['voteCount'];
    moneyGenerated = json['moneyGenerated'];
    numberOfPeopleVoted = json['numberOfPeopleVoted'];
  }
  List<SingleDashboardVotes>? votes;
  num? voteCount;
  num? moneyGenerated;
  num? numberOfPeopleVoted;
  SingleDashboardData copyWith({  List<SingleDashboardVotes>? votes,
  num? voteCount,
  num? moneyGenerated,
  num? numberOfPeopleVoted,
}) => SingleDashboardData(  votes: votes ?? this.votes,
  voteCount: voteCount ?? this.voteCount,
  moneyGenerated: moneyGenerated ?? this.moneyGenerated,
  numberOfPeopleVoted: numberOfPeopleVoted ?? this.numberOfPeopleVoted,
);
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

SingleDashboardVotes votesFromJson(String str) => SingleDashboardVotes.fromJson(json.decode(str));
String votesToJson(SingleDashboardVotes data) => json.encode(data.toJson());
class SingleDashboardVotes {
  SingleDashboardVotes({
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

  SingleDashboardVotes.fromJson(dynamic json) {
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
    choice = json['choice'] != null ? Choices.fromJson(json['choice']) : null;
  }
  String? id;
  String? pollId;
  String? userId;
  String? choiceId;
  num? quantity;
  String? paymentStatus;
  String? amountPaid;
  String? transactionFee;
  dynamic transactionRef;
  String? createdAt;
  String? updatedAt;
  Choices? choice;
  SingleDashboardVotes copyWith({  String? id,
  String? pollId,
  String? userId,
  String? choiceId,
  num? quantity,
  String? paymentStatus,
  String? amountPaid,
  String? transactionFee,
  dynamic transactionRef,
  String? createdAt,
  String? updatedAt,
  Choices? choice,
}) => SingleDashboardVotes(  id: id ?? this.id,
  pollId: pollId ?? this.pollId,
  userId: userId ?? this.userId,
  choiceId: choiceId ?? this.choiceId,
  quantity: quantity ?? this.quantity,
  paymentStatus: paymentStatus ?? this.paymentStatus,
  amountPaid: amountPaid ?? this.amountPaid,
  transactionFee: transactionFee ?? this.transactionFee,
  transactionRef: transactionRef ?? this.transactionRef,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  choice: choice ?? this.choice,
);
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

Choices choiceFromJson(String str) => Choices.fromJson(json.decode(str));
String choiceToJson(Choices data) => json.encode(data.toJson());
class Choices {
  Choices({
      this.id, 
      this.text,});

  Choices.fromJson(dynamic json) {
    id = json['id'];
    text = json['text'];
  }
  String? id;
  String? text;
Choices copyWith({  String? id,
  String? text,
}) => Choices(  id: id ?? this.id,
  text: text ?? this.text,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    return map;
  }

}