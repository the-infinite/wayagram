import 'dart:convert';
SingleDonationModel singleDonationModelFromJson(String str) => SingleDonationModel.fromJson(json.decode(str));
String singleDonationModelToJson(SingleDonationModel data) => json.encode(data.toJson());
class SingleDonationModel {
  SingleDonationModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  SingleDonationModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? SingleDonationData.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  SingleDonationData? data;
  num? responseCode;
SingleDonationModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  SingleDonationData? data,
  num? responseCode,
}) => SingleDonationModel(  message: message ?? this.message,
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

SingleDonationData dataFromJson(String str) => SingleDonationData.fromJson(json.decode(str));
String dataToJson(SingleDonationData data) => json.encode(data.toJson());
class SingleDonationData {
  SingleDonationData({
      this.id, 
      this.title, 
      this.isSettled, 
      this.donationCount, 
      this.description, 
      this.solution, 
      this.impact, 
      this.organizerId, 
      this.category, 
      this.targetAmount, 
      this.showRaised, 
      this.minimumDonationAmount, 
      this.amountRaised, 
      this.expirationDate, 
      this.startDate, 
      this.status, 
      this.privacy, 
      this.imageURL, 
      this.contributorsVisible, 
      this.url, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt,});

  SingleDonationData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isSettled = json['isSettled'];
    donationCount = json['donationCount'];
    description = json['description'];
    solution = json['solution'];
    impact = json['impact'];
    organizerId = json['organizerId'];
    category = json['category'];
    targetAmount = json['targetAmount'];
    showRaised = json['showRaised'];
    minimumDonationAmount = json['minimumDonationAmount'];
    amountRaised = json['amountRaised'];
    expirationDate = json['expirationDate'];
    startDate = json['startDate'];
    status = json['status'];
    privacy = json['privacy'];
    imageURL = json['imageURL'];
    contributorsVisible = json['contributorsVisible'];
    url = json['url'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? title;
  bool? isSettled;
  num? donationCount;
  String? description;
  String? solution;
  String? impact;
  String? organizerId;
  String? category;
  String? targetAmount;
  bool? showRaised;
  String? minimumDonationAmount;
  String? amountRaised;
  String? expirationDate;
  String? startDate;
  String? status;
  String? privacy;
  String? imageURL;
  bool? contributorsVisible;
  String? url;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  SingleDonationData copyWith({  String? id,
  String? title,
  bool? isSettled,
  num? donationCount,
  String? description,
  String? solution,
  String? impact,
  String? organizerId,
  String? category,
  String? targetAmount,
  bool? showRaised,
  String? minimumDonationAmount,
  String? amountRaised,
  String? expirationDate,
  String? startDate,
  String? status,
  String? privacy,
  String? imageURL,
  bool? contributorsVisible,
  String? url,
  bool? isDeleted,
  String? createdAt,
  String? updatedAt,
}) => SingleDonationData(  id: id ?? this.id,
  title: title ?? this.title,
  isSettled: isSettled ?? this.isSettled,
  donationCount: donationCount ?? this.donationCount,
  description: description ?? this.description,
  solution: solution ?? this.solution,
  impact: impact ?? this.impact,
  organizerId: organizerId ?? this.organizerId,
  category: category ?? this.category,
  targetAmount: targetAmount ?? this.targetAmount,
  showRaised: showRaised ?? this.showRaised,
  minimumDonationAmount: minimumDonationAmount ?? this.minimumDonationAmount,
  amountRaised: amountRaised ?? this.amountRaised,
  expirationDate: expirationDate ?? this.expirationDate,
  startDate: startDate ?? this.startDate,
  status: status ?? this.status,
  privacy: privacy ?? this.privacy,
  imageURL: imageURL ?? this.imageURL,
  contributorsVisible: contributorsVisible ?? this.contributorsVisible,
  url: url ?? this.url,
  isDeleted: isDeleted ?? this.isDeleted,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['isSettled'] = isSettled;
    map['donationCount'] = donationCount;
    map['description'] = description;
    map['solution'] = solution;
    map['impact'] = impact;
    map['organizerId'] = organizerId;
    map['category'] = category;
    map['targetAmount'] = targetAmount;
    map['showRaised'] = showRaised;
    map['minimumDonationAmount'] = minimumDonationAmount;
    map['amountRaised'] = amountRaised;
    map['expirationDate'] = expirationDate;
    map['startDate'] = startDate;
    map['status'] = status;
    map['privacy'] = privacy;
    map['imageURL'] = imageURL;
    map['contributorsVisible'] = contributorsVisible;
    map['url'] = url;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}