import 'dart:convert';
/// id : "f1812ef5-04d3-4b00-9c3b-b845ccd4cd58"
/// ProfileId : ""
/// default_qty : 2
/// total_reach : "10"
/// price : "4000"
/// interval : "Daily"
/// length_of_days : 2
/// millisecCreatedAt : "1654000478301"
/// millisecUpdatatedAt : "1654000478301"
/// _v : "RGBA"
/// isDeleted : false
/// createdAt : "2022-05-31T13:07:51.453Z"
/// updatedAt : "2022-11-14T16:13:14.115Z"

PromotionPricingModel promotionPricingModelFromJson(String str) => PromotionPricingModel.fromJson(json.decode(str));
String promotionPricingModelToJson(PromotionPricingModel data) => json.encode(data.toJson());
class PromotionPricingModel {
  PromotionPricingModel({
      String? id, 
      String? profileId, 
      num? defaultQty, 
      String? totalReach, 
      String? price, 
      String? interval, 
      num? lengthOfDays,
      String? millisecCreatedAt, 
      String? millisecUpdatatedAt, 
      String? v, 
      bool? isDeleted, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _profileId = profileId;
    _defaultQty = defaultQty;
    _totalReach = totalReach;
    _price = price;
    _interval = interval;
    _lengthOfDays = lengthOfDays;
    _millisecCreatedAt = millisecCreatedAt;
    _millisecUpdatatedAt = millisecUpdatatedAt;
    _v = v;
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  PromotionPricingModel.fromJson(dynamic json) {
    _id = json['id'];
    _profileId = json['ProfileId'];
    _defaultQty = json['default_qty'];
    _totalReach = json['total_reach'];
    _price = json['price'];
    _interval = json['interval'];
    _lengthOfDays = json['length_of_days'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _millisecUpdatatedAt = json['millisecUpdatatedAt'];
    _v = json['_v'];
    _isDeleted = json['isDeleted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _profileId;
  num? _defaultQty;
  String? _totalReach;
  String? _price;
  String? _interval;
  num? _lengthOfDays;
  String? _millisecCreatedAt;
  String? _millisecUpdatatedAt;
  String? _v;
  bool? _isDeleted;
  String? _createdAt;
  String? _updatedAt;
PromotionPricingModel copyWith({  String? id,
  String? profileId,
  num? defaultQty,
  String? totalReach,
  String? price,
  String? interval,
  num? lengthOfDays,
  String? millisecCreatedAt,
  String? millisecUpdatatedAt,
  String? v,
  bool? isDeleted,
  String? createdAt,
  String? updatedAt,
}) => PromotionPricingModel(  id: id ?? _id,
  profileId: profileId ?? _profileId,
  defaultQty: defaultQty ?? _defaultQty,
  totalReach: totalReach ?? _totalReach,
  price: price ?? _price,
  interval: interval ?? _interval,
  lengthOfDays: lengthOfDays ?? _lengthOfDays,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  millisecUpdatatedAt: millisecUpdatatedAt ?? _millisecUpdatatedAt,
  v: v ?? _v,
  isDeleted: isDeleted ?? _isDeleted,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get profileId => _profileId;
  num? get defaultQty => _defaultQty;
  String? get totalReach => _totalReach;
  String? get price => _price;
  String? get interval => _interval;
  num? get lengthOfDays => _lengthOfDays;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get millisecUpdatatedAt => _millisecUpdatatedAt;
  String? get v => _v;
  bool? get isDeleted => _isDeleted;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProfileId'] = _profileId;
    map['default_qty'] = _defaultQty;
    map['total_reach'] = _totalReach;
    map['price'] = _price;
    map['interval'] = _interval;
    map['length_of_days'] = _lengthOfDays;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['millisecUpdatatedAt'] = _millisecUpdatatedAt;
    map['_v'] = _v;
    map['isDeleted'] = _isDeleted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

  static List<PromotionPricingModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => PromotionPricingModel.fromJson(item)).toList();
  }
}