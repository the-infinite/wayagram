import 'package:get/get_utils/get_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

enum BuyRequestStatus {
  @JsonValue('not-started')
  notStarted,

  @JsonValue('active')
  active,

  @JsonValue('cancelled')
  cancelled,

  @JsonValue('closed')
  closed,
}

enum BuyRequestDeliveryType {
  @JsonValue('pickup')
  pickup,

  @JsonValue('delivery')
  delivery,
}

@JsonSerializable()
class BuyRequestModel {
  final String id;
  final String buyerId;
  final String productName;
  final String brand;
  final String category;
  final String condition;
  final String description;
  final int quantity;
  final DateTime bidStart;
  final DateTime bidEnd;
  final String deliveryDetails;
  final int minDistance;
  final int maxDistance;
  final String stateOfPurchase;
  final String lga;
  final bool vendorsCanSeeBidFromAnyDistance;
  final BuyRequestDeliveryType deliveryType;
  final String? deliveryAddress;
  final String? deliveryState;
  final String? deliveryLga;
  final double maxBidAmount;
  final double bidStartingAmount;
  final BuyRequestStatus status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  BuyRequestModel({
    required this.id,
    required this.buyerId,
    required this.productName,
    required this.brand,
    required this.category,
    required this.condition,
    required this.description,
    required this.quantity,
    required this.bidStart,
    required this.bidEnd,
    required this.deliveryDetails,
    required this.minDistance,
    required this.maxDistance,
    required this.stateOfPurchase,
    required this.lga,
    required this.vendorsCanSeeBidFromAnyDistance,
    required this.deliveryType,
    required this.maxBidAmount,
    required this.bidStartingAmount,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryAddress,
    this.deliveryState,
    this.deliveryLga,
  });

  String get fullname => '${brand.isNotEmpty ? '${brand.capitalize} ' : ''}${productName.capitalize}';

  factory BuyRequestModel.fromJson(Map<String, dynamic> json) => _$BuyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyRequestModelToJson(this);
}

@JsonSerializable()
class QuotationBidModel {
  QuotationBidModel();
  factory QuotationBidModel.fromJson(Map<String, dynamic> json) => _$QuotationBidModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuotationBidModelToJson(this);
}
