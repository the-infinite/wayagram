import 'dart:convert';
CreateDonationResponse createDonationResponseFromJson(String str) => CreateDonationResponse.fromJson(json.decode(str));
String createDonationResponseToJson(CreateDonationResponse data) => json.encode(data.toJson());
class CreateDonationResponse {
  CreateDonationResponse({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  CreateDonationResponse.fromJson(dynamic json) {
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
CreateDonationResponse copyWith({  String? message,
  bool? status,
  num? statusCode,
  Data? data,
  num? responseCode,
}) => CreateDonationResponse(  message: message ?? this.message,
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
      this.showRaised, 
      this.amountRaised, 
      this.status, 
      this.contributorsVisible, 
      this.title, 
      this.description, 
      this.targetAmount, 
      this.startDate, 
      this.expirationDate, 
      this.minimumDonationAmount, 
      this.privacy, 
      this.solution, 
      this.impact, 
      this.imageURL, 
      this.organizerId, 
      this.id, 
      this.url, 
      this.categories, 
      this.updatedAt, 
      this.createdAt,});

  Data.fromJson(dynamic json) {
    showRaised = json['showRaised'];
    amountRaised = json['amountRaised'];
    status = json['status'];
    contributorsVisible = json['contributorsVisible'];
    title = json['title'];
    description = json['description'];
    targetAmount = json['targetAmount'];
    startDate = json['startDate'];
    expirationDate = json['expirationDate'];
    minimumDonationAmount = json['minimumDonationAmount'];
    privacy = json['privacy'];
    solution = json['solution'];
    impact = json['impact'];
    imageURL = json['imageURL'];
    organizerId = json['organizerId'];
    id = json['id'];
    url = json['url'];
    categories = json['categories'] != null ? json['categories'].cast<String>() : [];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }
  bool? showRaised;
  String? amountRaised;
  String? status;
  bool? contributorsVisible;
  String? title;
  String? description;
  String? targetAmount;
  dynamic startDate;
  String? expirationDate;
  String? minimumDonationAmount;
  String? privacy;
  String? solution;
  String? impact;
  String? imageURL;
  String? organizerId;
  String? id;
  String? url;
  List<String>? categories;
  String? updatedAt;
  String? createdAt;
Data copyWith({  bool? showRaised,
  String? amountRaised,
  String? status,
  bool? contributorsVisible,
  String? title,
  String? description,
  String? targetAmount,
  dynamic startDate,
  String? expirationDate,
  String? minimumDonationAmount,
  String? privacy,
  String? solution,
  String? impact,
  String? imageURL,
  String? organizerId,
  String? id,
  String? url,
  List<String>? categories,
  String? updatedAt,
  String? createdAt,
}) => Data(  showRaised: showRaised ?? this.showRaised,
  amountRaised: amountRaised ?? this.amountRaised,
  status: status ?? this.status,
  contributorsVisible: contributorsVisible ?? this.contributorsVisible,
  title: title ?? this.title,
  description: description ?? this.description,
  targetAmount: targetAmount ?? this.targetAmount,
  startDate: startDate ?? this.startDate,
  expirationDate: expirationDate ?? this.expirationDate,
  minimumDonationAmount: minimumDonationAmount ?? this.minimumDonationAmount,
  privacy: privacy ?? this.privacy,
  solution: solution ?? this.solution,
  impact: impact ?? this.impact,
  imageURL: imageURL ?? this.imageURL,
  organizerId: organizerId ?? this.organizerId,
  id: id ?? this.id,
  url: url ?? this.url,
  categories: categories ?? this.categories,
  updatedAt: updatedAt ?? this.updatedAt,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['showRaised'] = showRaised;
    map['amountRaised'] = amountRaised;
    map['status'] = status;
    map['contributorsVisible'] = contributorsVisible;
    map['title'] = title;
    map['description'] = description;
    map['targetAmount'] = targetAmount;
    map['startDate'] = startDate;
    map['expirationDate'] = expirationDate;
    map['minimumDonationAmount'] = minimumDonationAmount;
    map['privacy'] = privacy;
    map['solution'] = solution;
    map['impact'] = impact;
    map['imageURL'] = imageURL;
    map['organizerId'] = organizerId;
    map['id'] = id;
    map['url'] = url;
    map['categories'] = categories;
    map['updatedAt'] = updatedAt;
    map['createdAt'] = createdAt;
    return map;
  }

}