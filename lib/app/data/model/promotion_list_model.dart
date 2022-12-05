import 'dart:convert';
/// id : "a1afb7b6-993d-472b-9c9b-755b77580210"
/// ProfileId : "98622e64-b997-4595-93b1-d516606eb20e"
/// PostId : "3866f518-d24c-4ca0-bc01-2da8dcd405d7"
/// EventId : null
/// PromotionPriceId : "f1812ef5-04d3-4b00-9c3b-b845ccd4cd58"
/// description : "You promoted your post: HI Everyone"
/// location : "More Likes and Comments, More Messages"
/// gender : "any"
/// currentState : "activate"
/// age : 2
/// age_range : [0,100]
/// qty : 1
/// interests : ["Acrobatics","3D games"]
/// locations : null
/// goals : ["More Messages","More Likes and Comments"]
/// estimated_reach : 10
/// viewCount : null
/// days : 1
/// estimated_time_left : "1670284800000"
/// user_budget : "4000"
/// millisecCreatedAt : "1670154979257"
/// millisecUpdatatedAt : "1670154979257"
/// shareCount : "0"
/// _v : "RGBA"
/// isDeleted : false
/// createdAt : "2022-12-05T07:54:57.487Z"
/// updatedAt : "2022-12-05T07:54:57.487Z"
/// PromotionPriceConfig : {"id":"f1812ef5-04d3-4b00-9c3b-b845ccd4cd58","ProfileId":null,"default_qty":2,"total_reach":"10","price":"4000","interval":"Daily","length_of_days":2,"millisecCreatedAt":"1654000478301","millisecUpdatatedAt":"1654000478301","_v":"RGBA","isDeleted":false,"createdAt":"2022-05-31T13:07:51.453Z","updatedAt":"2022-11-14T16:13:14.115Z"}

PromotionListModel promotionListModelFromJson(String str) => PromotionListModel.fromJson(json.decode(str));
String promotionListModelToJson(PromotionListModel data) => json.encode(data.toJson());
class PromotionListModel {
  PromotionListModel({
      String? id, 
      String? profileId, 
      String? postId, 
      dynamic eventId,
      String? promotionPriceId, 
      String? description, 
      String? location, 
      String? gender, 
      String? currentState, 
      num? age, 
      List<num>? ageRange, 
      num? qty, 
      List<String>? interests, 
      dynamic locations, 
      List<String>? goals, 
      num? estimatedReach, 
      dynamic viewCount, 
      num? days, 
      String? estimatedTimeLeft, 
      String? userBudget, 
      String? millisecCreatedAt, 
      String? millisecUpdatatedAt, 
      String? shareCount, 
      String? v, 
      bool? isDeleted, 
      String? createdAt, 
      String? updatedAt, 
      PromotionPriceConfig? promotionPriceConfig,}){
    _id = id;
    _profileId = profileId;
    _postId = postId;
    _eventId = eventId;
    _promotionPriceId = promotionPriceId;
    _description = description;
    _location = location;
    _gender = gender;
    _currentState = currentState;
    _age = age;
    _ageRange = ageRange;
    _qty = qty;
    _interests = interests;
    _locations = locations;
    _goals = goals;
    _estimatedReach = estimatedReach;
    _viewCount = viewCount;
    _days = days;
    _estimatedTimeLeft = estimatedTimeLeft;
    _userBudget = userBudget;
    _millisecCreatedAt = millisecCreatedAt;
    _millisecUpdatatedAt = millisecUpdatatedAt;
    _shareCount = shareCount;
    _v = v;
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _promotionPriceConfig = promotionPriceConfig;
}

