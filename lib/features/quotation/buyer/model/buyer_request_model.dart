import 'dart:convert';
BuyerRequestModel buyerRequestModelFromJson(String str) => BuyerRequestModel.fromJson(json.decode(str));
String buyerRequestModelToJson(BuyerRequestModel data) => json.encode(data.toJson());
class BuyerRequestModel {
  BuyerRequestModel({
      this.message, 
      this.status, 
      this.statusCode, 
      this.data,});

  BuyerRequestModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  bool? status;
  int? statusCode;
  Data? data;
BuyerRequestModel copyWith({  String? message,
  bool? status,
  int? statusCode,
  Data? data,
}) => BuyerRequestModel(  message: message ?? this.message,
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.buyerRequests, 
      this.metadata,});

  Data.fromJson(dynamic json) {
    if (json['buyerRequests'] != null) {
      buyerRequests = [];
      json['buyerRequests'].forEach((v) {
        buyerRequests?.add(BuyerRequests.fromJson(v));
      });
    }
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }
  List<BuyerRequests>? buyerRequests;
  Metadata? metadata;
Data copyWith({  List<BuyerRequests>? buyerRequests,
  Metadata? metadata,
}) => Data(  buyerRequests: buyerRequests ?? this.buyerRequests,
  metadata: metadata ?? this.metadata,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (buyerRequests != null) {
      map['buyerRequests'] = buyerRequests?.map((v) => v.toJson()).toList();
    }
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    return map;
  }

}

Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
      this.previousPage, 
      this.currentPage, 
      this.nextPage, 
      this.total, 
      this.limit,});

  Metadata.fromJson(dynamic json) {
    previousPage = json['previousPage'];
    currentPage = json['currentPage'];
    nextPage = json['nextPage'];
    total = json['total'];
    limit = json['limit'];
  }
  dynamic previousPage;
  int? currentPage;
  dynamic nextPage;
  int? total;
  int? limit;
Metadata copyWith({  dynamic previousPage,
  int? currentPage,
  dynamic nextPage,
  int? total,
  int? limit,
}) => Metadata(  previousPage: previousPage ?? this.previousPage,
  currentPage: currentPage ?? this.currentPage,
  nextPage: nextPage ?? this.nextPage,
  total: total ?? this.total,
  limit: limit ?? this.limit,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['previousPage'] = previousPage;
    map['currentPage'] = currentPage;
    map['nextPage'] = nextPage;
    map['total'] = total;
    map['limit'] = limit;
    return map;
  }

}

