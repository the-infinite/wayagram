import 'dart:convert';
PollDashboardTwoModel pollDashboardTwoModelFromJson(String str) => PollDashboardTwoModel.fromJson(json.decode(str));
String pollDashboardTwoModelToJson(PollDashboardTwoModel data) => json.encode(data.toJson());
class PollDashboardTwoModel {
  PollDashboardTwoModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  PollDashboardTwoModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? PollDashboardTwoData.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  num? statusCode;
  PollDashboardTwoData? data;
  PollDashboardTwoModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  PollDashboardTwoData? data,
}) => PollDashboardTwoModel(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

PollDashboardTwoData dataFromJson(String str) => PollDashboardTwoData.fromJson(json.decode(str));
String dataToJson(PollDashboardTwoData data) => json.encode(data.toJson());
class PollDashboardTwoData {
  PollDashboardTwoData({
      this.votes, 
      this.voteCount, 
      this.moneyGenerated, 
      this.numberOfPeopleVoted,});

  PollDashboardTwoData.fromJson(dynamic json) {
    if (json['votes'] != null) {
      votes = [];
      json['votes'].forEach((v) {
        //votes?.add(Dynamic.fromJson(v));
      });
    }
    voteCount = json['voteCount'];
    moneyGenerated = json['moneyGenerated'];
    numberOfPeopleVoted = json['numberOfPeopleVoted'];
  }
  List<dynamic>? votes;
  num? voteCount;
  num? moneyGenerated;
  num? numberOfPeopleVoted;
  PollDashboardTwoData copyWith({  List<dynamic>? votes,
  num? voteCount,
  num? moneyGenerated,
  num? numberOfPeopleVoted,
}) => PollDashboardTwoData(  votes: votes ?? this.votes,
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