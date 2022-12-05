import 'dart:convert';
/// total_promotion_count : 3
/// total_promotion_ended : 0
/// total_promotion_live : 3
/// total_amount_spent : {"sum_total":"11000"}

PromotionAnalyticsModel promotionAnalyticsModelFromJson(String str) => PromotionAnalyticsModel.fromJson(json.decode(str));
String promotionAnalyticsModelToJson(PromotionAnalyticsModel data) => json.encode(data.toJson());
class PromotionAnalyticsModel {
  PromotionAnalyticsModel({
      num? totalPromotionCount, 
      num? totalPromotionEnded, 
      num? totalPromotionLive, 
      TotalAmountSpent? totalAmountSpent,}){
    _totalPromotionCount = totalPromotionCount;
    _totalPromotionEnded = totalPromotionEnded;
    _totalPromotionLive = totalPromotionLive;
    _totalAmountSpent = totalAmountSpent;
}

  PromotionAnalyticsModel.fromJson(dynamic json) {
    _totalPromotionCount = json['total_promotion_count'];
    _totalPromotionEnded = json['total_promotion_ended'];
    _totalPromotionLive = json['total_promotion_live'];
    _totalAmountSpent = json['total_amount_spent'] != null ? TotalAmountSpent.fromJson(json['total_amount_spent']) : null;
  }
  num? _totalPromotionCount;
  num? _totalPromotionEnded;
  num? _totalPromotionLive;
  TotalAmountSpent? _totalAmountSpent;
PromotionAnalyticsModel copyWith({  num? totalPromotionCount,
  num? totalPromotionEnded,
  num? totalPromotionLive,
  TotalAmountSpent? totalAmountSpent,
}) => PromotionAnalyticsModel(  totalPromotionCount: totalPromotionCount ?? _totalPromotionCount,
  totalPromotionEnded: totalPromotionEnded ?? _totalPromotionEnded,
  totalPromotionLive: totalPromotionLive ?? _totalPromotionLive,
  totalAmountSpent: totalAmountSpent ?? _totalAmountSpent,
);
  num? get totalPromotionCount => _totalPromotionCount;
  num? get totalPromotionEnded => _totalPromotionEnded;
  num? get totalPromotionLive => _totalPromotionLive;
  TotalAmountSpent? get totalAmountSpent => _totalAmountSpent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_promotion_count'] = _totalPromotionCount;
    map['total_promotion_ended'] = _totalPromotionEnded;
    map['total_promotion_live'] = _totalPromotionLive;
    if (_totalAmountSpent != null) {
      map['total_amount_spent'] = _totalAmountSpent?.toJson();
    }
    return map;
  }

}

/// sum_total : "11000"

TotalAmountSpent totalAmountSpentFromJson(String str) => TotalAmountSpent.fromJson(json.decode(str));
String totalAmountSpentToJson(TotalAmountSpent data) => json.encode(data.toJson());
class TotalAmountSpent {
  TotalAmountSpent({
      String? sumTotal,}){
    _sumTotal = sumTotal;
}

  TotalAmountSpent.fromJson(dynamic json) {
    _sumTotal = json['sum_total'];
  }
  String? _sumTotal;
TotalAmountSpent copyWith({  String? sumTotal,
}) => TotalAmountSpent(  sumTotal: sumTotal ?? _sumTotal,
);
  String? get sumTotal => _sumTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sum_total'] = _sumTotal;
    return map;
  }

}