  PromotionListModel.fromJson(dynamic json) {
    _id = json['id'];
    _profileId = json['ProfileId'];
    _postId = json['PostId'];
    _eventId = json['EventId'];
    _promotionPriceId = json['PromotionPriceId'];
    _description = json['description'];
    _location = json['location'];
    _gender = json['gender'];
    _currentState = json['currentState'];
    _age = json['age'];
    _ageRange = json['age_range'] != null ? json['age_range'].cast<num>() : [];
    _qty = json['qty'];
    _interests = json['interests'] != null ? json['interests'].cast<String>() : [];
    _locations = json['locations'];
    _goals = json['goals'] != null ? json['goals'].cast<String>() : [];
    _estimatedReach = json['estimated_reach'];
    _viewCount = json['viewCount'];
    _days = json['days'];
    _estimatedTimeLeft = json['estimated_time_left'];
    _userBudget = json['user_budget'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _millisecUpdatatedAt = json['millisecUpdatatedAt'];
    _shareCount = json['shareCount'];
    _v = json['_v'];
    _isDeleted = json['isDeleted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _promotionPriceConfig = json['PromotionPriceConfig'] != null ? PromotionPriceConfig.fromJson(json['PromotionPriceConfig']) : null;
  }
  String? _id;
  String? _profileId;
  String? _postId;
  dynamic _eventId;
  String? _promotionPriceId;
  String? _description;
  String? _location;
  String? _gender;
  String? _currentState;
  num? _age;
  List<num>? _ageRange;
  num? _qty;
  List<String>? _interests;
  dynamic _locations;
  List<String>? _goals;
  num? _estimatedReach;
  dynamic _viewCount;
  num? _days;
  String? _estimatedTimeLeft;
  String? _userBudget;
  String? _millisecCreatedAt;
  String? _millisecUpdatatedAt;
  String? _shareCount;
  String? _v;
  bool? _isDeleted;
  String? _createdAt;
  String? _updatedAt;
  PromotionPriceConfig? _promotionPriceConfig;
PromotionListModel copyWith({  String? id,
  String? profileId,
  String? postId,
  dynamic eventId,
  String? promotionPriceId,
  String? description,
  String? location,
  String? gender,
  String? currentState,
  num? age,
  List<num>? ageRange,
  num? qty,
  List<String>? interests,
  dynamic locations,
  List<String>? goals,
  num? estimatedReach,
  dynamic viewCount,
  num? days,
  String? estimatedTimeLeft,
  String? userBudget,
  String? millisecCreatedAt,
  String? millisecUpdatatedAt,
  String? shareCount,
  String? v,
  bool? isDeleted,
  String? createdAt,
  String? updatedAt,
  PromotionPriceConfig? promotionPriceConfig,
}) => PromotionListModel(  id: id ?? _id,
  profileId: profileId ?? _profileId,
  postId: postId ?? _postId,
  eventId: eventId ?? _eventId,
  promotionPriceId: promotionPriceId ?? _promotionPriceId,
  description: description ?? _description,
  location: location ?? _location,
  gender: gender ?? _gender,
  currentState: currentState ?? _currentState,
  age: age ?? _age,
  ageRange: ageRange ?? _ageRange,
  qty: qty ?? _qty,
  interests: interests ?? _interests,
  locations: locations ?? _locations,
  goals: goals ?? _goals,
  estimatedReach: estimatedReach ?? _estimatedReach,
  viewCount: viewCount ?? _viewCount,
  days: days ?? _days,
  estimatedTimeLeft: estimatedTimeLeft ?? _estimatedTimeLeft,
  userBudget: userBudget ?? _userBudget,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  millisecUpdatatedAt: millisecUpdatatedAt ?? _millisecUpdatatedAt,
  shareCount: shareCount ?? _shareCount,
  v: v ?? _v,
  isDeleted: isDeleted ?? _isDeleted,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  promotionPriceConfig: promotionPriceConfig ?? _promotionPriceConfig,
);
  String? get id => _id;
  String? get profileId => _profileId;
  String? get postId => _postId;
  dynamic get eventId => _eventId;
  String? get promotionPriceId => _promotionPriceId;
  String? get description => _description;
  String? get location => _location;
  String? get gender => _gender;
  String? get currentState => _currentState;
  num? get age => _age;
  List<num>? get ageRange => _ageRange;
  num? get qty => _qty;
  List<String>? get interests => _interests;
  dynamic get locations => _locations;
  List<String>? get goals => _goals;
  num? get estimatedReach => _estimatedReach;
  dynamic get viewCount => _viewCount;
  num? get days => _days;
  String? get estimatedTimeLeft => _estimatedTimeLeft;
  String? get userBudget => _userBudget;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get millisecUpdatatedAt => _millisecUpdatatedAt;
  String? get shareCount => _shareCount;
  String? get v => _v;
  bool? get isDeleted => _isDeleted;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  PromotionPriceConfig? get promotionPriceConfig => _promotionPriceConfig;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProfileId'] = _profileId;
    map['PostId'] = _postId;
    map['EventId'] = _eventId;
    map['PromotionPriceId'] = _promotionPriceId;
    map['description'] = _description;
    map['location'] = _location;
    map['gender'] = _gender;
    map['currentState'] = _currentState;
    map['age'] = _age;
    map['age_range'] = _ageRange;
    map['qty'] = _qty;
    map['interests'] = _interests;
    map['locations'] = _locations;
    map['goals'] = _goals;
    map['estimated_reach'] = _estimatedReach;
    map['viewCount'] = _viewCount;
    map['days'] = _days;
    map['estimated_time_left'] = _estimatedTimeLeft;
    map['user_budget'] = _userBudget;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['millisecUpdatatedAt'] = _millisecUpdatatedAt;
    map['shareCount'] = _shareCount;
    map['_v'] = _v;
    map['isDeleted'] = _isDeleted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_promotionPriceConfig != null) {
      map['PromotionPriceConfig'] = _promotionPriceConfig?.toJson();
    }
    return map;
  }

  static List<PromotionListModel> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => PromotionListModel.fromJson(item)).toList();
  }

}

/// id : "f1812ef5-04d3-4b00-9c3b-b845ccd4cd58"
/// ProfileId : null
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

PromotionPriceConfig promotionPriceConfigFromJson(String str) => PromotionPriceConfig.fromJson(json.decode(str));
String promotionPriceConfigToJson(PromotionPriceConfig data) => json.encode(data.toJson());
class PromotionPriceConfig {
  PromotionPriceConfig({
      String? id, 
      dynamic profileId, 
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

  PromotionPriceConfig.fromJson(dynamic json) {
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
  dynamic _profileId;
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
PromotionPriceConfig copyWith({  String? id,
  dynamic profileId,
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
}) => PromotionPriceConfig(  id: id ?? _id,
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
  dynamic get profileId => _profileId;
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

  static List<PromotionPriceConfig> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => PromotionPriceConfig.fromJson(item)).toList();
  }

}