BuyerRequests buyerRequestsFromJson(String str) => BuyerRequests.fromJson(json.decode(str));
String buyerRequestsToJson(BuyerRequests data) => json.encode(data.toJson());
class BuyerRequests {
  BuyerRequests({
      this.id, 
      this.buyerId, 
      this.productName, 
      this.brand, 
      this.category, 
      this.condition, 
      this.description, 
      this.quantity, 
      this.bidStart, 
      this.bidEnd, 
      this.deliveryDetails, 
      this.minDistance, 
      this.maxDistance, 
      this.stateOfPurchase, 
      this.lga, 
      this.vendorsCanSeeBidFromAnyDistance, 
      this.deliveryType, 
      this.deliveryAddress, 
      this.deliveryState, 
      this.deliveryLga, 
      this.maxBidAmount, 
      this.bidStartingAmount, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  BuyerRequests.fromJson(dynamic json) {
    id = json['id'];
    buyerId = json['buyerId'];
    productName = json['productName'];
    brand = json['brand'];
    category = json['category'];
    condition = json['condition'];
    description = json['description'];
    quantity = json['quantity'];
    bidStart = json['bidStart'];
    bidEnd = json['bidEnd'];
    deliveryDetails = json['deliveryDetails'];
    minDistance = json['minDistance'];
    maxDistance = json['maxDistance'];
    stateOfPurchase = json['stateOfPurchase'];
    lga = json['lga'];
    vendorsCanSeeBidFromAnyDistance = json['vendorsCanSeeBidFromAnyDistance'];
    deliveryType = json['deliveryType'];
    deliveryAddress = json['deliveryAddress'];
    deliveryState = json['deliveryState'];
    deliveryLga = json['deliveryLga'];
    maxBidAmount = json['maxBidAmount'];
    bidStartingAmount = json['bidStartingAmount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? buyerId;
  String? productName;
  String? brand;
  String? category;
  String? condition;
  String? description;
  int? quantity;
  String? bidStart;
  String? bidEnd;
  String? deliveryDetails;
  int? minDistance;
  int? maxDistance;
  String? stateOfPurchase;
  String? lga;
  bool? vendorsCanSeeBidFromAnyDistance;
  String? deliveryType;
  String? deliveryAddress;
  String? deliveryState;
  String? deliveryLga;
  int? maxBidAmount;
  int? bidStartingAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
BuyerRequests copyWith({  String? id,
  String? buyerId,
  String? productName,
  String? brand,
  String? category,
  String? condition,
  String? description,
  int? quantity,
  String? bidStart,
  String? bidEnd,
  String? deliveryDetails,
  int? minDistance,
  int? maxDistance,
  String? stateOfPurchase,
  String? lga,
  bool? vendorsCanSeeBidFromAnyDistance,
  String? deliveryType,
  String? deliveryAddress,
  String? deliveryState,
  String? deliveryLga,
  int? maxBidAmount,
  int? bidStartingAmount,
  String? status,
  String? createdAt,
  String? updatedAt,
}) => BuyerRequests(  id: id ?? this.id,
  buyerId: buyerId ?? this.buyerId,
  productName: productName ?? this.productName,
  brand: brand ?? this.brand,
  category: category ?? this.category,
  condition: condition ?? this.condition,
  description: description ?? this.description,
  quantity: quantity ?? this.quantity,
  bidStart: bidStart ?? this.bidStart,
  bidEnd: bidEnd ?? this.bidEnd,
  deliveryDetails: deliveryDetails ?? this.deliveryDetails,
  minDistance: minDistance ?? this.minDistance,
  maxDistance: maxDistance ?? this.maxDistance,
  stateOfPurchase: stateOfPurchase ?? this.stateOfPurchase,
  lga: lga ?? this.lga,
  vendorsCanSeeBidFromAnyDistance: vendorsCanSeeBidFromAnyDistance ?? this.vendorsCanSeeBidFromAnyDistance,
  deliveryType: deliveryType ?? this.deliveryType,
  deliveryAddress: deliveryAddress ?? this.deliveryAddress,
  deliveryState: deliveryState ?? this.deliveryState,
  deliveryLga: deliveryLga ?? this.deliveryLga,
  maxBidAmount: maxBidAmount ?? this.maxBidAmount,
  bidStartingAmount: bidStartingAmount ?? this.bidStartingAmount,
  status: status ?? this.status,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['buyerId'] = buyerId;
    map['productName'] = productName;
    map['brand'] = brand;
    map['category'] = category;
    map['condition'] = condition;
    map['description'] = description;
    map['quantity'] = quantity;
    map['bidStart'] = bidStart;
    map['bidEnd'] = bidEnd;
    map['deliveryDetails'] = deliveryDetails;
    map['minDistance'] = minDistance;
    map['maxDistance'] = maxDistance;
    map['stateOfPurchase'] = stateOfPurchase;
    map['lga'] = lga;
    map['vendorsCanSeeBidFromAnyDistance'] = vendorsCanSeeBidFromAnyDistance;
    map['deliveryType'] = deliveryType;
    map['deliveryAddress'] = deliveryAddress;
    map['deliveryState'] = deliveryState;
    map['deliveryLga'] = deliveryLga;
    map['maxBidAmount'] = maxBidAmount;
    map['bidStartingAmount'] = bidStartingAmount;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}