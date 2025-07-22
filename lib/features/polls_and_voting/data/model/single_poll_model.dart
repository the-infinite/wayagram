import 'dart:convert';
SinglePollModel singlePollModelFromJson(String str) => SinglePollModel.fromJson(json.decode(str));
String singlePollModelToJson(SinglePollModel data) => json.encode(data.toJson());
class SinglePollModel {
  SinglePollModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  SinglePollModel.fromJson(dynamic json) {
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
SinglePollModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => SinglePollModel(  message: message ?? this.message,
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
      this.deletedAt, 
      this.choices, 
      this.userData, 
      this.remainingUserVotes,});

  Data.fromJson(dynamic json) {
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
    if (json['choices'] != null) {
      choices = [];
      json['choices'].forEach((v) {
        choices?.add(SinglePollChoices.fromJson(v));
      });
    }
    userData = json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    remainingUserVotes = json['remainingUserVotes'];
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
  List<SinglePollChoices>? choices;
  UserData? userData;
  num? remainingUserVotes;
Data copyWith({  String? id,
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
  List<SinglePollChoices>? choices,
  UserData? userData,
  num? remainingUserVotes,
}) => Data(  id: id ?? this.id,
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
  choices: choices ?? this.choices,
  userData: userData ?? this.userData,
  remainingUserVotes: remainingUserVotes ?? this.remainingUserVotes,
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
    if (choices != null) {
      map['choices'] = choices?.map((v) => v.toJson()).toList();
    }
    if (userData != null) {
      map['user_data'] = userData?.toJson();
    }
    map['remainingUserVotes'] = remainingUserVotes;
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
      this.username, 
      this.email, 
      this.profilePicture, 
      this.createdAt, 
      this.updatedAt,});

  UserData.fromJson(dynamic json) {
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
UserData copyWith({  String? id,
  String? firstName,
  String? lastName,
  dynamic username,
  String? email,
  dynamic profilePicture,
  String? createdAt,
  String? updatedAt,
}) => UserData(  id: id ?? this.id,
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

SinglePollChoices choicesFromJson(String str) => SinglePollChoices.fromJson(json.decode(str));
String choicesToJson(SinglePollChoices data) => json.encode(data.toJson());
class SinglePollChoices {
  SinglePollChoices({
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

  SinglePollChoices.fromJson(dynamic json) {
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
  }
  String? id;
  String? pollId;
  String? text;
  dynamic description;
  dynamic imageUrl;
  num? order;
  num? voteCount;
  num? uniqueVotes;
  String? createdAt;
  String? updatedAt;
  SinglePollChoices copyWith({  String? id,
  String? pollId,
  String? text,
  dynamic description,
  dynamic imageUrl,
  num? order,
  num? voteCount,
  num? uniqueVotes,
  String? createdAt,
  String? updatedAt,
}) => SinglePollChoices(  id: id ?? this.id,
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
    return map;
  }

}